import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 800
    height: 600

    Rectangle {
        color: "white"
        width: 800
        height: 600

    SplitterRow {
        id: sr
        anchors.fill: parent
        width: 800

        Rectangle {
            property bool expanding: false
            property real minimumWidth: 100
            color: "gray"
            width: 200
            Button {
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false
            }
        }
        Rectangle {
            property real minimumWidth: 100
            property bool expanding: false
            color: "darkgray"
            width: 200
            Button {
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false

            }
            Rectangle {
                color: "red"
                width: parent.minimumWidth
                height: 50
                y: 100
            }
        }
        Rectangle {
            property bool expanding: false
            property real minimumWidth: 100
            color: "gray"
            width: 200
            Button {
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false
            }
            Rectangle {
                color: "red"
                width: parent.minimumWidth
                height: 50
                y: 100
            }
        }
        Rectangle {
            property bool expanding: false
            property real minimumWidth: 100
            color: "gray"
            width: 200
            Button {
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false
            }
            Rectangle {
                color: "red"
                width: parent.minimumWidth
                height: 50
                y: 100
            }
        }
    }
    }
}
