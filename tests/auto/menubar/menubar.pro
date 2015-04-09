CONFIG += testcase
TARGET = tst_menubar

SOURCES += tst_menubar.cpp

include (../shared/util.pri)

linux-*:CONFIG+=insignificant_test    # QTBUG-30513 - test is unstable
win32:CONFIG+=insignificant_test    # QTBUG-30513 - test is unstable

CONFIG += parallel_test
QT += core-private gui-private qml-private quick-private testlib

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0

OTHER_FILES += \
    data/WindowWithMenuBar.qml
