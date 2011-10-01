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
        SplitterItem {
            id: r1
            minimumWidth: 140
            expanding: false
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
        SplitterItem {
            id: r2
            minimumWidth: 140
            expanding: true
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
        SplitterItem {
            id: r3
            expanding: false
            minimumWidth: 140
            width: 200
            SplitterColumn {
                id: sc
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                SplitterItem {
                    id: cr1
                    height:200
                }
                SplitterItem {
                    id: cr2
                    height: 200
                }
            }
        }
    }
}
