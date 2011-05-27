import QtQuick 1.0
import "../components/plugin"

MenuBase {
    property ListModel model
    property Item target
    property bool visible: false
    property real x: 0
    property real y: 0

    onVisibleChanged: visible ? show() : closePopup()
    onMenuClosed: visible = false

    function show() {
        // Clear and add items from the model (showPopup adds the MenuItem children)
        clearMenuItems();

        for (var i = 0; i < model.count; ++i) {
            addMenuItem(model.get(i).text)
        }

        var globalPos = target.mapToItem(null, x, y)
        showPopup(globalPos.x, globalPos.y, 0)
    }
}
