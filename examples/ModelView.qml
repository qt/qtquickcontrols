import QtQuick 2.0
import "../components"
import "../components/plugin"

Item {
    id: root
    width: 600
    height: 300

    XmlListModel {
        id: flickerModel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + "Qt"
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imagesource"; query: "media:thumbnail/@url/string()" }
        XmlRole { name: "credit"; query: "media:credit/string()" }
    }

    TableView{
        model: flickerModel
        anchors.fill: parent

        HeaderSection {
            property: "title"
            caption: "Title"
            width: 120
        }
        HeaderSection {
            property: "credit"
            caption: "Credit"
            width: 120
        }
        HeaderSection {
            property: "imagesource"
            caption: "Image source"
            width: 200
            visible: true
        }
        /*
        headerDelegate: Rectangle {
            color: "#555"
            Rectangle {
                width: 1
                height: parent.height
                color: "#444"
            }
            Text {
                text: itemvalue
                anchors.centerIn:parent
                color:"#ccc"
            }
        }
        rowDelegate: Rectangle {
            color: itemselected ? "#888" : (alternaterow ? "#ccc" : "#ddd")
            clip: true
            Rectangle{
                width: parent.width
                height:1
                anchors.bottom: parent.bottom
                color: "#aaa"
            }
        }
        itemDelegate: Item {
            width: itemwidth
            height: itemheight
            clip: true
            Text {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 5
                elide: Qt.ElideRight
                text: itemvalue
                color: itemselected ? "white" : "black"
            }
            Rectangle {
                width: 1
                height: parent.height
                color: "#aaa"
            }

        }
        */
    }
}
