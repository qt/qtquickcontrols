CONFIG += testcase
TARGET = tst_dialogs
SOURCES += tst_dialogs.cpp

include (../shared/util.pri)

osx:CONFIG -= app_bundle

QT += core-private gui-private qml-private quick-private testlib

TESTDATA = data/*

OTHER_FILES += \
    data/RectWithFileDialog.qml
