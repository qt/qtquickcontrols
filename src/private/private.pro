TARGET  = privateplugin
TARGETPATH = QtQuick/Controls/Private

QT += qml quick widgets gui-private core-private

HEADERS += \
    $$PWD/qquicktooltip_p.h \
    $$PWD/qquickrangemodel_p.h \
    $$PWD/qquickrangemodel_p_p.h \
    $$PWD/qquickwheelarea_p.h \
    $$PWD/qquickstyleitem_p.h

SOURCES += \
    $$PWD/plugin.cpp \
    $$PWD/qquicktooltip.cpp \
    $$PWD/qquickstyleitem.cpp \
    $$PWD/qquickrangemodel.cpp \
    $$PWD/qquickwheelarea.cpp

# private qml files
QML_FILES += \
    AbstractCheckable.qml \
    TabBar.qml \
    BasicButton.qml \
    Control.qml \
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
