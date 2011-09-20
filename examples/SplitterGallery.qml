import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    width: 800
    height: 500
    color: syspal.window
    SystemPalette{id:syspal}
    SplitterRow {
        id: sr
        anchors.fill: parent

        Item {
            id: r1
            property real minimumWidth: 140
            property bool expanding: false
            onExpandingChanged: be2.checked = !expanding
            width: 200
            CheckBox {
                id: be1
                anchors.centerIn: parent
                checked: parent.expanding
                text: "Set expanding"
                onClicked: parent.expanding = true
            }
        }
        Item {
            id: r2
            property real minimumWidth: 140
            property bool expanding: true
            onExpandingChanged: be1.checked = !expanding
            width: 200
            CheckBox {
                id: be2
                anchors.centerIn: parent
                text: "Set expanding"
                checked: true
                onClicked: parent.expanding = true
            }
        }
        Item {
            id: r3
            property bool expanding: false
            property real minimumWidth: 140
            width: 200
            SplitterColumn {
                id: sc
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Item {
                    id: cr1
                    property real percentageHeight: 50
                }
                Item {
                    id: cr2
                    height: 200
                }
            }
        }
    }
}
