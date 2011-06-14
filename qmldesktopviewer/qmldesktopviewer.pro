TEMPLATE = app
TARGET =
DEPENDPATH += .
INCLUDEPATH += .
QT += declarative

# Input
HEADERS +=  qmldesktopviewer.h \
            loggerwidget.h \
            ../components/styleitem/qwindow.h
SOURCES +=  main.cpp \
            qmldesktopviewer.cpp \
            loggerwidget.cpp \
            ../components/styleitem/qwindow.cpp
