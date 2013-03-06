
The test plugin is not installed (i.e. to the qml folder).
In order for the tst_controls to find it, you can either:

- Run make check in the controls folder. The plugin will be found
at run time because IMPORTPATH is defined in the pro file.

- In Qt Creator run settings or in the console, set QML2_IMPORT_PATH
macro to the testplugin path. At run time QML2_IMPORT_PATH is used by
by qmlscene to find imports required.
i.e: export QML2_IMPORT_PATH=<path_qtquickcontrols_git_clone>/tests/auto/testplugin
