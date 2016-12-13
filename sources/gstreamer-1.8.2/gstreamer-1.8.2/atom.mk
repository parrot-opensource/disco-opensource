
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := gstreamer
LOCAL_DESCRIPTION := GStreamer streaming media framework runtime
LOCAL_CATEGORY_PATH := multimedia/gstreamer
LOCAL_LIBRARIES := glib

LOCAL_CONFIG_FILES := aconfig.in
$(call load-config)

LOCAL_EXPORT_C_INCLUDES := \
	$(TARGET_OUT_STAGING)/usr/include/gstreamer-1.0 \
	$(TARGET_OUT_STAGING)/$(TARGET_DEFAULT_LIB_DESTDIR)/gstreamer-1.0/include

LOCAL_EXPORT_LDLIBS := \
	-lgstreamer-1.0 \
	-lgstbase-1.0 \
	-lgstcontroller-1.0 \
	-lgstnet-1.0

ifndef CONFIG_GSTREAMER_DISABLE_CHECK
LOCAL_EXPORT_LDLIBS += -lgstcheck-1.0
endif

# --disable-maintainer-mode is to avoid regenerating configure/Makefile.in
# that we store in git repo
LOCAL_AUTOTOOLS_CONFIGURE_ARGS := \
	--disable-maintainer-mode \
	--disable-nls \
	--disable-examples \
	--disable-tests \
	--disable-failing-tests \
	--disable-gtk-doc-html \
	--disable-introspection

# Get all config options from aconfig.in file
gstreamer_configs := \
	$(shell awk 'match($$0, /^config/)' $(LOCAL_PATH)/aconfig.in | \
	sed -r -e 's/^config //' | sed -r -e 's/GSTREAMER_(.+)/\1/')

# Update LOCAL_AUTOTOOLS_CONFIGURE_ARGS with config state
$(foreach config,$(gstreamer_configs), \
	$(if $(CONFIG_GSTREAMER_$(config)), \
		$(eval LOCAL_AUTOTOOLS_CONFIGURE_ARGS += $(shell echo $(config) | sed -r -e 's/(.+)/--\L\1/' -e 's/_/-/')) \
	) \
)

include $(BUILD_AUTOTOOLS)

