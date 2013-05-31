QT += qml quick
TARGET = tableview
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    main.qml

RESOURCES += \
    resources.qrc
