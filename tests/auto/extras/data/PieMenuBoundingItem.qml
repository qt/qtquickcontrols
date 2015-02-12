import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Extras 1.3

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    property alias mouseArea: area

    property alias pieMenu: menu

    readonly property int margins: 50
    readonly property int boundingItemTopMargin: 100

    Rectangle {
        id: canvasContainer
        anchors.fill: parent
        anchors.topMargin: boundingItemTopMargin

        Rectangle {
            id: rect
            anchors.fill: parent
            anchors.margins: margins
            border.color: "black"

            MouseArea {
                id: area
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onClicked: menu.popup(mouseX, mouseY)
            }

            PieMenu {
                id: menu
                boundingItem: canvasContainer

                MenuItem {
                    text: "Action 1"
                }
                MenuItem {
                    text: "Action 2"
                }
                MenuItem {
                    text: "Action 3"
                }
            }
        }
    }
}
