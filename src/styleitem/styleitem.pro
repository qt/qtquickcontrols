TEMPLATE = lib
CONFIG += qt plugin
QT += qml quick widgets
 
TARGET  = styleplugin

DESTDIR = ../../components/plugin
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
           qtoplevelwindow.h

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
           qtoplevelwindow.cpp

TARGETPATH = QtDesktop/plugin

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += target
