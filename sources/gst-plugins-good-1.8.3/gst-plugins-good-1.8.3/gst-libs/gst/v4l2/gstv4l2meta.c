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

#include "gstv4l2meta.h"

static gboolean
gst_v4l2_meta_transform (GstBuffer * dest, GstMeta * meta, GstBuffer * buffer,
    GQuark type, gpointer data)
{
  GstV4l2Meta *src_meta = (GstV4l2Meta *) meta;
  GstV4l2Meta *dest_meta;

  if (GST_META_TRANSFORM_IS_COPY (type)) {
    /* currently, our metadata don't depend on region, so just copy them */
    dest_meta = gst_buffer_add_v4l2_meta (dest);
    if (dest_meta == NULL)
      return FALSE;

    dest_meta->timestamp = src_meta->timestamp;
  } else {
    /* transform type not supported */
    return FALSE;
  }

  return TRUE;
}

GType
gst_v4l2_meta_api_get_type (void)
{
  static volatile GType type = 0;
  static const gchar *tags[] = { NULL };

  if (g_once_init_enter (&type)) {
    GType _type = gst_meta_api_type_register ("GstV4l2MetaAPI", tags);
    g_once_init_leave (&type, _type);
  }

  return type;
}

const GstMetaInfo *
gst_v4l2_meta_get_info (void)
{
  static const GstMetaInfo *info = NULL;

  if (g_once_init_enter (&info)) {
    const GstMetaInfo *_info = gst_meta_register (GST_V4L2_META_API_TYPE,
        "GstV4l2Meta", sizeof (GstV4l2Meta), (GstMetaInitFunction) NULL,
        (GstMetaFreeFunction) NULL, gst_v4l2_meta_transform);
    g_once_init_leave (&info, _info);
  }

  return info;
}
