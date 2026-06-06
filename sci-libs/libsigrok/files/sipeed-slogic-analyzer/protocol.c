/*
 * This file is part of the libsigrok project.
 *
 * Copyright (C) 2023 taorye <taorye@outlook.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <config.h>
#include "protocol.h"

static int handle_events(int fd, int revents, void *cb_data);

static void submit_data(void *data, size_t len, struct sr_dev_inst *sdi) {
	struct sr_datafeed_logic logic = {
		.length = len,
		.unitsize = 1,
		.data = data,
	};

	struct sr_datafeed_packet packet = {
		.type = SR_DF_LOGIC,
		.payload = &logic
	};

	sr_session_send(sdi, &packet);
}

static void LIBUSB_CALL receive_transfer(struct libusb_transfer *transfer) {

	int ret;
	const struct sr_dev_inst *sdi;
	struct dev_context *devc;
	struct sr_usb_dev_inst *usb;

	sdi  = transfer->user_data;
	devc = sdi->priv;
	usb  = sdi->conn;

	sr_dbg("usb status: %d", transfer->status);
	switch (transfer->status) {
		case LIBUSB_TRANSFER_COMPLETED: 
		case LIBUSB_TRANSFER_TIMED_OUT: { /* may have received some data */
			sr_dbg("\ttransfing: %u, transfered: %u, sum: %u/%u",
					devc->bytes_transferring, devc->bytes_transfered,
					(devc->bytes_transfered + devc->bytes_transferring),
					devc->bytes_need_transfer);

			devc->bytes_transfered += transfer->actual_length;
			devc->bytes_transferring -= transfer->length;

			if (transfer->actual_length == 0) {
				devc->transfers_used -= 1;
				break;
			}

			{
				uint8_t *ptr = transfer->buffer;
				size_t len = transfer->actual_length;
				if (devc->cur_samplechannel != 8) {
					size_t step = 8 / devc->cur_samplechannel;
					uint8_t mask = 0xff >> (8 - devc->cur_samplechannel);
					len *= step;
					ptr = g_malloc(len);
					for(size_t i=0; i<transfer->actual_length; i++) {
						for(size_t j=0; j<step; j++) {
							ptr[i*step+j] = mask & (transfer->buffer[i] >> (j * devc->cur_samplechannel));
						}
					}
				}
				submit_data(ptr, len, sdi);
				if (devc->cur_samplechannel != 8) {
					g_free(ptr);
				}
			}

			size_t bytes_to_transfer = devc->bytes_need_transfer -
				(devc->bytes_transfered + devc->bytes_transferring);
			if (bytes_to_transfer > devc->transfers_buffer_size) {
				bytes_to_transfer = devc->transfers_buffer_size;
			}
			if (bytes_to_transfer) {
				transfer->length = bytes_to_transfer;
				transfer->actual_length = 0;
				transfer->timeout = devc->timeout * devc->transfers_used;
				ret = libusb_submit_transfer(transfer);
				if (ret) {
					sr_warn("Failed to submit transfer: %s", libusb_error_name(ret));
					devc->transfers_used -= 1;
				}
				sr_dbg("submit transfer: %p", transfer);

				devc->bytes_transferring += bytes_to_transfer;
			} else {
				devc->transfers_used -= 1;
			}
		} break;

		case LIBUSB_TRANSFER_NO_DEVICE: {
			devc->transfers_used = 0;
		} break;

		default: {
			devc->transfers_used -= 1;
		} break;
	}

	if (devc->transfers_used == 0) {
		sr_dbg("free all transfers");

		sr_dbg("Bulk in %u/%u bytes", devc->bytes_transfered,
				devc->bytes_need_transfer);
		
		sr_dev_acquisition_stop(sdi);
	}
};

static int handle_events(int fd, int revents, void *cb_data)
{
	struct sr_dev_inst *sdi;
	struct sr_dev_driver *di;
	struct dev_context *devc;
	struct drv_context *drvc;
	struct timeval tv;

	(void)fd;
	(void)revents;

	sdi = cb_data;
	devc = sdi->priv;
	di = sdi->driver;
	drvc = di->context;

	sr_dbg("handle_events enter");

	if (devc->acq_aborted == TRUE) {
		for (size_t i = 0; i < NUM_MAX_TRANSFERS; ++i) {
			struct libusb_transfer *transfer = devc->transfers[i];
			if (transfer) {
				libusb_cancel_transfer(transfer);
				g_free(transfer->buffer);
				libusb_free_transfer(transfer);
			}
			devc->transfers[i] = NULL;
		}

		usb_source_remove(sdi->session, drvc->sr_ctx);
		std_session_send_df_end(sdi);
	}

	memset(&tv, 0, sizeof(struct timeval));
	libusb_handle_events_timeout_completed(drvc->sr_ctx->libusb_ctx, &tv,
			&devc->acq_aborted);

	return TRUE;
}

