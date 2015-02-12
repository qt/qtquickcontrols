import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Extras 1.3

Rectangle {
    id: rect
    anchors.fill: parent

    signal actionTriggered(int index)

    property alias mouseArea: area

    MouseArea {
        id: area
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: pieMenu.popup(mouseX, mouseY);
    }

    property alias pieMenu: menu

    PieMenu {
        id: menu
        width: 200
        height: 200

        MenuItem {
            text: "Action 1"
            onTriggered: {
                menu.visible = true;
                actionTriggered(0);
            }
        }
        MenuItem {
            text: "Action 2"
            onTriggered: {
                menu.visible = true;
                actionTriggered(1);
            }
        }
        MenuItem {
            text: "Action 3"
            onTriggered: {
                menu.visible = true;
                actionTriggered(2);
            }
        }
    }
    Rectangle {
        anchors.fill: menu
        color: "transparent"
        border.color: "black"
    }
}
