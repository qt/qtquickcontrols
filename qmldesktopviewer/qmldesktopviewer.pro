TEMPLATE = app
TARGET = qmldesktopviewer
DEPENDPATH += .
INCLUDEPATH += .
QT += qml widgets quick

# Input
HEADERS +=  qmldesktopviewer.h \
            loggerwidget.h
SOURCES +=  main.cpp \
            qmldesktopviewer.cpp \
            loggerwidget.cpp
