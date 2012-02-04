import QtQuick 1.1
import "custom" as Custom

/*
*
* ComboBox (inherits BasicButton)
*
* The ComboBox component is a combined button and popup list. The popup menu itself is platform
* native, and cannot by styled from QML code.
* Add menu items to the comboBox by either adding MenuItem children inside the popup, or
* assign it a ListModel (or both).
*
* The ComboBox contains the following API (in addition to the BasicButton API):
*
* ListModel model - this model will be used, in addition to MenuItem children, to
*   create items inside the popup menu
* bool popupOpen - setting this property to 'true' will open the popup.
* int selectedIndex - the index of the selected item in the popup menu.
* int hoveredIndex - the index of the highlighted item in the popup menu.
* string selectedText - the text of the selected menu item.
* string hoveredText - the text of the highlighted menu item.
*
* Example 1:
*
*    ListModel {
*        id: menuItems
*        ListElement { text: "Banana"; color: "Yellow" }
*        ListElement { text: "Apple"; color: "Green" }
*        ListElement { text: "Coconut"; color: "Brown" }
*    }
*    ComboBox {
*        model: menuItems
*        width: 200
*        onSelectedIndexChanged: console.debug(selectedText + ", " + menuItems.get(selectedIndex).color)
*    }
*
* Example 2:
*
*    ComboBox {
*        width: 200
*        MenuItem {
*            text: "Pineapple"
*            onTriggered: console.debug(text)
*
*        }
*        MenuItem {
*            text: "Grape"
*            onTriggered: console.debug(text)
*        }
*    }
*
*/

Custom.BasicButton {
    id: comboBox

    default property alias menuItems: popup.menuItems
    property alias model: popup.model
    property alias popupOpen: popup.visible

    property alias selectedIndex: popup.selectedIndex
    property alias hoveredIndex: popup.hoveredIndex
    property alias selectedText: popup.selectedText
    property alias hoveredText: popup.hoveredText
    property string styleHint

    background: StyleItem {
        anchors.fill: parent
        elementType: "combobox"
        sunken: comboBox.pressed
        raised: !sunken
        hover: comboBox.containsMouse
        enabled: comboBox.enabled
        text: comboBox.selectedText
        hasFocus: comboBox.focus
        contentHeight: 18
    }

//  ToDo: adjust margins so that selected popup label
//    centers directly above button label when
//    popup.centerOnSelectedText === true


    width: implicitWidth
    height: implicitHeight

    implicitWidth: Math.max(80, backgroundItem.implicitWidth)
    implicitHeight: backgroundItem.implicitHeight

    onWidthChanged: popup.setMinimumWidth(width)
    checkable: false

    onPressedChanged: if (pressed) popup.visible = true

    ContextMenu {
        id: popup
        property bool center: backgroundItem.styleHint("comboboxpopup")
        centerSelectedText: center
        y: center ? 0 : comboBox.height
    }

    // The key bindings below will only be in use when popup is
    // not visible. Otherwise, native popup key handling will take place:
    Keys.onSpacePressed: { comboBox.popupOpen = !comboBox.popupOpen }
    Keys.onUpPressed: { if (selectedIndex < model.count - 1) selectedIndex++ }
    Keys.onDownPressed: { if (selectedIndex > 0) selectedIndex-- }
}
