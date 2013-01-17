CXX_MODULE = qml
TARGET  = styleplugin
TARGETPATH = QtDesktop

QT += qml quick widgets

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
    Page.qml \
    PageAnimation.qml \
    PageStack.qml \
    PageTransition.qml \
    ProgressBar.qml \
    RadioButton.qml \
    ScrollArea.qml \
    Slider.qml \
    SpinBox.qml \
    SplitterColumn.qml \
    SplitterRow.qml \
    StatusBar.qml \
    Tab.qml \
    TabFrame.qml \
    TableColumn.qml \
    TableView.qml \
    TextArea.qml \
    TextField.qml \
    ToolBar.qml \
    ToolButton.qml

# private qml files
QML_FILES += \
    private/TabBar.qml \
    private/BasicButton.qml \
    private/ButtonBehavior.qml \
    private/ButtonGroup.js \
    private/ModalPopupBehavior.qml \
    private/PageSlideTransition.qml \
    private/PageStack.js \
    private/ScrollAreaHelper.qml \
    private/Splitter.qml \
    private/ScrollBar.qml

include(styleplugin.pri)

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0

mac {
    LIBS += -framework Carbon
}

load(qml_plugin)
