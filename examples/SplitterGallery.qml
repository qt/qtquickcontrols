import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    width: 800
    height: 600

    SplitterRow {
        id: sr
        anchors.fill: parent

        Rectangle {
            id: r1
            property bool expanding: false
            property real minimumWidth: 100
//            visible: false
            color: "gray"
            width: 200
            Button {
                id: be1
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false
            }
            Button {
                width: parent.width
                anchors.top: be1.bottom
                text: "Show/hide next column"
                onClicked: { r2.visible = !r2.visible; }
            }
        }
        Rectangle {
            id: r2
            property real minimumWidth: 100
            property bool expanding: false
//            visible: false
            color: "darkgray"
            width: 200
            Button {
                id: be2
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false

            }
            Button {
                width: parent.width
                anchors.top: be2.bottom
                text: "Show/hide next column"
                onClicked: { r3.visible = !r3.visible; }
            }
        }
        Rectangle {
            id: r3
//            visible: false
            property bool expanding: false
            property real minimumWidth: 100
            color: "gray"
            width: 200
            Button {
                id: be3
                width: parent.width
                text: "Set expanding"
                onClicked: parent.expanding = true
                enabled: parent.expanding === false
            }
            Button {
                width: parent.width
                anchors.top: be3.bottom
                text: "Show/hide first column"
                onClicked: { r1.visible = !r1.visible; }
            }
        }
    }
}
