QT += qml quick
TARGET = splitview
!android: !ios: !blackberry: qtHaveModule(widgets): QT += widgets

include(src/src.pri)

OTHER_FILES += \
    main.qml

RESOURCES += \
    resources.qrc
