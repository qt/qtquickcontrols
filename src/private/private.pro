TARGET  = privateplugin
TARGETPATH = QtQuick/Controls/Private

QT += qml quick widgets gui-private core-private

HEADERS += \
    $$PWD/qquickcomponentsprivate_p.h \
    $$PWD/qprivateplugin_p.h\
    $$PWD/qrangemodel_p.h \
    $$PWD/qrangemodel_p_p.h \
    $$PWD/qwheelarea_p.h \
    $$PWD/qstyleitem_p.h

SOURCES += \
    $$PWD/qquickcomponentsprivate.cpp \
    $$PWD/qprivateplugin.cpp\
    $$PWD/qstyleitem.cpp \
    $$PWD/qrangemodel.cpp\
    $$PWD/qwheelarea.cpp

OTHER_FILES += \
    $$PWD/privateplugin.json

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
