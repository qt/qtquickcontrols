import QtQuick 1.0

Item {
    id: comboBox

    property alias model: popup.model
    property alias selectedIndex: popup.selectedIndex
    property alias highlightedIndex: popup.highlightedIndex
    property string selectedText: model.get(popup.visible ? selectedIndex : highlightedIndex).text
    property alias popupOpen: popup.visible
    property alias popupMenu: popup
    property alias buttonMouseArea: mouseArea
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

//    ToDo: adjust margins so that selected popup label
//      centers directly above button label when
//      popup.centerOnSelectedText === true
//    property int leftMargin: 0
//    property int topMargin: 0
//    property int rightMargin: 0
//    property int bottomMargin: 0

    width: backgroundLoader.item.sizeFromContents(100, 18).height
    height: backgroundLoader.item.sizeFromContents(100, 18).height

    Loader {
        id: backgroundLoader
        property alias styledItem: comboBox
        sourceComponent: background
        anchors.fill: parent
        property string currentItemText: comboBox.selectedText
    }

    ContextMenu {
        id: popup
        property bool center: backgroundLoader.item.styleHint("comboboxpopup")
        centerOnSelectedText: center
        y: center ? 0 : comboBox.height
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: popupOpen = true
    }

    // The key bindings below will only be in use when popup is
    // not visible. Otherwise, native popup key handling will take place:
    Keys.onSpacePressed: { comboBox.popupOpen = !comboBox.popupOpen }
    Keys.onUpPressed: { if (selectedIndex < model.count - 1) selectedIndex++ }
    Keys.onDownPressed: { if (selectedIndex > 0) selectedIndex-- }
}
