CXX_MODULE = qml
TARGET  = plugin
TARGETPATH = QtDesktop

QT += qml quick widgets gui-private core-private

QMAKE_DOCS = $$PWD/doc/qtdesktopcomponents.qdocconf

QML_FILES = \
    ApplicationWindow.qml \
    Button.qml \
    CheckBox.qml \
    ComboBox.qml \
    ContextMenu.qml \
    GroupBox.qml \
    Label.qml \
    MenuBar.qml \
    Menu.qml \
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
    TableView.qml \
    TableViewColumn.qml \
    TextArea.qml \
    TextField.qml \
    ToolBar.qml \
    ToolButton.qml

include(plugin.pri)

DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0


load(qml_plugin)
