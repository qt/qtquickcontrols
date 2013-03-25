CONFIG += testcase
TARGET = tst_activeFocusOnTab
macx:CONFIG -= app_bundle

SOURCES += tst_activeFocusOnTab.cpp

include (../shared/util.pri)

TESTDATA = data/*

QT += widgets core-private gui-private v8-private qml-private quick-private testlib
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
