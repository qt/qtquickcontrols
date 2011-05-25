import QtQuick 1.0
import "../components/plugin"

MenuBase {
    property ListModel model
    function show(x, y) {
        // Clear and add items from the model (showPopup adds the MenuItem children)
        clearMenuItems();

        for (var i = 0; i < model.count; ++i) {
            addMenuItem(model.get(i).text)
        }

        showPopup(x, y)
    }
}
