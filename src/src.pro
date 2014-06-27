TEMPLATE = subdirs

SUBDIRS += controls
android: SUBDIRS += controls/Styles/Android

SUBDIRS += layouts

SUBDIRS += dialogs
SUBDIRS += dialogs/Private

qtHaveModule(quick):qtHaveModule(widgets): SUBDIRS += widgets
