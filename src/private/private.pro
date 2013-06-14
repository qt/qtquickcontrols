TARGET  = qtquickcontrolsprivateplugin
TARGETPATH = QtQuick/Controls/Private

QT += qml quick gui-private core-private

HEADERS += \
    $$PWD/qquicktooltip_p.h \
    $$PWD/qquickspinboxvalidator_p.h \
    $$PWD/qquickrangemodel_p.h \
    $$PWD/qquickrangemodel_p_p.h \
    $$PWD/qquickcontrolsettings_p.h \
    $$PWD/qquickwheelarea_p.h \
    $$PWD/qquickabstractstyle_p.h \
    $$PWD/qquickpadding_p.h

SOURCES += \
    $$PWD/plugin.cpp \
    $$PWD/qquicktooltip.cpp \
    $$PWD/qquickspinboxvalidator.cpp \
    $$PWD/qquickrangemodel.cpp \
    $$PWD/qquickcontrolsettings.cpp \
    $$PWD/qquickwheelarea.cpp \
    $$PWD/qquickabstractstyle.cpp

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


qtHaveModule(widgets) {
    QT += widgets
    HEADERS += $$PWD/qquickstyleitem_p.h
    SOURCES += $$PWD/qquickstyleitem.cpp
}

mac {
    LIBS += -framework Carbon
}

CONFIG += no_cxx_module
load(qml_plugin)
