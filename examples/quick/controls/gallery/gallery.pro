QT += qml quick
TARGET = gallery
qtHaveModule(widgets) {
    QT += widgets
}

include(src/src.pri)

OTHER_FILES += \
    main.qml \
    content/ChildWindow.qml \
    content/Controls.qml \
    content/ImageViewer.qml \
    content/ModelView.qml \
    content/Panel.qml \
    content/Styles.qml

RESOURCES += \
    resources.qrc
