import QtQuick 1.1

Menu {
    id: root
    property string selectedText: itemTextAt(selectedIndex)
    property string hoveredText: itemTextAt(hoveredIndex)
    property int x
    property int y
    property bool visible
    property string textRole

    // 'centerSelectedText' means that the menu will be positioned
    //  so that the selected text' top left corner will be at x, y.
    property bool centerSelectedText: true

    visible: false
    onMenuClosed: visible = false
    onModelChanged: if (Component.status === Component.Ready && model != undefined) rebuildMenu()

    Component.onCompleted: if (model !== undefined) rebuildMenu()

    onRebuildMenu: rebuildMenu()

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

        var nativeModel = root.hasNativeModel()

        if (model !== undefined) {
            var modelCount = nativeModel ? root.modelCount() : model.count;
            for (var j = 0 ; j < modelCount; ++j) {
                var textValue
                if (nativeModel) {
                    textValue = root.modelTextAt(j);
                } else {
                    if (textRole !== "")
                        textValue = model.get(j)[textRole]
                    else if (model.count > 0 && root.model.get && root.model.get(0)) {
                        // ListModel with one role
                        var listElement = root.model.get(0)
                        var oneRole = true
                        var roleName = ""
                        var roleCount = 0
                        for (var role in listElement) {
                            if (!roleName || role === "text")
                                roleName = role
                            ++roleCount
                        }
                        if (roleCount > 1 && roleName !== "text") {
                            oneRole = false
                            console.log("Warning: No textRole set for ComboBox.")
                            break
                        }

                        if (oneRole) {
                            root.textRole = roleName
                            textValue = root.model.get(j)[textRole]
                        }
                    }
                }
                addMenuItem(textValue)
            }
        }
    }
}
