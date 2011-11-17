import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    width: 540
    height: 340
    color: "green"
    id : rect

    Text {
        id : selctedLabel
        anchors.centerIn: parent
        text : editMenu.selected
    }

    ContextMenu {
        id : editMenu

        // MenuItem API:
        MenuItem {
            text : "blue"
            //onSelected : { rect.color = "blue" }
        }
        MenuItem {
            text : "red"
            //onSelected : { rect.color = "red" }
        }
        MenuItem {
            text : "pink"
            //onSelected : { rect.color = "pink" }
        }

        // ListModel API:
        // # no way to do onSelected.
        model: ListModel {
            id: menu
            ListElement { text: "Elememt1" }
            ListElement { text: "Elememt2" }
            ListElement { text: "Elememt2" }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons : Qt.RightButton
        onClicked: editMenu.showPopup(mouseX, mouseY)
    }
}
