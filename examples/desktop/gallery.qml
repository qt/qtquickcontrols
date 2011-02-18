import QtQuick 1.0
import "widgets"

Rectangle {
    width: 540
    height: 340

    ToolBar{
        id:toolbar
        width:parent.width
        height:40
        Row {
            spacing:2

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
        position: toolBarPosition.checked ? "South" : "North"
        tabbar: TabBar{parent:frame}
        anchors.top:toolbar.bottom
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.left:parent.left
        Tab {
            title:"Widgets"
            ScrollArea{
                id:flickable
                clip:true
                anchors.fill:parent
                frame:false
                enabled:enabledCheck.checked
                Row {
                    anchors.margins: 8
                    anchors.fill: parent
                    id:contentRow
                    Column {
                        spacing:6
                        SequentialAnimation on x {
                            running: animateCheck.checked
                            NumberAnimation { from:0 ; to: -flickable.width; easing.type:Easing.OutCubic; duration:600}
                            PauseAnimation { duration: 2000 }
                            NumberAnimation { from:-flickable.width; to:0; easing.type:Easing.OutCubic; duration:600}
                            alwaysRunToEnd: true
                            loops: Animation.Infinite
                        }

                        Row {
                            spacing:4
                            Repeater {
                                model: ["Button 1", "Button 2"]
                                Button { text:modelData
                                    rotation: 0
                                    smooth:true
                                    width:98
                                }
                            }
                        }
                        ChoiceList{model:choices}
                        SpinBox{}
                        TextField{text:"TextField"}
                        TextArea{text:"TextArea\n"}
                        ProgressBar {
                            // normalize value [0.0 .. 1.0]
                            value: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
                        }
                        Slider {id:slider; value:50}
                        smooth:true
                    }
                }
                Column {
                    id:rightcol
                    x:220; y:8
                    spacing: 12
                    GroupBox{
                        id:group1
                        text:"CheckBox"
                        Row {
                            spacing: 8
                            anchors.fill:parent
                            CheckBox{text:"Check 1"}
                            CheckBox{text:"Check 2";checked:true}
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
                            RadioButton{id:radio1; text:"Radio 1"}
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
                        id:area
                        text: loremIpsum + loremIpsum
                    }
                }
            }
        }
        Tab {
            title:"More"
            Rectangle {
                anchors.fill:parent
            }
        }
        Tab {
            title:"Stuff"
            Rectangle {
                anchors.fill:parent
            }
        }
    }
}
