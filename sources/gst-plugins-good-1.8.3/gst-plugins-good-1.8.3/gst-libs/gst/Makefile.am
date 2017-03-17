SUBDIRS = \
	v4l2

noinst_HEADERS = gettext.h gst-i18n-plugin.h glib-compat-private.h

INDEPENDENT_SUBDIRS = \
	v4l2

.PHONY: independent-subdirs $(INDEPENDENT_SUBDIRS)

independent-subdirs: $(INDEPENDENT_SUBDIRS)

$(INDEPENDENT_SUBDIRS):
	$(MAKE) -C $@

all-recursive: independent-subdirs
