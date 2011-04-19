import QtQuick 1.0
import "../components"
import "../components/plugin"

Item {
    id: root
    width:600
    height:300

    ScrollArea {
        id: scrollarea
        anchors.fill: parent

        Item {
            id: content
            width: 580
            height: tree.height + header.height
            ListModel {
                id: headermodel
                ListElement{
                    width:200
                    label: "Filename"
                }
                ListElement{
                    width:200
                    label: "Path"
                }
            }

            ListView {
                id: header
                interactive:false
                anchors.left:parent.left
                anchors.top:parent.top
                orientation: ListView.Horizontal
                width: parent.width
                height: 20
                model: headermodel
                delegate: QStyleItem {
                    clip: true
                    elementType: "header"
                    height: parent.height
                    width: (index != 0) ? 500: model.width
                    Text {
                        anchors.verticalCenter:parent.verticalCenter
                        anchors.left:parent.left
                        anchors.leftMargin:4
                        text: label
                    }
                    MouseArea{
                        property int offset:0
                        anchors.rightMargin: -width/2
                        width: 16 ; height: parent.height
                        anchors.right: parent.right
                        onPositionChanged:  {
                            headermodel.setProperty(index, "width",model.width + (mouseX - offset))}
                        onPressedChanged: if(pressed)offset=mouseX
                        QStyleItem {
                            anchors.fill:parent
                            cursor:"splithcursor"
                        }
                    }
                }
            }

            ListView {
                id: tree
                interactive: false
                anchors.left:parent.left
                anchors.right:parent.right
                anchors.top: header.bottom
                height:300

                FileSystemModel {
                    id: filemodel
                    folder: "file://c:"
                }

                model: filemodel

                delegate: QStyleItem {
                    elementType: "item"
                    width:parent.width
                    height:20
                    activeControl: index%2 == 0 ? "alternate" : ""
                    Row {
                        Item {width:6; height:6}
                        Text { clip:true; text: fileName; width: headermodel.get(0).width}
                        Text { clip:true; text: filePath; width: headermodel.get(1).width }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: filemodel.folder = filePath
                    }
                }
            }
        }
    }
}
