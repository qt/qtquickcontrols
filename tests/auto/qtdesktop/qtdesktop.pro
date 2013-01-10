TEMPLATE = app
TARGET = tst_qtdesktop

QT += widgets

CONFIG += qmltestcase

INCLUDEPATH += $$PWD/../../shared
SOURCES += $$PWD/tst_qtdesktop.cpp

TESTDATA = $$PWD/data/*

OTHER_FILES += \
    $$PWD/data/tst_button.qml \
    $$PWD/data/tst_spinbox.qml \
    $$PWD/data/tst_tableview.qml \
    $$PWD/data/tableview/table2_qabstractitemmodel.qml \
    $$PWD/data/tableview/table1_qobjectmodel.qml \
    $$PWD/data/tableview/table3_qobjectlist.qml \
    $$PWD/data/tableview/table4_qstringlist.qml \
    $$PWD/data/tableview/table8_itemmodel.qml \
    $$PWD/data/tableview/table7_arraymodel.qml \
    $$PWD/data/tableview/table6_countmodel.qml \
    $$PWD/data/tableview/table5_listmodel.qml

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
