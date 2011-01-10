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
           

OTHER_FILES += \
    ../widgets/Button.qml \
    ../widgets/CheckBox.qml \
    ../widgets/ChoiceList.qml \
    ../widgets/GroupBox.qml \
    ../widgets/ProgressBar.qml \
    ../widgets/RadioButton.qml \
    ../widgets/ScrollArea.qml \
    ../widgets/ScrollBar.qml \
    ../widgets/Slider.qml \
    ../widgets/SpinBox.qml \
    ../widgets/Switch.qml \
    ../widgets/TextArea.qml \
    ../widgets/TextField.qml \
    ../widgets/ToolBar.qml \
    ../widgets/ToolButton.qml \
    ../gallery.qml
