CXX_MODULE = qml
TARGET  = testplugin
TARGETPATH = QtDesktopTest

QT += qml quick widgets

OTHER_FILES += \
    $$PWD/testplugin.json \
    $$PWD/qmldir

SOURCES += \
    $$PWD/testplugin.cpp

HEADERS += \
    $$PWD/testplugin.h \
    $$PWD/testcppmodels.h

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0

mac {
    LIBS += -framework Carbon
}

load(qml_plugin)

qmldir_path = $$PWD$${QMAKE_DIR_SEP}qmldir
win*: qmldir_path = $$replace(qmldir_path, /, \\)
destdir_path = $$DESTDIR
win*: destdir_path = $$replace(destdir_path, /, \\)

QMAKE_POST_LINK = $(MAKE) -f $(MAKEFILE) install
