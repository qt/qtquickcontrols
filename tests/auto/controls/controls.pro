TEMPLATE = app
TARGET = tst_controls

IMPORTPATH = $$OUT_PWD/../testplugin

QT += widgets

CONFIG += qmltestcase

INCLUDEPATH += $$PWD/../../shared
SOURCES += $$PWD/tst_controls.cpp

TESTDATA = $$PWD/data/*

OTHER_FILES += \
    $$PWD/data/tst_button.qml \
    $$PWD/data/tst_shortcuts.qml \
    $$PWD/data/tst_spinbox.qml \
    $$PWD/data/tst_tableview.qml \
    $$PWD/data/tst_rangemodel.qml \
    $$PWD/data/tst_scrollview.qml \
    $$PWD/data/tst_menu.qml \
    $$PWD/data/tst_textfield.qml \
    $$PWD/data/tst_textarea.qml \
    $$PWD/data/tst_applicationwindow.qml \
    $$PWD/data/tst_combobox.qml \
    $$PWD/data/tst_progressbar.qml \
    $$PWD/data/tst_radiobutton.qml \
    $$PWD/data/tst_label.qml \
    $$PWD/data/tst_page.qml \
    $$PWD/data/tst_menubar.qml \
    $$PWD/data/tst_slider.qml \
    $$PWD/data/tst_statusbar.qml \
    $$PWD/data/tst_tab.qml \
    $$PWD/data/tst_tabframe.qml \
    $$PWD/data/tst_tableviewcolumn.qml \
    $$PWD/data/tst_toolbar.qml \
    $$PWD/data/tst_toolbutton.qml \
    $$PWD/data/tst_checkbox.qml

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0
