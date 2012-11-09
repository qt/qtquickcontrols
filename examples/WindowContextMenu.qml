import QtQuick 2.0
import QtDesktop 1.0
import QtQuick.Window 2.0   // overrides any definition of Window in QtDesktop

Window {
    width: 540
    height: 340
    color: "green"
    id : rect

    Text {
        id : selctedLabel
        anchors.centerIn: parent
        text : editMenu.itemTextAt(editMenu.selectedIndex)
    }

    ContextMenu {
        id : editMenu

        MenuItem {
            text : "blue"
            onTriggered: rect.color = "blue"
        }

        MenuItem {
            text : "red"
            onTriggered: rect.color = "red"
        }

        MenuItem {
            text : "pink"
            onTriggered: rect.color = "pink"
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons : Qt.RightButton
        onClicked: editMenu.showPopup(mouseX, mouseY, 0)
    }
}
