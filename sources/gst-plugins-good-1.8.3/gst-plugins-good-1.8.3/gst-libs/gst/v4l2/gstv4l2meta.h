/* GStreamer
 * Copyright (C) <2015> Aurélien Zanelli <aurelien.zanelli@parrot.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#ifndef __GST_V4L2_META_H__
#define __GST_V4L2_META_H__

#include <gst/gst.h>

G_BEGIN_DECLS

#define GST_BUFFER_POOL_OPTION_V4L2_META "GstBufferPoolOptionV4l2Meta"

#define GST_V4L2_META_API_TYPE (gst_v4l2_meta_api_get_type ())
#define GST_V4L2_META_INFO (gst_v4l2_meta_get_info ())
typedef struct _GstV4l2Meta GstV4l2Meta;

/**
 * GstV4l2Meta:
 *
 * @meta: parent #GstMeta
 * @timestamp: v4l2 original timestamp
 *
 * Extra buffer v4l2 metadata
 */
struct _GstV4l2Meta
{
  GstMeta meta;

  GstClockTime timestamp;
};

GType gst_v4l2_meta_api_get_type (void);
const GstMetaInfo *gst_v4l2_meta_get_info (void);

#define gst_buffer_get_v4l2_meta(buffer) \
  ((GstV4l2Meta *) gst_buffer_get_meta ((buffer), GST_V4L2_META_API_TYPE))

#define gst_buffer_add_v4l2_meta(buffer) \
  ((GstV4l2Meta *) gst_buffer_add_meta ((buffer), GST_V4L2_META_INFO, NULL))

G_END_DECLS

#endif
