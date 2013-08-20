QT += qml quick
TARGET = texteditor
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    qml/main.qml \
    qml/ToolBarSeparator.qml

RESOURCES += \
    resources.qrc
