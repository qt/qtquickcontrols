TEMPLATE = subdirs

SUBDIRS += controls
android: SUBDIRS += controls/Styles/Android
ios: SUBDIRS += controls/Styles/iOS
winrt: SUBDIRS += controls/Styles/WinRT

SUBDIRS += layouts

SUBDIRS += dialogs
SUBDIRS += dialogs/Private

qtHaveModule(quick):qtHaveModule(widgets): SUBDIRS += widgets
