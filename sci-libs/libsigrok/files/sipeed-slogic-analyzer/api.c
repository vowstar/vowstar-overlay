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

static const uint32_t scanopts[] = {
	SR_CONF_CONN,
};

static const uint32_t drvopts[] = {
	SR_CONF_LOGIC_ANALYZER,
};

static const uint32_t devopts[] = {
	SR_CONF_CONTINUOUS,
	SR_CONF_LIMIT_SAMPLES | SR_CONF_GET | SR_CONF_SET,
	SR_CONF_SAMPLERATE    | SR_CONF_GET | SR_CONF_SET | SR_CONF_LIST,
	SR_CONF_TRIGGER_MATCH | SR_CONF_GET | SR_CONF_LIST,
};

static const int32_t trigger_matches[] = {
	SR_TRIGGER_ZERO,
	SR_TRIGGER_ONE,
	SR_TRIGGER_RISING,
	SR_TRIGGER_FALLING,
	SR_TRIGGER_EDGE,
};

static struct sr_dev_driver sipeed_slogic_analyzer_driver_info;

static GSList *scan(struct sr_dev_driver *di, GSList *options)
{
	int ret;
	struct sr_dev_inst *sdi;
	struct sr_usb_dev_inst *usb;
	struct drv_context *drvc;
	struct dev_context *devc;

	struct sr_config *option;
	struct libusb_device_descriptor des;
	GSList *devices;
	GSList *l, *conn_devices;
	const char *conn;
	char cbuf[128];
	char *iManufacturer, *iProduct, *iSerialNumber, *iPortPath;

	(void)options;

	conn = NULL;

	devices = NULL;
	drvc = di->context;
	drvc->instances = NULL;
	
	/* scan for devices, either based on a SR_CONF_CONN option
	 * or on a USB scan. */
	for (l = options; l; l = l->next) {
		option = l->data;
		switch (option->key) {
		case SR_CONF_CONN:
			conn = g_variant_get_string(option->data, NULL);
			sr_info("use conn: %s", conn);
			break;
		default:
			sr_warn("Unhandled option key: %u", option->key);
		}
	}
	
	if(!conn) {
		conn = "359f.0300";
	}

	/* Find all slogic compatible devices. */
	conn_devices = sr_usb_find(drvc->sr_ctx->libusb_ctx, conn);
	for(l = conn_devices; l; l = l->next) {
		usb = l->data;
		ret = sr_usb_open(drvc->sr_ctx->libusb_ctx, usb);
		if (SR_OK != ret) continue;
		libusb_get_device_descriptor(
			libusb_get_device(usb->devhdl), &des);
		libusb_get_string_descriptor_ascii(usb->devhdl,
				des.iManufacturer, cbuf, sizeof(cbuf));
		iManufacturer = g_strdup(cbuf);
		libusb_get_string_descriptor_ascii(usb->devhdl,
				des.iProduct, cbuf, sizeof(cbuf));
		iProduct = g_strdup(cbuf);
		libusb_get_string_descriptor_ascii(usb->devhdl,
				des.iSerialNumber, cbuf, sizeof(cbuf));
		iSerialNumber = g_strdup(cbuf);
		usb_get_port_path(libusb_get_device(usb->devhdl),
				cbuf, sizeof(cbuf));
		iPortPath = g_strdup(cbuf);
		sr_usb_close(usb);

		sdi = sr_dev_inst_user_new(iManufacturer, iProduct, NULL);
		if (!sdi) continue;

		for (int i = 0; i < 8; i++) {
			sr_snprintf_ascii(cbuf, sizeof(cbuf), "D%d", i);
			sr_dev_inst_channel_add(sdi, i, SR_CHANNEL_LOGIC, cbuf);
		}
		
		sdi->serial_num = iSerialNumber;
		sdi->connection_id = iPortPath;
		sdi->status = SR_ST_INACTIVE;
		sdi->conn = usb;
		sdi->inst_type = SR_INST_USB;

		devc = g_malloc0(sizeof(struct dev_context));
		sdi->priv = devc;



		devices = g_slist_append(devices, sdi);
	}
	// g_slist_free_full(conn_devices, (GDestroyNotify)sr_usb_dev_inst_free);

	return std_scan_complete(di, devices);
}

static int dev_open(struct sr_dev_inst *sdi)
{
	int ret;
	struct sr_usb_dev_inst *usb;
	struct dev_context *devc;
	struct sr_dev_driver *di;
	struct drv_context *drvc;


	if (!sdi) return SR_ERR_DEV_CLOSED;
	/* TODO: get handle from sdi->conn and open it. */
	usb  = sdi->conn;
	devc = sdi->priv;
	di	 = sdi->driver;
	drvc = di->context;

	ret = sr_usb_open(drvc->sr_ctx->libusb_ctx, usb);
	if (SR_OK != ret) return ret;

	ret = libusb_claim_interface(usb->devhdl, 0);
	if (ret != LIBUSB_SUCCESS) {
		switch (ret) {
		case LIBUSB_ERROR_BUSY:
			sr_err("Unable to claim USB interface. Another "
			       "program or driver has already claimed it.");
			break;
		case LIBUSB_ERROR_NO_DEVICE:
			sr_err("Device has been disconnected.");
			break;
		default:
			sr_err("Unable to claim interface: %s.",
			       libusb_error_name(ret));
			break;
		}
		return SR_ERR;
	}

	devc_set_samplerate(devc, samplerates[7]);
	
	return std_dummy_dev_open(sdi);
}

