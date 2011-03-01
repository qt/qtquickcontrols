import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 530 + frame.margins*2
    height: 345 + frame.margins*2

    ToolBar{
        id:toolbar
        width:parent.width
        height:40
        Row {
            spacing: 2
            ToolButton{iconSource: "images/folder_new.png"}
            ToolButton{iconSource: "images/folder_new.png"}
            ToolButton{iconSource: "images/folder_new.png"}
            CheckBox{
                id:enabledCheck
                text:"Enabled"
                checked:true
                anchors.verticalCenter:parent.verticalCenter
            }
            CheckBox{
                id:animateCheck
                text:"Animated"
                checked:false
                anchors.verticalCenter:parent.verticalCenter
            }
            CheckBox{
                text:"South Tab"
                id:toolBarPosition
                checked:false
                anchors.verticalCenter:parent.verticalCenter
            }
        }
    }

    SystemPalette{id:syspal}
    QStyleItem{id:styleitem}
    color:syspal.window

    gradient: Gradient{
        GradientStop{ position:0 ; color:syspal.window}
        GradientStop{ position:0.6 ; color:syspal.window}
        GradientStop{ position:1 ; color:Qt.darker(syspal.window, 1.1)}
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
        position: toolBarPosition.checked ? "South" : "North"
        tabbar: TabBar{parent:frame}
        anchors.top:toolbar.bottom
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.left:parent.left
        anchors.margins: margins
        Tab {
            title:"Widgets"
            ScrollArea{
                id:flickable
                clip:true
                anchors.fill:parent
                frame:false
                enabled:enabledCheck.checked
                Row {
                    id:contentRow
                    anchors.margins: 18
                    spacing: 12
                    anchors.fill: parent
                    Column {
                        spacing:6
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
                                id:button1
                                text:"Button 1"
                                width:98
                                focus:true
                                defaultbutton:true
                                KeyNavigation.tab: button2
                            }
                            Button {
                                id:button2
                                text:"Button 2"
                                width:98
                                KeyNavigation.tab: button1
                            }
                        }
                        ChoiceList{model:choices; width:200}
                        Row {
                            SpinBox{id:t1; width:100; KeyNavigation.tab: t2; }
                            SpinBox{id:t2; width:100; KeyNavigation.tab: t3; }
                        }
                        TextField{id: t3; text:"TextField"; KeyNavigation.tab: t1}
                        ProgressBar {
                            // normalize value [0.0 .. 1.0]
                            value: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
                        }
                        ProgressBar {
                            indeterminate: true
                        }
                        Slider {id:slider; value:50}
                        smooth:true
                    }
                    Column {
                        id:rightcol
                        spacing: 24
                        GroupBox{
                            id:group1
                            text:"CheckBox"
                            Row {
                                spacing: 6
                                anchors.fill:parent
                                CheckBox{text:"Check 1"; checked:true}
                                CheckBox{text:"Check 2"}
                            }
                            RotationAnimation on rotation {
                                from:0; to:360;
                                easing.type:Easing.OutCubic; duration:1000;
                                running: animateCheck.checked
                                alwaysRunToEnd: true
                                loops: Animation.Infinite
                            }
                        }
                        GroupBox{
                            id:group2
                            text:"Radio Buttons"
                            ButtonRow {
                                RadioButton{id:radio1; text:"Radio 1"; checked:true}
                                RadioButton{id:radio2; text:"Radio 2"}
                            }
                            RotationAnimation on rotation {
                                from:0; to:360;
                                easing.type: Easing.OutCubic
                                duration: 1000
                                running: animateCheck.checked
                                alwaysRunToEnd: true
                                loops: Animation.Infinite
                            }
                        }
                        TextScrollArea {
                            id: area
                            y:t2.y
                            text: loremIpsum + loremIpsum
                            height: slider.y + slider.height - t2.y
                        }
                    }
                }
            }
        }

        Tab {
            title: "Dials"
            Row {
                anchors.fill: parent
                anchors.margins:8
                Dial{id: dial1; KeyNavigation.tab:dial2}
                Dial{id: dial2; KeyNavigation.tab:dial3}
                Dial{id: dial3; KeyNavigation.tab:dial1}
            }
        }
    }
}
