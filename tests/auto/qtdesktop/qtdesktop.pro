TEMPLATE = app
TARGET = tst_qtdesktop

IMPORTPATH = $$OUT_PWD/../testplugin

QT += widgets

CONFIG += qmltestcase

INCLUDEPATH += $$PWD/../../shared
SOURCES += $$PWD/tst_qtdesktop.cpp

TESTDATA = $$PWD/data/*

OTHER_FILES += \
    $$PWD/data/tst_button.qml \
    $$PWD/data/tst_shortcuts.qml \
    $$PWD/data/tst_spinbox.qml \
    $$PWD/data/tst_tableview.qml \
    $$PWD/data/tst_rangemodel.qml

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
