QT += qml quick
TARGET = basiclayouts
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    main.qml

RESOURCES += \
    resources.qrc
