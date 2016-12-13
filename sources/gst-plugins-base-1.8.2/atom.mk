
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := gst-plugins-base
LOCAL_DESCRIPTION := GStreamer streaming media framework base plug-ins
LOCAL_CATEGORY_PATH := multimedia/gstreamer

LOCAL_CONFIG_FILES := aconfig.in
$(call load-config)

LOCAL_LIBRARIES := gstreamer

LOCAL_CONDITIONAL_LIBRARIES := OPTIONAL:orc
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:zlib
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:libogg
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:libvorbis
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:alsa-lib
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:pango
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:vorbis

LOCAL_EXPORT_LDLIBS := \
	-lgstallocators-1.0 \
	-lgstapp-1.0 \
	-lgstaudio-1.0 \
	-lgstfft-1.0 \
	-lgstpbutils-1.0 \
	-lgstriff-1.0 \
	-lgstrtp-1.0 \
	-lgstrtsp-1.0 \
	-lgstsdp-1.0 \
	-lgsttag-1.0 \
	-lgstvideo-1.0

# --disable-maintainer-mode is to avoid regenerating configure/Makefile.in
# that we store in git repo
LOCAL_AUTOTOOLS_CONFIGURE_ARGS := \
	--disable-maintainer-mode \
	--disable-nls \
	--disable-examples \
	--disable-gtk-doc-html \
	--with-audioresample-format=int \
	--disable-introspection

# Explicitly disable libraries that we don't depend on.
# It ensures consistency in build.
# If you want to enable one, put it also in LOCAL_CONDITIONAL_LIBRARIES
LOCAL_AUTOTOOLS_CONFIGURE_ARGS += \
	--disable-x \
	--disable-xvideo \
	--disable-xshm \
	--disable-cdparanoia \
	--disable-ivorbis \
	--disable-libvisual \
	--disable-oggtest \
	--disable-theora \
	--disable-vorbistest \
	--disable-freetypetest

# Get all config options from aconfig.in file
gst_plugins_base_configs := \
	$(shell awk 'match($$0, /^config/)' $(LOCAL_PATH)/aconfig.in | \
	sed -r -e 's/^config //' | sed -r -e 's/GST_PLUGINS_BASE_(.+)/\1/')

# Update LOCAL_AUTOTOOLS_CONFIGURE_ARGS with config state
$(foreach config,$(gst_plugins_base_configs), \
	$(if $(CONFIG_GST_PLUGINS_BASE_$(config)), \
		$(eval LOCAL_AUTOTOOLS_CONFIGURE_ARGS += $(shell echo $(config) | sed -r -e 's/(.+)/--\L\1/' -e 's/_/-/')) \
	) \
)

include $(BUILD_AUTOTOOLS)
