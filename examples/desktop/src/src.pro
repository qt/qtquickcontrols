TEMPLATE = lib
CONFIG += qt plugin
QT += declarative
QT += script
 
TARGET  = styleplugin

DESTDIR = ..\\plugin
OBJECTS_DIR = tmp
MOC_DIR = tmp

HEADERS += qstyleplugin.h \
           qstyleitem.h

SOURCES += qstyleplugin.cpp \
	   qstyleitem.cpp
           