SR_PRIV int sipeed_slogic_acquisition_start(const struct sr_dev_inst *sdi)
{
	// sr_dbg("Enter func %s", __func__);
	/* TODO: configure hardware, reset acquisition state, set up
	 * callbacks and send header packet. */

	struct sr_dev_driver *di;
	struct dev_context *devc;
	struct drv_context *drvc;
	struct sr_usb_dev_inst *usb;

	struct cmd_start_acquisition cmd;
	int ret;
	size_t size_transfer_buf;

	devc = sdi->priv;
	di = sdi->driver;
	drvc = di->context;
	usb  = sdi->conn;

	// TODO
	// if(devc->cur_samplechannel != 8) return SR_ERR_SAMPLERATE;

	sr_dbg("samplerate: %uHz@%uch, samples: %u",
			devc->cur_samplerate / SR_MHZ(1), 
			devc->cur_samplechannel, 
			devc->limit_samples);

	clear_ep(EP_IN, usb->devhdl);

	devc->acq_aborted = FALSE;
  	devc->bytes_need_transfer = 0;
	devc->bytes_transferring = 0;
	devc->bytes_transfered = 0;
	devc->transfers_used = 0;
	memset(devc->transfers, 0, sizeof(devc->transfers));

	devc->transfers_buffer_size = get_buffer_size(devc);
	sr_dbg("transfers_buffer_size: %u", devc->transfers_buffer_size);

	devc->timeout = get_timeout(devc);
	sr_dbg("timeout: %ums", devc->timeout);
	usb_source_add(sdi->session, drvc->sr_ctx, 10,
			handle_events, (void *)sdi);

	/* compute needed bytes */
	uint64_t samples_in_bytes = devc->limit_samples * devc->cur_samplechannel / 8;
	devc->bytes_need_transfer = samples_in_bytes / devc->transfers_buffer_size;
	devc->bytes_need_transfer += !!(samples_in_bytes % devc->transfers_buffer_size);
	devc->bytes_need_transfer *= devc->transfers_buffer_size;


	while (devc->transfers_used < NUM_MAX_TRANSFERS && devc->bytes_transfered
			+ devc->bytes_transferring < devc->bytes_need_transfer)
	{
		uint8_t *dev_buf = g_malloc(devc->transfers_buffer_size);
		if (!dev_buf) {
			sr_dbg("Failed to allocate memory");
			sr_dev_acquisition_stop(sdi);
			return SR_ERR_MALLOC;
			break;
		}

		struct libusb_transfer *transfer = libusb_alloc_transfer(0);
		if (!transfer) {
			g_free(dev_buf);
			sr_dbg("Failed to allocate transfer");
			sr_dev_acquisition_stop(sdi);
			return SR_ERR_MALLOC;
			break;
		}

		size_t bytes_to_transfer = devc->bytes_need_transfer -
			devc->bytes_transfered - devc->bytes_transferring;
		if (bytes_to_transfer > devc->transfers_buffer_size) {
			bytes_to_transfer = devc->transfers_buffer_size;
		}

		libusb_fill_bulk_transfer(transfer, usb->devhdl, EP_IN | LIBUSB_ENDPOINT_IN,
									dev_buf, bytes_to_transfer, receive_transfer,
									sdi, devc->timeout * (devc->transfers_used + 1));
		transfer->actual_length = 0;

		ret = libusb_submit_transfer(transfer);
		if (ret) {
			sr_dbg("Failed to submit transfer: %s.", libusb_error_name(ret));
			g_free(transfer->buffer);
			libusb_free_transfer(transfer);
			sr_dev_acquisition_stop(sdi);
			return SR_ERR_IO;
			break;
		}
		devc->transfers[devc->transfers_used] = transfer;

		devc->bytes_transferring += bytes_to_transfer;
		devc->transfers_used += 1;
	}
	sr_dbg("Submited %u transfers", devc->transfers_used);

	std_session_send_df_frame_begin(sdi);
	std_session_send_df_header(sdi);


	cmd.sample_rate = devc->cur_samplerate / SR_MHZ(1);
	cmd.sample_channel = devc->cur_samplechannel;

	ret = libusb_control_transfer(
		usb->devhdl, LIBUSB_REQUEST_TYPE_VENDOR | LIBUSB_ENDPOINT_OUT, CMD_START, 0x0000,
		0x0000, (unsigned char *)&cmd, 3 /*sizeof(cmd)*/, 100);
	if (ret < 0) {
		sr_dbg("Unable to send start command: %s", libusb_error_name(ret));
		return SR_ERR_NA;
	}
	sr_dbg("CMD_STARTED");

	return SR_OK;
}

SR_PRIV int sipeed_slogic_acquisition_stop(struct sr_dev_inst *sdi)
{

	struct dev_context *devc;

	devc = sdi->priv;

	devc->acq_aborted = TRUE;

	return SR_OK;
}
