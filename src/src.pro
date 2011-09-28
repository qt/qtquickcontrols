TEMPLATE = lib
CONFIG += qt plugin
QT += declarative
QT += script
 
TARGET  = styleplugin

DESTDIR = ../components/plugin
OBJECTS_DIR = obj
MOC_DIR = moc

HEADERS += qtmenu.h \
           qtmenubar.h \
           qrangemodel_p.h \
           qrangemodel.h \
           qstyleplugin.h \
           qdeclarativefolderlistmodel.h \
           qstyleitem.h \
           qwheelarea.h \
           qtmenuitem.h \
           qwindowitem.h \
           qdesktopitem.h \
           qtoplevelwindow.h \
           qcursorarea.h \
           qtooltiparea.h

SOURCES += qtmenu.cpp \
           qtmenubar.cpp \
           qrangemodel.cpp \
           qstyleplugin.cpp \
           qdeclarativefolderlistmodel.cpp \
           qstyleitem.cpp \
           qwheelarea.cpp \
           qtmenuitem.cpp \
           qwindowitem.cpp \
           qdesktopitem.cpp \
           qtoplevelwindow.cpp \
           qcursorarea.cpp \
           qtooltiparea.cpp

TARGETPATH = QtDesktop/plugin

symbian {
    INSTALL_IMPORTS = /resource/qt/imports
} else {
    INSTALL_IMPORTS = $$[QT_INSTALL_IMPORTS]
}
           
target.path = $$INSTALL_IMPORTS/$$TARGETPATH

mac {
    LIBS += -framework Carbon
}

INSTALLS += target

symbian {
    DEPLOYMENT += target
}








