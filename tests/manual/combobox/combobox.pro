QT += qml quick
TARGET = combobox
qtHaveModule(widgets) {
    QT += widgets
}

SOURCES += $$PWD/main.cpp

OTHER_FILES += \
    qml/main.qml
