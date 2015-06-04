TEMPLATE = subdirs
SUBDIRS += testplugin controls activeFocusOnTab applicationwindow dialogs \
           extras qquicktreemodeladaptor customcontrolsstyle
!osx: SUBDIRS += menubar
controls.depends = testplugin
