import QtQuick 1.0
import "plugin"

/*
*
* Menu
*
* The Menu component is a popup menu which is platform native, and cannot by styled
* from QML code. Add menu items either by adding MenuItem children, or assign it a
* ListModel (or both).
*
* The Menu contains the following API:
*
* bool visible: if true, the popup menu will be open
* ListModel model - the model that will be used, in addition to MenuItem children, to
*   create native menu items inside the menu
* int selectedIndex - the index of the selected item in the menu.
* int hoveredIndex - the index of the highlighted item in the menu.
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
*    Menu {
*        model: menuItems
*        width: 200
*        onSelectedIndexChanged: console.debug(selectedText + ", " + menuItems.get(selectedIndex).color)
*    }
*
* Example 2:
*
*    Menu {
*        width: 200
*        MenuItem {
*            text: "Pineapple"
*            onSelected: console.debug(text)
*
*        }
*        MenuItem {
*            text: "Grape"
*            onSelected: console.debug(text)
*        }
*    }
*
*/

MenuBase {
    id: root
    property ListModel model

    property list<MenuItem> items
    default property alias menuItems: root.items
    property string selectedText: itemTextAt(selectedIndex)
    property string hoveredText: itemTextAt(hoveredIndex)

    // 'centerSelectedText' means that the menu will be positioned
    //  so that the selected text' top left corner will be at x, y.
    property bool centerSelectedText: true

    // Show, or hide, the popup by setting the 'visible' property:
    visible: false
    onMenuClosed: visible = false
    onModelChanged: if (Component.status === Component.Ready) rebuildMenu()
    Component.onCompleted: rebuildMenu()

    onHoveredIndexChanged: {
        if (hoveredIndex < items.length)
            items[hoveredIndex].hovered()
    }

    onSelectedIndexChanged: {
        if (hoveredIndex < items.length)
            items[hoveredIndex].selected()
    }

    onVisibleChanged: {
        if (visible) {
            var globalPos = parent.mapToItem(null, x, y)
            showPopup(globalPos.x, globalPos.y, centerSelectedText ? selectedIndex : 0)
        } else {
            closePopup()
        }
    }

    function rebuildMenu()
    {
        clearMenuItems();
        for (var i=0; i<items.length; ++i)
            addMenuItem(items[i].text)
        if (model != undefined) {
            for (var j=0; j<model.count; ++j)
                addMenuItem(model.get(j).text)
        }
    }
}
