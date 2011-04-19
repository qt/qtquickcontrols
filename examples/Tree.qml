import QtQuick 1.0
import "../components"
import "../components/plugin"

Item {
    id: root
    width: 600
    height: 300

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
                    width: 100
                    label: "Size"
                }
                ListElement{
                    width: 280
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
                height: 22
                property int sortColumn: -1

                model: headermodel

                delegate: QStyleItem {
                    clip: true
                    elementType: "header"
                    raised: true
                    sunken: hoverarea.pressed
                    hover: hoverarea.containsMouse
                    activeControl: model.index == header.sortColumn ? "sort" : ""
                    height: parent.height
                    width: model.width
                    text: model.label

                    MouseArea{
                        id: hoverarea
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            if (index == 1)
                                filemodel.sortField = 3
                            else filemodel.sortField = 1
                            header.sortColumn = index
                        }
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
                            cursor: "splithcursor"
                        }
                    }
                }
            }

            ListView {
                id: tree
                interactive: false
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: header.bottom
                height: 300

                FileSystemModel {
                    id: filemodel
                    folder: "file://c:"
                }

                model: filemodel
                delegate: QStyleItem {
                    elementType: "itemrow"
                    width: parent.width
                    height: 20
                    activeControl: index%2 == 0 ? "alternate" : ""
                    Row {
                        Item {width:6; height:6}
                        Text { clip:true; text: fileName; width: headermodel.get(0).width}
                        Text { clip:true; text: fileSize; width: headermodel.get(1).width }
                        Text { clip:true; text: filePath; width: headermodel.get(2).width }
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
