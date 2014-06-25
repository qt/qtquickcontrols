QT += qml quick
TARGET = splitview
!android:!ios:!blackberry:!qnx:!winrt:qtHaveModule(widgets): QT += widgets

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += \
    main.qml

RESOURCES += \
    resources.qrc
