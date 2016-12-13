LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := gst-plugins-bad
LOCAL_DESCRIPTION := GStreamer streaming media framework bad plug-ins
LOCAL_CATEGORY_PATH := multimedia/gstreamer

LOCAL_CONFIG_FILES := aconfig.in
$(call load-config)

LOCAL_LIBRARIES := gstreamer gst-plugins-base

LOCAL_CONDITIONAL_LIBRARIES := OPTIONAL:orc
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:opencv
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:opus
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:sbc
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:opengles
LOCAL_CONDITIONAL_LIBRARIES += OPTIONAL:egl

# Only exports libraries which will be build for sure:
# gl and wayland are system-dependent
LOCAL_EXPORT_LDLIBS := \
	-lgstcodecparsers-1.0 \
	-lgstinsertbin-1.0 \
	-lgstmpegts-1.0

# Export GstGL library if opengles and egl are enabled
have_gl := \
	$(and "$(call is-module-in-build-config,opengles)", \
		"$(call is-module-in-build-config,egl)" \
	)

ifneq ($(have_gl),"")
LOCAL_EXPORT_LDLIBS += -lgstgl-1.0
endif

# --disable-maintainer-mode is to avoid regenerating configure/Makefile.in
# that we store in git repo
LOCAL_AUTOTOOLS_CONFIGURE_ARGS := \
	--disable-maintainer-mode \
	--disable-nls \
	--disable-examples \
	--disable-gtk-doc-html \
	--disable-hls \
	--disable-introspection \
	--enable-egl-without-win

# Get all config options from aconfig.in file
gst_plugins_bad_configs := \
	$(shell awk 'match($$0, /^config/)' $(LOCAL_PATH)/aconfig.in | \
	sed -r -e 's/^config //' | sed -r -e 's/GST_PLUGINS_BAD_(.+)/\1/')

# Update LOCAL_AUTOTOOLS_CONFIGURE_ARGS with config state
$(foreach config,$(gst_plugins_bad_configs), \
	$(if $(CONFIG_GST_PLUGINS_BAD_$(config)), \
		$(eval LOCAL_AUTOTOOLS_CONFIGURE_ARGS += $(shell echo $(config) | sed -r -e 's/(.+)/--\L\1/' -e 's/_/-/')) \
	) \
)

include $(BUILD_AUTOTOOLS)

