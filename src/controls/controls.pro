TARGET  = qtquickcontrolsplugin
TARGETPATH = QtQuick/Controls

QT += qml quick gui-private core-private

QMAKE_DOCS = $$PWD/doc/qtquickcontrols.qdocconf

QML_FILES = \
    ApplicationWindow.qml \
    Button.qml \
    CheckBox.qml \
    ComboBox.qml \
    GroupBox.qml \
    Label.qml \
    MenuBar.qml \
    Menu.qml \
    StackView.qml \
    ProgressBar.qml \
    RadioButton.qml \
    ScrollView.qml \
    Slider.qml \
    SpinBox.qml \
    SplitView.qml \
    StackViewDelegate.qml \
    StackViewTransition.qml \
    StatusBar.qml \
    Tab.qml \
    TabView.qml \
    TableView.qml \
    TableViewColumn.qml \
    TextArea.qml \
    TextField.qml \
    ToolBar.qml \
    ToolButton.qml

include(plugin.pri)

CONFIG += no_cxx_module
load(qml_plugin)
