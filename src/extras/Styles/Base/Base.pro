TARGET = qtquickextrasstylesplugin
TARGETPATH = QtQuick/Extras/Styles

QT += qml

HEADERS += \
    basestyleplugin.h
SOURCES += \
    basestyleplugin.cpp

BASE_STYLE = \
    $$PWD/CircularGaugeStyle.qml \
    $$PWD/CircularButtonStyle.qml \
    $$PWD/CircularTickmarkLabelStyle.qml \
    $$PWD/CommonStyleHelper.qml \
    $$PWD/DelayButtonStyle.qml \
    $$PWD/DialStyle.qml \
    $$PWD/GaugeStyle.qml \
    $$PWD/HandleStyle.qml \
    $$PWD/HandleStyleHelper.qml \
    $$PWD/PieMenuStyle.qml \
    $$PWD/StatusIndicatorStyle.qml \
    $$PWD/ToggleButtonStyle.qml \
    $$PWD/TumblerStyle.qml

BASE_STYLE += \
    $$PWD/images/knob.png \
    $$PWD/images/needle.png

RESOURCES += \
    basestyle.qrc

CONFIG += no_cxx_module
load(qml_plugin)
