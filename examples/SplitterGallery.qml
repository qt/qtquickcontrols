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
            Splitter.minimumWidth: 140
            Splitter.expanding: false
            width: 200
            CheckBox {
                id: be1
                anchors.centerIn: parent
                checked: parent.Splitter.expanding
                text: "Set expanding"
                onClicked: {
                    parent.Splitter.expanding = true
                    be2.checked = !parent.Splitter.expanding
                }
            }
        }
        Item {
            id: r2
            Splitter.minimumWidth: 140
            Splitter.expanding: true
            width: 200
            CheckBox {
                id: be2
                anchors.centerIn: parent
                text: "Set expanding"
                checked: true
                onClicked: {
                    parent.Splitter.expanding = true
                    be1.checked = !parent.Splitter.expanding
                }
            }
        }
        Item {
            id: r3
            Splitter.expanding: false
            Splitter.minimumWidth: 140
            width: 200
            SplitterColumn {
                id: sc
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                Item {
                    id: cr1
                    height:200
                }
                Item {
                    id: cr2
                    height: 200
                }
            }
        }
    }
}
