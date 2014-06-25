QT += qml quick
TARGET = gallery
!android:!ios:!blackberry:!qnx:!winrt:qtHaveModule(widgets): QT += widgets

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += \
    main.qml \
    content/AboutDialog.qml \
    content/ChildWindow.qml \
    content/Controls.qml \
    content/ImageViewer.qml \
    content/ModelView.qml \
    content/Styles.qml

RESOURCES += \
    resources.qrc
