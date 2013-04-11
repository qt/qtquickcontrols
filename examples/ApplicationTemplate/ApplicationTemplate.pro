QT += qml quick widgets
CONFIG += console
TARGET = application
SOURCES += \
    main.cpp

OTHER_FILES += \
    qml/main.qml

RESOURCES += \
    resources.qrc

MOC_DIR = ./.moc
OBJECTS_DIR = ./.obj
UI_DIR = ./.ui
RCC_DIR = ./.rcc
