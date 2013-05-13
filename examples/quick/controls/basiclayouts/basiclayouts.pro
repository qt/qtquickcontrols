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

MOC_DIR = ./.moc
OBJECTS_DIR = ./.obj
UI_DIR = ./.ui
RCC_DIR = ./.rcc
