TEMPLATE = subdirs

SUBDIRS += controls

SUBDIRS += layouts

SUBDIRS += dialogs
SUBDIRS += dialogs/Private

qtHaveModule(quick):qtHaveModule(widgets): SUBDIRS += widgets
