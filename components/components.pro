TEMPLATE = subdirs # XXX: Avoid call the linker
TARGETPATH = QtDesktop

symbian {
    INSTALL_IMPORTS = /resource/qt/imports
} else {
    INSTALL_IMPORTS = $$[QT_INSTALL_IMPORTS]
}

QML_FILES = \
            qmldir \
            Button.qml \
            ComboBox.qml \
            Dial.qml \
            ProgressBar.qml \
            ScrollBar.qml \
            Switch.qml \
            TableView.qml \
            ToolBar.qml \
            ButtonRow.qml \
            Frame.qml \
            MenuItem.qml   \
            Slider.qml \
            TabBar.qml \
            Tab.qml \
            ToolButton.qml \
            CheckBox.qml \
            ContextMenu.qml \
            GroupBox.qml \
            Menu.qml \
            RadioButton.qml \
            SpinBox.qml \
            TabFrame.qml \
            TextArea.qml \
            ChoiceList.qml \       
            ScrollArea.qml \
            SplitterRow.qml \
            TableColumn.qml \
            TextField.qml

QML_DIRS = \
        custom \
        images 

qmlfiles.files = $$QML_FILES
qmlfiles.sources = $$QML_FILES
qmlfiles.path = $$INSTALL_IMPORTS/$$TARGETPATH

qmldirs.files = $$QML_DIRS
qmldirs.sources = $$QML_DIRS
qmldirs.path = $$INSTALL_IMPORTS/$$TARGETPATH

INSTALLS += qmlfiles qmldirs

symbian {
    DEPLOYMENT += qmlfiles qmldirs
}