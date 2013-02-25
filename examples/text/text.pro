QT += widgets qml quick
CONFIG += console
TARGET = text

include(src/src.pri)

OTHER_FILES += \
    qml/main.qml

RESOURCES += \
    resources.qrc

MOC_DIR = ./.moc
OBJECTS_DIR = ./.obj
UI_DIR = ./.ui
RCC_DIR = ./.rcc
