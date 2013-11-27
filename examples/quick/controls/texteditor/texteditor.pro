QT += qml quick
TARGET = texteditor
!android: !ios: !blackberry: qtHaveModule(widgets): QT += widgets

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += \
    qml/main.qml \
    qml/ToolBarSeparator.qml

RESOURCES += \
    resources.qrc
