TEMPLATE = app
TARGET = tst_qtdesktop

QT += widgets

CONFIG += qmltestcase

INCLUDEPATH += $$PWD/../../shared
SOURCES += tst_qtdesktop.cpp

TESTDATA = data/*

OTHER_FILES += \
    data/tst_button.qml \
    data/tst_spinbox.qml

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
