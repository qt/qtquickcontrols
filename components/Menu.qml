import QtQuick 1.0
import "../components/plugin"

MenuBase {
    property ListModel model
    function show(x, y) {
        showPopup(x, y)
    }
}
