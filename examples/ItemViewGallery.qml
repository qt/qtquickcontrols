import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {

    width: 538 + frame.margins * 2
    height: 360 + frame.margins * 2

    ToolBar{
        id: toolbar
        width: parent.width
        height: 40

        ContextMenu {
            id: editmenu
            model: ListModel {
                id: menu
                ListElement { text: "Copy" }
                ListElement { text: "Cut" }
                ListElement { text: "Paste" }
            }
        }
        MouseArea {
            anchors.fill:  parent
            acceptedButtons: Qt.RightButton
            onPressed: editmenu.show(mouseX, mouseY)
        }

        CheckBox {
            id: enabledCheck
            text: "Enabled"
            checked: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    SystemPalette {id: syspal}
    QStyleItem{ id: styleitem}
    color: syspal.window

    XmlListModel {
        id: flickerModel
        source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + "Qt"
        query: "/rss/channel/item"
        namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
        XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "imagesource"; query: "media:thumbnail/@url/string()" }
        XmlRole { name: "credit"; query: "media:credit/string()" }
    }

    ListModel {
        id: listModel
        ListElement{
            title: "Some title"
            imageSource: "imagesource"
            credit: "credit"
        }
        ListElement{
            title: "Some title 2"
            imageSource: "imagesource"
            credit: "credit"
        }
        ListElement{
            title: "Some title 3"
            imageSource: "imagesource"
            credit: "credit"
        }
    }

    ListModel {
        id: largeModel
        Component.onCompleted: {
            for (var i=0 ; i< 100 ; ++i)
                largeModel.append({"name":"Person "+i , "age": Math.round(Math.random()*100)})
        }
    }

    Column {
        anchors.top: toolbar.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom:  parent.bottom
        anchors.margins: 8

        TabFrame {
            id:frame
            focus:true
            enabled: toolbar.enabled
            position: tabPositionGroup.checkedButton == r2 ? "South" : "North"
            tabbar: TabBar{parent: frame}

            property int margins : styleitem.style == "mac" ? 16 : 0
            anchors.top: toolbar.bottom
            height:parent.height - 34
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: margins

            Tab {
                title: "XmlListModel"
                TableView{
                    model: flickerModel
                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked
                    anchors.fill: parent
                    anchors.margins:12
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
                }
            }
            Tab {
                title: "ListModel"
                TableView{
                    model: listModel
                    anchors.fill: parent
                    anchors.margins:12
                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked
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
                }
            }
            Tab {
                title: "LargeModel"
                TableView {
                    model: largeModel
                    anchors.margins: 12
                    anchors.fill:parent
                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked
                    HeaderSection {
                        property: "name"
                        caption: "Name"
                        width: 120
                    }
                    HeaderSection {
                        property: "age"
                        caption: "Age"
                        width: 120
                    }
                }
            }
        }
        Row{
            x:12
            height: 34
            CheckBox{
                id: alternateCheckbox
                checked: true
                text: "Alternate"
                anchors.verticalCenter: parent.verticalCenter
            }
            CheckBox{
                id: sortableCheckbox
                checked: false
                text: "Sortindicator"
                anchors.verticalCenter: parent.verticalCenter
            }
            CheckBox{
                id: frameCheckbox
                checked: true
                text: "Frame"
                anchors.verticalCenter: parent.verticalCenter
            }
            CheckBox{
                id: headerCheckbox
                checked: true
                text: "Headers"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
