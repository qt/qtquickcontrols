import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 530 + frame.margins*2
    height: 345 + frame.margins*2

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
        CheckBox{
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

    gradient: Gradient{
        GradientStop{ position: 0   ; color: syspal.window }
        GradientStop{ position: 0.6 ; color: syspal.window }
        GradientStop{ position: 1   ; color: Qt.darker(syspal.window, 1.1) }
    }

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
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ";

    TabFrame {
        id:frame
        property int margins : styleitem.style == "mac" ? 16 : 0
        position: tabPositionGroup.checkedButton == r2 ? "South" : "North"
        tabbar: TabBar{parent: frame}
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: margins
        Tab {
            title: "Widgets"
            ScrollArea{
                id: flickable
                clip: true
                anchors.fill: parent
                frame: false
                enabled: enabledCheck.checked
                Row {
                    id: contentRow
                    anchors.margins: 18
                    spacing: 12
                    anchors.fill: parent
                    Column {
                        spacing: 6
                        SequentialAnimation on x {
                            running: animateCheck.checked
                            NumberAnimation { from:0 ; to: -flickable.width; easing.type:Easing.OutSine; duration:1000}
                            PauseAnimation { duration: 1000 }
                            NumberAnimation { from:-flickable.width; to:0; easing.type:Easing.OutSine; duration:1000}
                            alwaysRunToEnd: true
                            loops: Animation.Infinite
                        }

                        Row {
                            spacing:4
                            Button {
                                id: button1
                                text:"Button 1"
                                width: 98
                                focus: true
                                Component.onCompleted: button1.forceActiveFocus()
				tooltip:"This is an interesting tool tip"                                
                                defaultbutton:true
                                KeyNavigation.tab: button2
                                KeyNavigation.backtab: button1
                            }
                            Button {
                                id:button2
                                text:"Button 2"
                                focus:true
                                width:98
                                KeyNavigation.tab: combo
                                KeyNavigation.backtab: button2
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
                            spacing: 6
                            SpinBox {
                                id: t1
                                width: 97
                                KeyNavigation.tab: t2
                                KeyNavigation.backtab: combo
                            }
                            SpinBox {
                                id: t2
                                width:97
                                KeyNavigation.tab: t3
                                KeyNavigation.backtab: t2
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
                            id:slider
                            value:50
                            KeyNavigation.tab: frameCheckbox
                            KeyNavigation.backtab: t3
                        }
                        smooth:true
                    }
                    Column {
                        id: rightcol
                        spacing: 24
                        GroupBox{
                            id: group1
                            text: "CheckBox"
                            Row {
                                spacing: 6
                                anchors.fill: parent
                                CheckBox {
                                    id: frameCheckbox
                                    text: "Text frame"
                                    checked: true
                                    KeyNavigation.tab: animateCheck
                                    KeyNavigation.backtab: slider
                                }
                                CheckBox {
                                    id: animateCheck
                                    text: "Animated"
                                    checked: false
                                    KeyNavigation.tab: r1
                                    KeyNavigation.backtab: frameCheckbox
                                }
                            }
                            RotationAnimation on rotation {
                                from:0; to:360;
                                easing.type:Easing.OutCubic; duration:1000;
                                running: animateCheck.checked
                                alwaysRunToEnd: true
                                loops: Animation.Infinite
                            }
                        }
                        GroupBox {
                            id: group2
                            text:"Tab Position"
                            ButtonRow {
                                id: tabPositionGroup
                                RadioButton {
                                    id: r1
                                    text: "North"
                                    KeyNavigation.tab: r2
                                    KeyNavigation.backtab: r2
                                    checked: true
                                }
                                RadioButton {
                                    id: r2
                                    text: "South"
                                    KeyNavigation.tab: area
                                    KeyNavigation.backtab: r1
                                }
                            }
                            RotationAnimation on rotation {
                                from:0; to:360
                                easing.type: Easing.OutCubic
                                duration: 1000
                                running: animateCheck.checked
                                alwaysRunToEnd: true
                                loops: Animation.Infinite
                            }
                        }
                        TextScrollArea {
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
            title: "Sliders"
            Row {
                anchors.fill: parent
                anchors.margins:16
                spacing:12
                Slider {
                    value:50
                    orientation:Qt.Vertical
                }
                Slider {
                    value: 50
                    tickmarksEnabled: false
                    orientation: Qt.Vertical
                }

                Column {
                    anchors.verticalCenter:parent.verticalCenter
                    anchors.margins:16
                    spacing:12
                    Slider {
                        value:50
                    }
                    Slider {
                        id : slider1
                        value: 50
                        tickmarksEnabled: false
                    }
                    Slider {
                        value: 50
                        tickmarksEnabled: true
                        scale:-1
                    }
                    Slider {
                        value: 50
                        tickmarksEnabled: false
                        scale:-1
                    }
                }
            }
        }
        Tab {
            title: "Progress"
            Row {
                anchors.fill:parent
                anchors.margins:20
                spacing:20
                Column {
                    anchors.margins: 20
                    spacing: 20
                    ProgressBar {
                        value: 0.0
                    }
                    ProgressBar {
                        value:0.5
                    }
                    ProgressBar {
                        value:1
                    }
                    ProgressBar {
                        indeterminate: true
                    }
                }
                ProgressBar {
                    value: 0.0
                    orientation: Qt.Vertical
                }
                ProgressBar {
                    value: 0.5
                    orientation: Qt.Vertical
                }
                ProgressBar {
                    value: 1
                    orientation: Qt.Vertical
                }
                ProgressBar {
                    orientation: Qt.Vertical
                    indeterminate: true
                }
            }

        }
        Tab {
            title: "Dials"
            Row {
                anchors.fill: parent
                anchors.margins:16
                spacing:12
                Dial{id: dial1; KeyNavigation.tab:dial2; scale:1.2}
                Dial{id: dial2; scale: 1; KeyNavigation.tab:dial3}
                Dial{
                    id: dial3;
                    KeyNavigation.tab:dial1
                    scale: 0.8
                }
            }
        }

    }
}
