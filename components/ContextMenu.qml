import QtQuick 1.1

Menu {
    id: root
    property ListModel model
    property string selectedText: itemTextAt(selectedIndex)
    property string hoveredText: itemTextAt(hoveredIndex)
    property int x
    property int y
    property bool visible

    // 'centerSelectedText' means that the menu will be positioned
    //  so that the selected text' top left corner will be at x, y.
    property bool centerSelectedText: true

    visible: false
    onMenuClosed: visible = false
    onModelChanged: if (Component.status === Component.Ready && model != undefined) rebuildMenu()
    Component.onCompleted: if (model != undefined) rebuildMenu()

    onHoveredIndexChanged: {
        if (hoveredIndex < menuItems.length)
            menuItems[hoveredIndex].hovered()
    }

    onSelectedIndexChanged: {
        if (hoveredIndex < menuItems.length)
            menuItems[hoveredIndex].selected()
    }

    onVisibleChanged: {
        if (visible) {
            var globalPos = mapToItem(null, x, y)
            showPopup(globalPos.x, globalPos.y, centerSelectedText ? selectedIndex : 0)
        } else {
            hidePopup()
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
