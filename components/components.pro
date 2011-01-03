TEMPLATE = subdirs # XXX: Avoid call the linker
TARGETPATH = Qt/labs/components/custom

QML_FILES = \
        qmldir \
        BasicButton.qml \
        BusyIndicator.qml \
        ButtonBlock.qml \
        Button.qml \
        CheckBox.qml \
        ChoiceList.qml \
        ProgressBar.qml \
        RadioButton.qml \
        ScrollDecorator.qml \
        ScrollIndicator.qml \
        Slider.qml \
        SpinBox.qml \
        Switch.qml \
        TextArea.qml \
        TextField.qml

QML_DIRS = \
        behaviors \
        private \
        styles \
        visuals

qmlfiles.files = $$QML_FILES
qmlfiles.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

qmldirs.files = $$QML_DIRS
qmldirs.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH

INSTALLS += qmlfiles qmldirs
