CONFIG += testcase console
TARGET = tst_menubar

HEADERS += \
    $$PWD/../../../src/controls/qquickpopupwindow_p.h \
    $$PWD/../../../src/controls/qquickmenupopupwindow_p.h \
    $$PWD/../../../src/controls/qquickmenubar_p.h

SOURCES += \
    tst_menubar.cpp \
    $$PWD/../../../src/controls/qquickpopupwindow.cpp \
    $$PWD/../../../src/controls/qquickmenupopupwindow.cpp \
    $$PWD/../../../src/controls/qquickmenubar.cpp

include (../shared/util.pri)

linux-*:CONFIG+=insignificant_test    # QTBUG-30513 - test is unstable
win32:CONFIG+=insignificant_test    # QTBUG-30513 - test is unstable

CONFIG += parallel_test
QT += core-private gui-private qml-private quick-private testlib

INCLUDEPATH += $$PWD/../../../src/controls

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0

OTHER_FILES += \
    data/WindowWithMenuBar.qml
