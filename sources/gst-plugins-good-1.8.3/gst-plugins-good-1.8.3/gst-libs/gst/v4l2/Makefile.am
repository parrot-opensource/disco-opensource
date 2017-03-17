lib_LTLIBRARIES = libgstv4l2-@GST_API_VERSION@.la

libgstv4l2_@GST_API_VERSION@_includedir = $(includedir)/gstreamer-@GST_API_VERSION@/gst/v4l2

libgstv4l2_@GST_API_VERSION@_include_HEADERS = gstv4l2meta.h

libgstv4l2_@GST_API_VERSION@_la_SOURCES = gstv4l2meta.c

libgstv4l2_@GST_API_VERSION@_la_CFLAGS = \
	$(GST_PLUGINS_GOOD_CFLAGS) \
	$(GST_CFLAGS)

libgstv4l2_@GST_API_VERSION@_la_LIBADD = \
	$(GST_LIBS)

libgstv4l2_@GST_API_VERSION@_la_LDFLAGS = \
	$(GST_LIB_LDFLAGS) \
	$(GST_ALL_LDFLAGS) \
	$(GST_LT_LDFLAGS)
