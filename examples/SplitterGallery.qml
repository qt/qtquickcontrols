import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 800
    height: 600

    SplitterRow {
        id: sr
        anchors.fill: parent

        Rectangle {
            property bool expanding: true
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
        }
    }
}
