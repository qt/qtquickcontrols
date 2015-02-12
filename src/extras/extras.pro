TARGET = qtquickextrasplugin
TARGETPATH = QtQuick/Extras
IMPORT_VERSION = 1.3

QT += qml

# Qt 5.1 requires a different set of includes for .qdocconf
equals(QT_MAJOR_VERSION, 5):!greaterThan(QT_MINOR_VERSION, 1) {
    QMAKE_DOCS = $$PWD/doc/compat/qtquickextras.qdocconf
} else {
    QMAKE_DOCS = $$PWD/doc/qtquickextras.qdocconf
}

CONTROLS_QML_FILES = \
    CircularGauge.qml \
    DelayButton.qml \
    Dial.qml \
    Gauge.qml \
    StatusIndicator.qml \
    PieMenu.qml \
    ToggleButton.qml \
    Tumbler.qml \
    TumblerColumn.qml

HEADERS += plugin.h \
    qquicktriggermode_p.h \
    qquickpicture_p.h
SOURCES += plugin.cpp \
    qquickpicture.cpp

include(Private/private.pri)
include(designer/designer.pri)

OTHER_FILES += doc/src/*

RESOURCES += extras.qrc

CONFIG += no_cxx_module
load(qml_plugin)
