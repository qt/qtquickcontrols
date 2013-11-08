HEADERS += \
    $$PWD/qquicktooltip_p.h \
    $$PWD/qquickspinboxvalidator_p.h \
    $$PWD/qquickrangemodel_p.h \
    $$PWD/qquickrangemodel_p_p.h \
    $$PWD/qquickcontrolsettings_p.h \
    $$PWD/qquickwheelarea_p.h \
    $$PWD/qquickabstractstyle_p.h \
    $$PWD/qquickpadding_p.h \
    $$PWD/qquickcontrolsprivate_p.h

SOURCES += \
    $$PWD/qquicktooltip.cpp \
    $$PWD/qquickspinboxvalidator.cpp \
    $$PWD/qquickrangemodel.cpp \
    $$PWD/qquickcontrolsettings.cpp \
    $$PWD/qquickwheelarea.cpp \
    $$PWD/qquickabstractstyle.cpp


!android: !ios: !blackberry: qtHaveModule(widgets) {
    QT += widgets
    HEADERS += $$PWD/qquickstyleitem_p.h
    SOURCES += $$PWD/qquickstyleitem.cpp
}

# private qml files
PRIVATE_QML_FILES += \
    $$PWD/AbstractCheckable.qml \
    $$PWD/TabBar.qml \
    $$PWD/BasicButton.qml \
    $$PWD/Control.qml \
    $$PWD/FastGlow.qml \
    $$PWD/SourceProxy.qml\
    $$PWD/Style.qml \
    $$PWD/style.js \
    $$PWD/ModalPopupBehavior.qml \
    $$PWD/StackViewSlideDelegate.qml \
    $$PWD/StackView.js \
    $$PWD/ScrollViewHelper.qml \
    $$PWD/ScrollBar.qml \
    $$PWD/TableViewSelection.qml \
    $$PWD/TextSingleton.qml \
    $$PWD/FocusFrame.qml \
    $$PWD/ColumnMenuContent.qml \
    $$PWD/MenuContentItem.qml \
    $$PWD/MenuContentScroller.qml \
    $$PWD/qmldir

QML_FILES += $$PRIVATE_QML_FILES
