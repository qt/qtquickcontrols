TEMPLATE = lib
CONFIG += qt plugin
QT += declarative
QT += quick
QT += script
 
TARGET  = styleplugin

DESTDIR = ../components/plugin
OBJECTS_DIR = obj
MOC_DIR = moc

HEADERS += qrangemodel_p.h \
           qrangemodel.h \
           qstyleplugin.h \
           qdeclarativefolderlistmodel.h \
           qstyleitem.h \
           qwheelarea.h \
           qdesktopitem.h \
           qcursorarea.h \
           qtooltiparea.h \
    qtsplitterbase.h

SOURCES += qrangemodel.cpp \
           qstyleplugin.cpp \
           qdeclarativefolderlistmodel.cpp \
           qstyleitem.cpp \
           qwheelarea.cpp \
           qdesktopitem.cpp \
           qcursorarea.cpp \
           qtooltiparea.cpp \
    qtsplitterbase.cpp

TARGETPATH = QtDesktop/plugin

symbian {
    INSTALL_IMPORTS = /resource/qt/imports
} else {
    INSTALL_IMPORTS = $$[QT_INSTALL_IMPORTS]
}
           
target.path = $$INSTALL_IMPORTS/$$TARGETPATH

win32 {
    CONFIG(debug, debug|release) {
        TARGET = $$member(TARGET, 0)d
    }
}

mac {
    LIBS += -framework Carbon
}

INSTALLS += target

symbian {
    DEPLOYMENT += target
}
