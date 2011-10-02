import QtQuick 1.0
import QtDesktop 0.1

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
            for (var i = 0 ; i < 4000 ; ++i) {
                append({"title": "A title " + i, "imagesource" :"http://someurl.com", "credit" : "N/A"})
            }
        }
    }

    TableView{
        model: dummyModel
        anchors.fill: parent

        TableColumn {
            role: "title"
            title: "Title"
            width: 120
        }
        TableColumn {
            role: "credit"
            title: "Credit"
            width: 120
        }
        TableColumn {
            role: "imagesource"
            title: "Image source"
            width: 200
            visible: true
        }
    }
}
