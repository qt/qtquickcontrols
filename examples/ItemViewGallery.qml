import QtQuick 1.0
import "../components"

Rectangle {

    width: 538 + frame.margins * 2
    height: 360 + frame.margins * 2

    ToolBar{
        id: toolbar
        width: parent.width
        height: 40

        MouseArea {
            anchors.fill:  parent
            acceptedButtons: Qt.RightButton
            onPressed: editmenu.show(mouseX, mouseY)
        }

        ChoiceList {
            id: delegateChooser
            enabled: frame.current == 3 ? 1 : 0
            model: delegatemenu
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
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
            for (var i=0 ; i< 80 ; ++i)
                largeModel.append({"name":"Person "+i , "age": Math.round(Math.random()*100), "sex": Math.random()>0.5 ? "Male" : "Female"})
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
            tabbar: TabBar{parent: frame}

            property int margins : styleitem.style == "mac" ? 16 : 0
            height:parent.height - 34
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: margins

            Tab {
                title: "XmlListModel"


                TableView {

                    model: flickerModel
                    anchors.fill: parent
                    anchors.margins: 12

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


                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked

                }
            }
            Tab {
                title: "ListModel"

                TableView{
                    model: listModel
                    anchors.fill: parent
                    anchors.margins: 12
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

                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked
                }
            }
            Tab {
                title: "LargeModel"

                TableView {
                    model: largeModel
                    anchors.margins: 12
                    anchors.fill: parent

                    TableColumn {
                        property: "name"
                        caption: "Name"
                        width: 120
                    }
                    TableColumn {
                        property: "age"
                        caption: "Age"
                        width: 120
                    }

                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked
                }
            }

            Tab {
                title: "Custom delegate"

                ListModel {
                    id: delegatemenu
                    ListElement { text: "Gray" }
                    ListElement { text: "hover" }
                    ListElement { text: "Apple" }
                    ListElement { text: "Coconut" }
                }


                Component {
                    id: delegate1
                    Item {
                        clip: true
                        Text {
                            width: parent.width
                            anchors.margins: 4
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            elide: itemElideMode
                            text: itemValue ? itemValue : ""
                            color: itemForeground
                        }
                    }
                }

                Component {
                    id: delegate2
                    Item {
                        height: itemSelected? 60 : 20
                        Behavior on height{ NumberAnimation{}}
                        Text {
                            width: parent.width
                            anchors.margins: 4
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            elide: itemElideMode
                            text: itemValue ? itemValue : ""
                            color: itemForeground
                        }
                    }
                }

                Component {
                    id: delegate3
                    Item {
                        Text {
                            width: parent.width
                            anchors.margins: 4
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            elide: itemElideMode
                            text: itemValue ? itemValue : ""
                            color: itemForeground
                            visible: columnIndex == 0
                        }
                        TextInput{
                            color:"#333"
                            anchors.fill: parent
                            anchors.margins: 4
                            visible: columnIndex == 1
                        }
                    }
                }
                TableView {
                    model: largeModel
                    anchors.margins: 12
                    anchors.fill:parent
                    frame: frameCheckbox.checked
                    headerVisible: headerCheckbox.checked
                    sortIndicatorVisible: sortableCheckbox.checked
                    alternateRowColor: alternateCheckbox.checked

                    TableColumn {
                        property: "name"
                        caption: "Name"
                        width: 120
                    }
                    TableColumn {
                        property: "age"
                        caption: "Age"
                        width: 120
                    }
                    TableColumn {
                        property: "sex"
                        caption: "Sex"
                        width: 120
                    }

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

                    itemDelegate: {
                        switch(delegateChooser.currentIndex) {
                        case 0:
                            return delegate1
                        case 1:
                            return delegate2
                        case 2:
                            return delegate3
                        }
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
