TEMPLATE = lib
CONFIG += qt plugin
QT += qml
QT += quick
QT += widgets

TARGET  = styleplugin

DESTDIR = ../imports/QtDesktop/plugin
OBJECTS_DIR = obj
MOC_DIR = moc

HEADERS += qtmenu.h \
           qtmenubar.h \
           qrangemodel_p.h \
           qrangemodel.h \
           qstyleplugin.h \
           qstyleitem.h \
           qwheelarea.h \
           qtmenuitem.h \
           qdesktopitem.h \
           qquicklayoutengine_p.h \
           qquicklayout.h \
           qquicklinearlayout.h \
           qquickcomponentsprivate.h \
           qtsplitterbase.h \
           qfiledialogitem.h

SOURCES += qtmenu.cpp \
           qtmenubar.cpp \
           qrangemodel.cpp \
           qstyleplugin.cpp \
           qstyleitem.cpp \
           qwheelarea.cpp \
           qtmenuitem.cpp \
           qdesktopitem.cpp \
           qquicklayout.cpp \
           qquicklayoutengine.cpp \
           qquicklinearlayout.cpp \
           qquickcomponentsprivate.cpp \
           qtsplitterbase.cpp \
           qfiledialogitem.cpp

TARGETPATH = QtDesktop/plugin

target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

win32 {
    CONFIG(debug, debug|release) {
        TARGET = $$member(TARGET, 0)d
    }
}

mac {
    LIBS += -framework Carbon
}

INSTALLS += target
