TARGET  = qtquickcontrolsprivateplugin
TARGETPATH = QtQuick/Controls/Private

QT += qml quick gui-private core-private

include(private.pri)

SOURCES += $$PWD/plugin.cpp

# private qml files
QML_FILES += \
    AbstractCheckable.qml \
    TabBar.qml \
    BasicButton.qml \
    Control.qml \
    Style.qml \
    style.js \
    ModalPopupBehavior.qml \
    StackViewSlideDelegate.qml \
    StackView.js \
    ScrollViewHelper.qml \
    ScrollBar.qml \
    FocusFrame.qml

mac {
    LIBS += -framework Carbon
}

CONFIG += no_cxx_module
load(qml_plugin)
