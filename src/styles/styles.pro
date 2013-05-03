TARGETPATH = QtQuick/Controls/Styles

QML_FILES = \
    ButtonStyle.qml \
    CheckBoxStyle.qml \
    ComboBoxStyle.qml \
    FocusFrameStyle.qml \
    GroupBoxStyle.qml \
    MenuBarStyle.qml \
    MenuStyle.qml \
    ProgressBarStyle.qml \
    RadioButtonStyle.qml \
    ScrollBarStyle.qml \
    ScrollViewStyle.qml\
    SliderStyle.qml \
    SpinBoxStyle.qml \
    StatusBarStyle.qml \
    TableViewStyle.qml \
    TabViewStyle.qml \
    TextFieldStyle.qml \
    ToolBarStyle.qml \
    ToolButtonStyle.qml

# Desktop
QML_FILES += \
    Desktop/ButtonStyle.qml \
    Desktop/CheckBoxStyle.qml \
    Desktop/ComboBoxStyle.qml \
    Desktop/FocusFrameStyle.qml \
    Desktop/GroupBoxStyle.qml \
    Desktop/MenuBarStyle.qml \
    Desktop/MenuStyle.qml \
    Desktop/ProgressBarStyle.qml \
    Desktop/RadioButtonStyle.qml \
    Desktop/ScrollViewStyle.qml \
    Desktop/ScrollBarStyle.qml \
    Desktop/SliderStyle.qml \
    Desktop/SpinBoxStyle.qml \
    Desktop/StatusBarStyle.qml\
    Desktop/TabViewStyle.qml \
    Desktop/TableViewStyle.qml \
    Desktop/TextFieldStyle.qml \
    Desktop/ToolBarStyle.qml \
    Desktop/ToolButtonStyle.qml

# Images
QML_FILES += \
    images/button.png \
    images/button_down.png \
    images/tab.png \
    images/groupbox.png \
    images/focusframe.png \
    images/tab_selected.png \
    images/editbox.png \
    images/arrow-up.png \
    images/arrow-up@2x.png \
    images/arrow-down.png \
    images/arrow-down@2x.png \
    images/arrow-left.png \
    images/arrow-left@2x.png \
    images/arrow-right.png \
    images/arrow-right@2x.png

load(qml_module)
