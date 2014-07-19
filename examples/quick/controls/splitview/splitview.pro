QT += qml quick
TARGET = splitview
!no_desktop: QT += widgets

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += \
    main.qml

RESOURCES += \
    resources.qrc
