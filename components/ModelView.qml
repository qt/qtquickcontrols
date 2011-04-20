import QtQuick 1.0
import "../components"
import "../components/plugin"

Item {
    id: root

    property variant headermodel
    property variant model

    Item {
        id: content
        anchors.fill: parent
        ListView {
            id: header
            interactive:false
            anchors.left:parent.left
            anchors.top:parent.top
            orientation: ListView.Horizontal
            width: parent.width
            property int sortColumn: -1

            // Derive size fomr style
            Text{ id:text }
            QStyleItem { id: styleitem ; elementType: "header"; visible:false }
            height: Math.max(text.font.pixelSize + 2, styleitem.sizeFromContents(text.font.pixelSize, text.font.pixelSize).height)

            model: headermodel

            delegate: QStyleItem {
                clip: true
                elementType: "header"
                raised: true
                sunken: hoverarea.pressed
                hover: hoverarea.containsMouse
                activeControl: model.index == header.sortColumn ? "sort" : ""

                width: (index ==  headermodel.count - 1) ? header.width - x  : model.width
                height: parent.height
                text: model.label

                MouseArea{
                    id: hoverarea
                    hoverEnabled: true
                    anchors.fill: parent
                    /*
                        onClicked: {
                        if (index == 1)
                            filemodel.sortField = 3
                        else filemodel.sortField = 1
                        header.sortColumn = index
                    }
                    */
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

        ScrollArea {
            id: scrollarea

            frame:false
            anchors.topMargin:  header.height
            anchors.fill: parent
            contentHeight: tree.contentHeight

            ListView {
                id: tree
                interactive: false
                width:parent.width
                height:900

                model: root.model
                delegate: QStyleItem {
                    id: delegate
                    elementType: "itemrow"
                    width: parent.width
                    height: 20
                    activeControl: index%2 == 0 ? "alternate" : ""
                    property int rowIndex: model.index
                    Row {
                        Item {width:6; height:6}
                        Repeater {
                            model:headermodel.count
                            Text {
                                clip:true;
                                property string varname: headermodel.get(index).label
                                text: root.model.get(rowIndex)[varname];
                                elide :Text.ElideRight
                                width: headermodel.get(index).width
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}
