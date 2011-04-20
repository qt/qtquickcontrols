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
        contentHeight: tree.contentHeight

        Item {
            id: content
            width: root.width-20
            height: tree.height + header.height
            ListModel {
                id: headermodel
                ListElement{
                    width:200
                    label: "Title"
                }
                ListElement{
                    width: 100
                    label: "ImageSource"
                }
                ListElement{
                    width: 280
                    label: "Filename"
                }
            }

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
                QStyleItem { id: styleitem ; elementType: "header" }
                onHeightChanged: print(height)
                height: Math.max(16, styleitem.sizeFromContents(text.font.pixelSize, text.font.pixelSize).height)

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

                XmlListModel {
                    id: flickrmodel
                    source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + "cat"
                    query: "/rss/channel/item"
                    namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
                    XmlRole { name: "Title"; query: "title/string()" }
                    XmlRole { name: "ImageSource"; query: "media:thumbnail/@url/string()" }
                    XmlRole { name: "Filename"; query: "link/string()" }
                }

                model: flickrmodel
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
                                text: flickrmodel.get(rowIndex)[varname];
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
