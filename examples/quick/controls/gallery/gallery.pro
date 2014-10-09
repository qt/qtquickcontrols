QT += qml quick
TARGET = gallery
!no_desktop: QT += widgets

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += \
    main.qml \
    content/AboutDialog.qml \
    content/Controls.qml \
    content/ImageViewer.qml \
    content/ModelView.qml \
    content/Styles.qml

RESOURCES += \
    resources.qrc
