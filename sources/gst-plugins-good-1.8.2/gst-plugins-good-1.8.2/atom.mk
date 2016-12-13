
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := gst-plugins-good
LOCAL_DESCRIPTION := GStreamer streaming media framework good plug-ins
LOCAL_CATEGORY_PATH := multimedia/gstreamer

LOCAL_CONFIG_FILES := aconfig.in
$(call load-config)

LOCAL_LIBRARIES := gstreamer gst-plugins-base

LOCAL_CONDITIONAL_LIBRARIES := OPTIONAL:orc
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:libsoup
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:flac
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:cairo
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:libpng
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:taglib
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:zlib
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:libjpeg-turbo

LOCAL_EXPORT_LDLIBS := \
	-lgstv4l2-1.0

# --disable-maintainer-mode is to avoid regenerating configure/Makefile.in
# that we store in git repo
LOCAL_AUTOTOOLS_CONFIGURE_ARGS := \
	--disable-maintainer-mode \
	--disable-nls \
	--disable-examples \
	--disable-gtk-doc-html \
	--disable-introspection

# Explicitly disable libraries that we don't depend on.
# It ensures consistency in build.
# If you want to enable one, put it also in LOCAL_CONDITIONAL_LIBRARIES and
# uncomment section in configuration file
LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	--disable-directsound \
	--disable-waveform \
	--disable-oss \
	--disable-oss4 \
	--disable-sunaudio \
	--disable-osx_audio \
	--disable-osx_video \
	--disable-x \
	--disable-aalib \
	--disable-gdk_pixbuf \
	--disable-libcaca \
	--disable-libdv \
	--disable-pulse \
	--disable-dv1394 \
	--disable-shout2 \
	--disable-speex \
	--disable-vpx \
	--disable-wavpack \
	--disable-bz2

# Get all config options from aconfig.in file
gst_plugins_good_configs := \
	$(shell awk 'match($$0, /^config/)' $(LOCAL_PATH)/aconfig.in | \
	sed -r -e 's/^config //' | sed -r -e 's/GST_PLUGINS_GOOD_(.+)/\1/')

# Update LOCAL_AUTOTOOLS_CONFIGURE_ARGS with config state
$(foreach config,$(gst_plugins_good_configs), \
	$(if $(CONFIG_GST_PLUGINS_GOOD_$(config)), \
		$(eval LOCAL_AUTOTOOLS_CONFIGURE_ARGS += $(shell echo $(config) | sed -r -e 's/(.+)/--\L\1/' -e 's/_/-/')) \
	) \
)

include $(BUILD_AUTOTOOLS)
