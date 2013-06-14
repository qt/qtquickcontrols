TARGETPATH = QtQuick/Controls/Styles

QMAKE_DOCS = $$PWD/doc/qtquickcontrolsstyles.qdocconf

# Base
QML_FILES = \
    Base/ButtonStyle.qml \
    Base/CheckBoxStyle.qml \
    Base/ComboBoxStyle.qml \
    Base/FocusFrameStyle.qml \
    Base/GroupBoxStyle.qml \
    Base/MenuBarStyle.qml \
    Base/MenuStyle.qml \
    Base/ProgressBarStyle.qml \
    Base/RadioButtonStyle.qml \
    Base/ScrollViewStyle.qml\
    Base/SliderStyle.qml \
    Base/SpinBoxStyle.qml \
    Base/StatusBarStyle.qml \
    Base/TableViewStyle.qml \
    Base/TabViewStyle.qml \
    Base/TextFieldStyle.qml \
    Base/ToolBarStyle.qml \
    Base/ToolButtonStyle.qml

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
    Base/images/button.png \
    Base/images/button_down.png \
    Base/images/tab.png \
    Base/images/header.png \
    Base/images/groupbox.png \
    Base/images/focusframe.png \
    Base/images/tab_selected.png \
    Base/images/scrollbar-handle-horizontal.png \
    Base/images/scrollbar-handle-vertical.png \
    Base/images/progress-indeterminate.png \
    Base/images/editbox.png \
    Base/images/arrow-up.png \
    Base/images/arrow-up@2x.png \
    Base/images/arrow-down.png \
    Base/images/arrow-down@2x.png \
    Base/images/arrow-left.png \
    Base/images/arrow-left@2x.png \
    Base/images/arrow-right.png \
    Base/images/arrow-right@2x.png

load(qml_module)