static int dev_close(struct sr_dev_inst *sdi)
{
	int ret;
	struct sr_usb_dev_inst *usb;
	struct dev_context *devc;
	struct sr_dev_driver *di;
	struct drv_context *drvc;

	/* TODO: get handle from sdi->conn and close it. */
	usb  = sdi->conn;
	devc = sdi->priv;
	di	 = sdi->driver;
	drvc = di->context;

	ret = libusb_release_interface(usb->devhdl, 0);
	if (ret != LIBUSB_SUCCESS) {
		switch (ret) {
		case LIBUSB_ERROR_NO_DEVICE:
			sr_err("Device has been disconnected.");
			// return SR_ERR_DEV_CLOSED;
			break;
		default:
			sr_err("Unable to release Interface for %s.",
					libusb_error_name(ret));
			break;
		}
	}
	
	sr_usb_close(usb);
	
	return std_dummy_dev_close(sdi);
}

static int config_get(uint32_t key, GVariant **data,
	const struct sr_dev_inst *sdi, const struct sr_channel_group *cg)
{
	int ret;
	struct dev_context *devc;

	(void)cg;

	devc = sdi->priv;

	ret = SR_OK;
	switch (key) {
	case SR_CONF_SAMPLERATE:
		*data = g_variant_new_uint64(devc->cur_samplerate);
		break;
	case SR_CONF_LIMIT_SAMPLES:
		*data = g_variant_new_uint64(devc->limit_samples);
		break;
	default:
		return SR_ERR_NA;
	}

	return ret;
}

static int config_set(uint32_t key, GVariant *data,
	const struct sr_dev_inst *sdi, const struct sr_channel_group *cg)
{
	int ret;
	struct dev_context *devc;

	(void)cg;

	devc = sdi->priv;

	ret = SR_OK;
	switch (key) {
	case SR_CONF_SAMPLERATE:
		if (std_u64_idx(data, ARRAY_AND_SIZE(samplerates)) < 0) {
			ret = SR_ERR_ARG;
		} else {
			devc_set_samplerate(devc, g_variant_get_uint64(data));
			{
			size_t idx = 0;
				for (GSList *l = sdi->channels; l; l = l->next, idx += 1) {
					struct sr_channel *ch = l->data;
					if (ch->type == SR_CHANNEL_LOGIC) { /* Might as well do this now, these are static. */
						sr_dev_channel_enable(ch, (idx >= devc->cur_samplechannel) ? FALSE : TRUE);
					} else {
						return SR_ERR_BUG;
					}
				}
			}
		}
		break;
	case SR_CONF_LIMIT_SAMPLES:
		devc->limit_samples = g_variant_get_uint64(data);
		break;
	default:
		ret = SR_ERR_NA;
	}

	return ret;
}

static int config_list(uint32_t key, GVariant **data,
	const struct sr_dev_inst *sdi, const struct sr_channel_group *cg)
{
	int ret;

	ret = SR_OK;
	switch (key) {
	/* TODO */
	case SR_CONF_SCAN_OPTIONS:
	case SR_CONF_DEVICE_OPTIONS:
		ret = STD_CONFIG_LIST(key, data, sdi, cg, scanopts, drvopts, devopts);
		break;
	case SR_CONF_SAMPLERATE:
		*data = std_gvar_samplerates(ARRAY_AND_SIZE(samplerates));
		break;
	case SR_CONF_TRIGGER_MATCH:
		*data = std_gvar_array_i32(ARRAY_AND_SIZE(trigger_matches));
		break;
	default:
		ret = SR_ERR_NA;
	}

	return ret;
}

static struct sr_dev_driver sipeed_slogic_analyzer_driver_info = {
	.name = "sipeed-slogic-analyzer",
	.longname = "Sipeed Slogic Analyzer",
	.api_version = 1,
	.init = std_init,
	.cleanup = std_cleanup,
	.scan = scan,
	.dev_list = std_dev_list,
	.dev_clear = std_dev_clear,
	.config_get = config_get,
	.config_set = config_set,
	.config_list = config_list,
	.dev_open = dev_open,
	.dev_close = dev_close,
	.dev_acquisition_start = sipeed_slogic_acquisition_start,
	.dev_acquisition_stop = sipeed_slogic_acquisition_stop,
	.context = NULL,
};
SR_REGISTER_DEV_DRIVER(sipeed_slogic_analyzer_driver_info);
