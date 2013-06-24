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

qtHaveModule(widgets) {
    QT += widgets
    HEADERS += $$PWD/qquickstyleitem_p.h
    SOURCES += $$PWD/qquickstyleitem.cpp
}
