TARGETPATH = QtQuick/Controls/Styles

QML_FILES = \
    ButtonStyle.qml \
    CheckBoxStyle.qml \
    ComboBoxStyle.qml \
    GroupBoxStyle.qml \
    MenuBarStyle.qml \
    MenuStyle.qml \
    ProgressBarStyle.qml \
    RadioButtonStyle.qml \
    ScrollBarStyle.qml \
    Settings.js \
    SliderStyle.qml \
    SpinBoxStyle.qml \
    Style.qml \
    TabFrameStyle.qml \
    TextFieldStyle.qml \
    ToolBarStyle.qml \
    ToolButtonStyle.qml

# Desktop
QML_FILES += \
    Desktop/ButtonStyle.qml \
    Desktop/CheckBoxStyle.qml \
    Desktop/ComboBoxStyle.qml \
    Desktop/GroupBoxStyle.qml \
    Desktop/MenuBarStyle.qml \
    Desktop/MenuStyle.qml \
    Desktop/ProgressBarStyle.qml \
    Desktop/RadioButtonStyle.qml \
    Desktop/ScrollBarStyle.qml \
    Desktop/SliderStyle.qml \
    Desktop/SpinBoxStyle.qml \
    Desktop/TabFrameStyle.qml \
    Desktop/TextFieldStyle.qml \
    Desktop/ToolBarStyle.qml \
    Desktop/ToolButtonStyle.qml

# Images
QML_FILES += \
    images/arrow-up.png \
    images/arrow-down.png

load(qml_module)
