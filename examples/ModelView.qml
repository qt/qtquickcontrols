import QtQuick 1.0
import "../components"
import "../components/plugin"

Item {
    id: root
    width: 600
    height: 300

    XmlListModel {
        id: flickerModel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + "Cat"
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imagesource"; query: "media:thumbnail/@url/string()" }
        XmlRole { name: "credit"; query: "media:credit/string()" }
    }

    ListModel {
        id: dummyModel
        Component.onCompleted: {
            for (var i = 0 ; i < 40 ; ++i) {
                append({"title": "A title " + i, "imagesource" :"http://someurl.com", "credit" : "N/A"})
            }
        }
    }

    TableView{
        model: dummyModel
        anchors.fill: parent

        TableColumn {
            property: "title"
            caption: "Title"
            width: 120
        }
        TableColumn {
            property: "credit"
            caption: "Credit"
            width: 120
        }
        TableColumn {
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
                text: itemValue
                anchors.centerIn:parent
                color:"#ccc"
            }
        }

        rowDelegate: Rectangle {
            color: itemSelected ? "#888" : (itemAlternateBackground ? "#ccc" : "#ddd")
            clip: true
            Rectangle{
                width: parent.width
                height:1
                anchors.bottom: parent.bottom
                color: "#aaa"
            }
        }

        */
    }

    /*    TableView{

        HeaderSection {
            property: "title"
            caption: "Title"
            width: 100
        }
        HeaderSection {
            property: "imagesource"
            caption: "Image source"
            width: 400
            visible: true
        }
        HeaderSection {
            property: "filename"
            caption:"File Name"
            width: 100
        }

        model: flickerModel
        width: root.width
        height: root.height/2 - 10

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
                anchors.fill: parent
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

    }
    XmlListModel {
        id: twitterModel
        property string from : ""
        property string to : ""
        property string phrase : "obama"
        source: (from=="" && to=="" && phrase=="") ? "" :
            'http://search.twitter.com/search.atom?&rpp=500&phrase='+phrase
        namespaceDeclarations: "declare default element namespace 'http://www.w3.org/2005/Atom'; " +
                               "declare namespace twitter=\"http://api.twitter.com/\";";
        query: "/feed/entry"
        XmlRole { name: "filename"; query: "content/string()" }
        XmlRole { name: "statusText"; query: "content/string()" }
        XmlRole { name: "title"; query: "published/string()" }
        XmlRole { name: "imagesource"; query: "twitter:source/string()" }
    }

        */
}
