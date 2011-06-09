import QtQuick 1.0
import "../components/plugin"

MenuBase {
    property ListModel model
    property string selectedText: model ? model.get(selectedIndex).text : ""

    // 'highlightedText' is the text that is highlighted as the mouse hovers the menu:
    property string highlightedText: model ? model.get(highlightedIndex).text: ""

    // 'centerSelectedText' means that the menu will be positioned
    //  so that the selected text' top left corner will be at x, y.
    property bool centerSelectedText: true

    // Show, or hide, the popup by setting the 'visible' property:
    visible: false
    onMenuClosed: visible = false

    onVisibleChanged: {
        if (visible) {
            var globalPos = parent.mapToItem(null, x, y)
            showPopup(globalPos.x, globalPos.y, centerSelectedText ? selectedIndex : 0)
        } else {
            closePopup()
        }
    }

    onModelChanged: {
        clearMenuItems();
        for (var i=0; i<model.count; ++i)
            addMenuItem(model.get(i).text)
    }
}
