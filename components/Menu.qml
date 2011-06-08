import QtQuick 1.0
import "../components/plugin"

MenuBase {
    property ListModel model
    property string selectedText: model ? model.get(selectedIndex).text : ""
    property string highlightedText: model ? model.get(highlightedIndex).text: ""
    property bool centerOnSelectedText: true
    visible: false
    onMenuClosed: visible = false

    onVisibleChanged: {
        if (visible) {
            var globalPos = parent.mapToItem(null, x, y)
            showPopup(globalPos.x, globalPos.y, centerOnSelectedText ? selectedIndex : 0)
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
