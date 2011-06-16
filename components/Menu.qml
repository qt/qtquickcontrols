import QtQuick 2.0
import "../components/plugin"

MenuBase {
    property ListModel model

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
        if (hoveredIndex < menuItems.length)
            menuItems[hoveredIndex].emitHovered()
    }

    onSelectedIndexChanged: {
        if (hoveredIndex < menuItems.length)
            menuItems[hoveredIndex].emitSelected()
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
        for (var i=0; i<menuItems.length; ++i)
            addMenuItem(menuItems[i].text)
        if (model != undefined) {
            for (var j=0; j<model.count; ++j)
                addMenuItem(model.get(j).text)
        }
    }
}
