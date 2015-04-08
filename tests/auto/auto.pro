TEMPLATE = subdirs
SUBDIRS += testplugin controls activeFocusOnTab applicationwindow dialogs \
           extras paint qquicktreemodeladaptor customcontrolsstyle
!osx: SUBDIRS += menubar
controls.depends = testplugin
