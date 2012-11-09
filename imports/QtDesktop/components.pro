TEMPLATE = subdirs # XXX: Avoid calling the linker
TARGETPATH = QtDesktop

QML_FILES = \
            plugins.qmltypes \
            qmldir \
            Label.qml \
            Button.qml \
            ComboBox.qml \
            Dial.qml \
            Dialog.qml \
            ProgressBar.qml \
            ScrollBar.qml \
            Switch.qml \
            TableView.qml \
            ToolBar.qml \
            ButtonRow.qml \
            ButtonColumn.qml \
            Frame.qml \
            Slider.qml \
            TabBar.qml \
            Tab.qml \
            ToolButton.qml \
            CheckBox.qml \
            ContextMenu.qml \
            GroupBox.qml \
            RadioButton.qml \
            SpinBox.qml \
            TabFrame.qml \
            TextArea.qml \
            ScrollArea.qml \
            SplitterRow.qml \
            SplitterColumn.qml \
            StatusBar.qml \
            TableColumn.qml \
            TextField.qml \
            ApplicationWindow.qml \
            Styles/ToolButtonStyle.qml \
            Styles/ToolBarStyle.qml \
            Styles/TextFieldStyle.qml \
            Styles/TabBarStyle.qml \
            Styles/TabFrameStyle.qml \
            Styles/SpinBoxStyle.qml \
            Styles/SliderStyle.qml \
            Styles/ScrollBarStyle.qml \
            Styles/ScrollAreaStyle.qml \
            Styles/RadioButtonStyle.qml \
            Styles/ProgressBarStyle.qml \
            Styles/GroupBoxStyle.qml \
            Styles/FrameStyle.qml \
            Styles/ComboBoxStyle.qml \
            Styles/CheckBoxStyle.qml \
            Styles/ButtonStyle.qml \
            Styles/Desktop/ToolButtonStyle.qml \
            Styles/Desktop/ToolBarStyle.qml \
            Styles/Desktop/TextFieldStyle.qml \
            Styles/Desktop/TabBarStyle.qml \
            Styles/Desktop/TabFrameStyle.qml \
            Styles/Desktop/SpinBoxStyle.qml \
            Styles/Desktop/SliderStyle.qml \
            Styles/Desktop/ScrollBarStyle.qml \
            Styles/Desktop/ScrollAreaStyle.qml \
            Styles/Desktop/RadioButtonStyle.qml \
            Styles/Desktop/ProgressBarStyle.qml \
            Styles/Desktop/GroupBoxStyle.qml \
            Styles/Desktop/FrameStyle.qml \
            Styles/Desktop/ComboBoxStyle.qml \
            Styles/Desktop/CheckBoxStyle.qml \
            Styles/Desktop/ButtonStyle.qml

QML_DIRS = \
        custom \
        private \
        Styles \
        images 

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

qmldirs.files = $$QML_DIRS
qmldirs.sources = $$QML_DIRS
qmldirs.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles qmldirs
