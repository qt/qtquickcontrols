QT += qml quick
TARGET = touch
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    main.qml \
    content/AndroidDelegate.qml \
    content/ButtonPage.qml \
    content/ProgressBarPage.qml \
    content/SliderPage.qml \
    content/TabBarPage.qml \
    content/TextInputPage.qml

RESOURCES += \
    resources.qrc

MOC_DIR = ./.moc
OBJECTS_DIR = ./.obj
UI_DIR = ./.ui
RCC_DIR = ./.rcc
