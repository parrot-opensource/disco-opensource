LOCAL_PATH := $(call my-dir)

###############################################################################
# libapm-telemetry library to export data from ardupilot to telemetry
###############################################################################

include $(CLEAR_VARS)

LOCAL_MODULE := libapm-telemetry
LOCAL_DESTDIR := usr/lib/ardupilot/modules
LOCAL_CATEGORY_PATH := apm
LOCAL_DESCRIPTION := Ardupilot export module

LOCAL_SRC_FILES := \
	src/libapm-telemetry.c

LOCAL_LIBRARIES := \
	libulog \
	libfutils \
	libtelemetry \
	ardupilot-headers

include $(BUILD_SHARED_LIBRARY)
