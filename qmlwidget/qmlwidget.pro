TEMPLATE = app
TARGET = qmlwidget
DEPENDPATH += . ../src/
INCLUDEPATH += . ../src/
QT += qml widgets quick

HEADERS += ../src/qwindowwidget.h
SOURCES += ../src/qwindowwidget.cpp

SOURCES += main.cpp
CONFIG -= app_bundle
