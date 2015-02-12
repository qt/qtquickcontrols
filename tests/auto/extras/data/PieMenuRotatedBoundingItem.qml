import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Extras 1.3

Rectangle {
    id: root
    anchors.fill: parent

    signal actionTriggered(int index)

    property alias mouseArea: area

    property alias pieMenu: menu

    readonly property int margins: 50

    Rectangle {
        id: rect
        rotation: 90
        anchors.fill: parent
        anchors.margins: root.margins
        border.color: "black"

        MouseArea {
            id: area
            anchors.fill: parent
            acceptedButtons: Qt.RightButton
            onClicked: menu.popup(mouseX, mouseY)
        }

        PieMenu {
            id: menu
            boundingItem: root

            MenuItem {
                text: "Action 1"
                onTriggered: actionTriggered(0)
            }
            MenuItem {
                text: "Action 2"
                onTriggered: actionTriggered(1)
            }
            MenuItem {
                text: "Action 3"
                onTriggered: actionTriggered(2)
            }
        }
    }
}
