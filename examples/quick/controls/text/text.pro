QT += qml quick
TARGET = text
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    qml/main.qml

RESOURCES += \
    resources.qrc
