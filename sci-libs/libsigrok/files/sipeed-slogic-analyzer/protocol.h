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

#ifndef LIBSIGROK_HARDWARE_SIPEED_SLOGIC_ANALYZER_PROTOCOL_H
#define LIBSIGROK_HARDWARE_SIPEED_SLOGIC_ANALYZER_PROTOCOL_H

#include <stdint.h>
#include <glib.h>
#include <libusb.h>
#include <libsigrok/libsigrok.h>
#include "libsigrok-internal.h"

#define LOG_PREFIX "sipeed-slogic-analyzer"

#define EP_IN 0x01
#define SIZE_MAX_EP_HS 512
#define NUM_MAX_TRANSFERS 64

static const uint64_t samplerates[] = {
	/* 160M = 2*2*2*2*2*5M */
	SR_MHZ(1),
	SR_MHZ(2),
	SR_MHZ(4),
	SR_MHZ(5),
	SR_MHZ(8),
	SR_MHZ(10),
	SR_MHZ(16),
	SR_MHZ(20),
	SR_MHZ(32),
	SR_MHZ(36),
	SR_MHZ(40),
	/* x 4ch */
	SR_MHZ(64),
	SR_MHZ(80),
	/* x 2ch */
	SR_MHZ(120),
	SR_MHZ(128),
	SR_MHZ(144),
	SR_MHZ(160),
};

struct dev_context {
	struct {
		uint64_t limit_samples;
		uint64_t cur_samplerate;
		uint64_t cur_samplechannel;
	};

	uint64_t num_transfers;
	struct libusb_transfer *transfers[NUM_MAX_TRANSFERS];

	gboolean acq_aborted;

	uint64_t timeout;

	size_t transfers_buffer_size;

	size_t bytes_need_transfer;
	size_t bytes_transferring;
	size_t bytes_transfered;
	size_t transfers_used;

	gboolean trigger_fired;
	struct soft_trigger_logic *stl;

	uint64_t num_frames;
	uint64_t sent_samples;
	int submitted_transfers;
	int empty_transfer_count;


	double voltage_threshold[2];
	/* Triggers */
	uint64_t capture_ratio;
};

static inline void devc_set_samplerate(struct dev_context *devc, uint64_t new_samplerate) {
	devc->cur_samplerate = new_samplerate;
	if (new_samplerate >= SR_MHZ(120)) {
		devc->cur_samplechannel = 2;
	} else if (new_samplerate >= SR_MHZ(40)) {
		devc->cur_samplechannel = 4;
	} else {
		devc->cur_samplechannel = 8;
	}
	sr_info("rebind sample channel to %uCH", devc->cur_samplechannel);
}

#pragma pack(push, 1)
struct cmd_start_acquisition {
  union {
    struct {
      uint8_t sample_rate_l;
      uint8_t sample_rate_h;
    };
    uint16_t sample_rate;
  };
	uint8_t sample_channel;
};
#pragma pack(pop)

/* Protocol commands */
#define CMD_START	0xb1
#define CMD_STOP	0xb3

SR_PRIV int sipeed_slogic_acquisition_start(const struct sr_dev_inst *sdi);
SR_PRIV int sipeed_slogic_acquisition_stop(struct sr_dev_inst *sdi);

static inline size_t to_bytes_per_ms(struct dev_context *devc)
{
	return (devc->cur_samplerate * devc->cur_samplechannel) / 8 / 1000;
}

static inline size_t get_buffer_size(struct dev_context *devc)
{
	/**
	 * The buffer should be large enough to hold 10ms of data and
	 * a multiple of 210 * 512.
	 */
	// const size_t pack_size = SIZE_MAX_EP_HS;
	// size_t s = 10 * to_bytes_per_ms(devc);
	// size_t rem = s % (210 * pack_size);
	// if (rem) s += 210 * pack_size - rem;
	// return s;
	return 210 * SIZE_MAX_EP_HS;
}

static inline size_t get_number_of_transfers(struct dev_context *devc)
{
	/* Total buffer size should be able to hold about 500ms of data. */
	// size_t s = 500 * to_bytes_per_ms(devc);
	// size_t n = s / get_buffer_size(devc);
	// size_t rem = s % get_buffer_size(devc);
	// if (rem) n += 1;
	// if (n > NUM_MAX_TRANSFERS)
	// 	return NUM_MAX_TRANSFERS;
	// return n;
	return 1;
}

static inline size_t get_timeout(struct dev_context *devc)
{
	size_t total_size = get_buffer_size(devc) *
			get_number_of_transfers(devc);
	size_t timeout = total_size / to_bytes_per_ms(devc);
	return timeout * 5 / 4; /* Leave a headroom of 25% percent. */
}

static inline void clear_ep(uint8_t ep, libusb_device_handle *usbh) {
	sr_dbg("Clearring EP: %u", ep);
	uint8_t tmp[512];
	int actual_length = 0;
	do {
		libusb_bulk_transfer(usbh, ep | LIBUSB_ENDPOINT_IN,
				tmp, sizeof(tmp), &actual_length, 100);
	} while (actual_length);
	sr_dbg("Cleared EP: %u", ep);
}

#endif
