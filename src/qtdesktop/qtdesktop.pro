QT += qml quick widgets

TARGETPATH = QtDesktop

QMAKE_DOCS = $$PWD/doc/qtdesktopcomponents.qdocconf

QML_FILES = \
    ApplicationWindow.qml \
    Button.qml \
    ButtonColumn.qml \
    ButtonRow.qml \
    CheckBox.qml \
    ComboBox.qml \
    ContextMenu.qml \
    Dial.qml \
    Dialog.qml \
    Frame.qml \
    GroupBox.qml \
    Label.qml \
    ProgressBar.qml \
    RadioButton.qml \
    ScrollArea.qml \
    ScrollBar.qml \
    Slider.qml \
    SpinBox.qml \
    SplitterColumn.qml \
    SplitterRow.qml \
    StatusBar.qml \
    Tab.qml \
    TabBar.qml \
    TabFrame.qml \
    TableColumn.qml \
    TableView.qml \
    TextArea.qml \
    TextField.qml \
    ToolBar.qml \
    ToolButton.qml

# private qml files
QML_FILES += \
    private/BasicButton.qml \
    private/ButtonBehavior.qml \
    private/ButtonGroup.js \
    private/ModalPopupBehavior.qml \
    private/ScrollAreaHelper.qml \
    private/Splitter.qml

include(styleplugin.pri)

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0

mac {
    LIBS += -framework Carbon
}

load(qml_plugin)

#tmp solution for QTBUG-28200
TARGET = $$qtLibraryTarget(styleplugin)
DESTDIR = $$QT.core.qml/QtDesktop/plugin
