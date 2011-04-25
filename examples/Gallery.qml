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
        Row {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            ToolButton{
                iconSource: "images/folder_new.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            ToolButton{
                iconSource: "images/folder_new.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            ToolButton{
                iconSource: "images/folder_new.png"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

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
    ListModel {
        id: choices
        ListElement { text: "Banana" }
        ListElement { text: "Orange" }
        ListElement { text: "Apple" }
        ListElement { text: "Coconut" }
    }

    property string loremIpsum:
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. ";

    TabFrame {
        id:frame
        focus:true
        property int margins : styleitem.style == "mac" ? 16 : 0
        position: tabPositionGroup.checkedButton == r2 ? "South" : "North"
        tabbar: TabBar{parent: frame; focus:true; KeyNavigation.tab:button1}
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: margins

        Tab {
            title: "Widgets"
            Item {
                id: flickable
                anchors.fill: parent
                enabled: enabledCheck.checked

                Row {
                    id: contentRow
                    anchors.fill:parent
                    anchors.margins: 8
                    spacing: 16
                    Column {
                        spacing: 9
                        Row {
                            spacing:8
                            Button {
                                id: button1
                                text:"Button 1"
                                width: 98
                                focus: true
                                Component.onCompleted: button1.forceActiveFocus()
                                tooltip:"This is an interesting tool tip"
                                defaultbutton:true
                                KeyNavigation.tab: button2
                                KeyNavigation.backtab: frame.tabbar
                            }
                            Button {
                                id:button2
                                text:"Button 2"
                                focus:true
                                width:98
                                KeyNavigation.tab: combo
                                KeyNavigation.backtab: button1
                            }
                        }
                        ChoiceList {
                            id: combo;
                            model: choices;
                            width: 200;
                            focus: false;
                            KeyNavigation.tab: t1
                            KeyNavigation.backtab: button2
                        }
                        Row {
                            spacing: 8
                            SpinBox {
                                id: t1
                                width: 97

                                minimumValue: -50
                                value: -20

                                KeyNavigation.tab: t2
                                KeyNavigation.backtab: combo
                            }
                            SpinBox {
                                id: t2
                                width:97
                                KeyNavigation.tab: t3
                                KeyNavigation.backtab: t1
                            }
                        }
                        TextField {
                            id: t3
                            text: "TextField"
                            KeyNavigation.tab: slider
                            KeyNavigation.backtab: t2
                        }
                        ProgressBar {
                            // normalize value [0.0 .. 1.0]
                            value: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
                        }
                        ProgressBar {
                            indeterminate: true
                        }
                        Slider {
                            id: slider
                            value: 0.5
                            tickmarksEnabled: tickmarkCheck.checked
                            KeyNavigation.tab: frameCheckbox
                            KeyNavigation.backtab: t3
                        }
                        smooth:true
                    }
                    Column {
                        id: rightcol
                        spacing: 12
                        GroupBox{
                            id: group1
                            title: "CheckBox"
                            width: area.width
                            ButtonRow {
                                exclusive: false
                                CheckBox {
                                    id: frameCheckbox
                                    text: "Text frame"
                                    checked: true
                                    KeyNavigation.tab: tickmarkCheck
                                    KeyNavigation.backtab: slider
                                }
                                CheckBox {
                                    id: tickmarkCheck
                                    text: "Tickmarks"
                                    checked: true
                                    KeyNavigation.tab: r1
                                    KeyNavigation.backtab: frameCheckbox
                                }
                            }
                        }
                        GroupBox {
                            id: group2
                            title:"Tab Position"
                            width: area.width
                            ButtonRow {
                                id: tabPositionGroup
                                RadioButton {
                                    id: r1
                                    text: "North"
                                    KeyNavigation.tab: r2
                                    KeyNavigation.backtab: tickmarkCheck
                                    checked: true
                                }
                                RadioButton {
                                    id: r2
                                    text: "South"
                                    KeyNavigation.tab: area
                                    KeyNavigation.backtab: r1
                                }
                            }
                        }

                        TextArea {
                            id: area
                            frame: frameCheckbox.checked
                            text: loremIpsum + loremIpsum
                            KeyNavigation.tab: button1
                        }
                    }
                }
            }
        }
        Tab {
            title: "Itemviews"
            TableView{
                frame: true
                anchors.margins: 4
                anchors.fill: parent

                headermodel: ListModel {
                    ListElement{ property: "title" ; caption: "Title" ; width: 100}
                    ListElement{ property: "imagesource" ; caption: "Image Source" ; width: 200}
                    ListElement{ property: "filename" ; caption: "File Name" ; width: 200}
                }
                model: XmlListModel {
                    source: "http://api.flickr.com/services/feeds/photos_public.gne?format=rss2&tags=" + "Qt"
                    query: "/rss/channel/item"
                    namespaceDeclarations: "declare namespace media=\"http://search.yahoo.com/mrss/\";"
                    XmlRole { name: "title"; query: "title/string()" }
                    XmlRole { name: "imagesource"; query: "media:thumbnail/@url/string()" }
                    XmlRole { name: "filename"; query: "link/string()" }
                }
            }
        }

        Tab {
            title: "Range"
            Row {
                anchors.fill: parent
                anchors.margins:16
                spacing:16

                Column {
                    spacing:12

                    GroupBox {
                        title: "Animation options"
                        ButtonRow {
                            exclusive: false
                            CheckBox {
                                id:fade
                                width:120
                                text: "Fade on hover"
                            }
                            CheckBox {
                                id: scale
                                width:120
                                text: "Scale on hover"
                            }
                        }
                    }
                    Row {
                        spacing: 20
                        Column {
                            spacing: 10
                            Button {
                                width:200
                                text: "Push button"
                                scale: scale.checked && containsMouse ? 1.1 : 1
                                opacity: !fade.checked || containsMouse ? 1 : 0.5
                                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                            }
                            Slider {
                                value: 0.5
                                scale: scale.checked && containsMouse ? 1.1 : 1
                                opacity: !fade.checked || containsMouse ? 1 : 0.5
                                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                            }
                            Slider {
                                id : slider1
                                value: 50
                                tickmarksEnabled: false
                                scale: scale.checked && containsMouse ? 1.1 : 1
                                opacity: !fade.checked || containsMouse ? 1 : 0.5
                                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                            }
                            ProgressBar {
                                value: 0.5
                                scale: scale.checked && containsMouse ? 1.1 : 1
                                opacity: !fade.checked || containsMouse ? 1 : 0.5
                                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                            }
                            ProgressBar {
                                indeterminate: true
                                scale: scale.checked && containsMouse ? 1.1 : 1
                                opacity: !fade.checked || containsMouse ? 1 : 0.5
                                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                            }
                        }
                        Dial{
                            width: 120
                            height: 120
                            scale: scale.checked && containsMouse ? 1.1 : 1
                            opacity: !fade.checked || containsMouse ? 1 : 0.5
                            Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                            Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                        }
                    }
                }
            }
        }
        Tab {
            title: "Sidebar"
            Panel {
                anchors.fill:parent
            }
        }
    }
}
