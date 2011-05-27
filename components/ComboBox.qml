import QtQuick 1.0

Item {
    id: comboBox

    property alias model: popup.model
//    property alias currentIndex: 0//popup.currentIndex
//    property alias currentText: popup.currentText
//    property alias popupOpen: popup.popupOpen
//    property alias containsMouse: popup.containsMouse
//    property alias pressed: popup.buttonPressed

    property int currentIndex: 0
    property bool containsMouse: false
    property bool pressed: false

    property string hint

    property Component background: QStyleItem {
        anchors.fill: parent
        elementType: "combobox"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled: comboBox.enabled
        text: currentItemText
        focus: comboBox.focus
        hint: comboBox.hint
    }

//    property int leftMargin: 0
//    property int topMargin: 0
//    property int rightMargin: 0
//    property int bottomMargin: 0

//    property string popupBehavior
//    width: 0
    height: 20

//    property bool activeFocusOnPress: true

    Loader {
        id: backgroundLoader
        property alias styledItem: comboBox
        sourceComponent: background
        anchors.fill: parent
        property string currentItemText: model.get(currentIndex).text
    }

    ContextMenu {
        id: popup
        x: 0
        y: 0
        target: comboBox
    }

    MouseArea {
        anchors.fill: parent
        onPressed: popup.visible = true
    }

//    Keys.onSpacePressed: { comboBox.popupOpen = !comboBox.popupOpen }
//    Keys.onUpPressed: { if (currentIndex < model.count - 1) currentIndex++ }
//    Keys.onDownPressed: {if (currentIndex > 0) currentIndex-- }
}
