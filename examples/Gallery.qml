import QtQuick 1.0
import "../components"
import "content"

Rectangle {

    width: 538 + frame.margins * 2
    height: 360 + frame.margins * 2

    Binding { target: mainWindow; property: "maximumWidth"; value: width }
    Binding { target: mainWindow; property: "maximumHeight"; value: height }

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
                onClicked: {
                    console.log("Desktop.width:", Desktop.width)
                    console.log("Desktop.height:", Desktop.height)
                }
            }
            ToolButton{
                iconSource: "images/folder_new.png"
                anchors.verticalCenter: parent.verticalCenter
            }
            ToolButton{
                iconSource: "images/folder_new.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: window1.visible = !window1.visible
            }
        }

        Window {
            id: window1
            width: 250
            height: 250

            minimumWidth: 250
            minimumHeight: 250

            x: 500
            y: 500

            Rectangle {
                color: syspal.window
                anchors.fill: parent

                Text {
                    id: closeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "This is a new Window,\npress the button below\nto close it again."
                }
                Button {
                    anchors.horizontalCenter: closeText.horizontalCenter
                    anchors.top: closeText.bottom
                    anchors.margins: frame.margins
                    id: closeWindowButton
                    text:"Close"
                    width: 98
                    focus: true
                    Component.onCompleted: button1.forceActiveFocus()
                    tooltip:"Press me, to close this window again"
                    defaultbutton:true
                    onClicked: window1.visible = false
                }
                Button {
                    anchors.horizontalCenter: closeText.horizontalCenter
                    anchors.top: closeWindowButton.bottom
                    id: maximizeWindowButton
                    text:"Maximize"
                    width: 98
                    focus: true
                    tooltip:"Press me, to maximize this window again"
                    onClicked: window1.windowState = Qt.WindowMaximized;
                }
                Button {
                    anchors.horizontalCenter: closeText.horizontalCenter
                    anchors.top: maximizeWindowButton.bottom
                    id: normalizeWindowButton
                    text:"Normalize"
                    width: 98
                    focus: true
                    tooltip:"Press me, to normalize this window again"
                    onClicked: window1.windowState = Qt.WindowNoState;
                }
                Button {
                    anchors.horizontalCenter: closeText.horizontalCenter
                    anchors.top: normalizeWindowButton.bottom
                    id: minimizeWindowButton
                    text:"Minimize"
                    width: 98
                    focus: true
                    tooltip:"Press me, to minimize this window again"
                    onClicked: window1.windowState = Qt.WindowMinimized;
                }
            }

            onWindowStateChanged: console.log("new WindowState:", window1.windowState);
        }

        ContextMenu {
            id: editmenu
            MenuItem { text: "Copy" }
            MenuItem { text: "Cut" }
            MenuItem { text: "Paste" }
        }
        MouseArea {
            anchors.fill:  parent
            acceptedButtons: Qt.RightButton
            onPressed: editmenu.showPopup(mouseX, mouseY)
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
        position: tabPositionGroup.checkedButton == r2 ? "South" : "North"
        tabbar: TabBar{parent: frame; focus:true; KeyNavigation.tab:button1}

        property int margins : styleitem.style == "mac" ? 16 : 0
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
            id:mytab
            title: "Itemviews"
            ModelView {
                anchors.fill: parent
                anchors.margins: 6
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
                                text: "Fade on hover"
                            }
                            CheckBox {
                                id: scale
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
