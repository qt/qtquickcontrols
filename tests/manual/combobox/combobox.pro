QT += qml quick
TARGET = combobox
!android: !ios: !blackberry: qtHaveModule(widgets): QT += widgets

SOURCES += $$PWD/main.cpp

OTHER_FILES += \
    qml/main.qml
