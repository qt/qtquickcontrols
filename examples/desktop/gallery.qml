import QtQuick 1.0
import "widgets"

Rectangle {
    width: 640
    height: 400

    ToolBar{
        id:toolbar
        width:parent.width
        height:46
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

    ScrollArea{
        id:flickable
        clip:true
        anchors.top: toolbar.bottom
        anchors.left:parent.left
        anchors.right: parent.right
        anchors.bottom:parent.bottom
        contentHeight: 580
        frame:false

        Row {
            anchors.margins: 8
            anchors.fill: parent
            id:contentRow
            enabled:enabledCheck.checked
            Item {
                Column {
                    spacing:6
                    Row {
                        spacing:4
                        Repeater {
                            model: ["Button 1", "Button 2"]
                            Button { text:modelData
                                rotation: 0
                                smooth:true
                                width:98
                                RotationAnimation on rotation { from:0; to: 360;
                                    direction: RotationAnimation.Clockwise
                                    running: animateCheck.checked
                                    duration: 1000
                                    loops: Animation.Infinite
                                }
                            }
                        }
                    }
                    ChoiceList{model:choices}
                    SpinBox{}
                    TextField{text:"TextField"}
                    TextArea{text:"TextArea\n"}
                    ProgressBar{value:slider.value}
                    Slider{id:slider; value:50}
                    smooth:true

                    GroupBox{
                        text:"CheckBox"
                        Row {
                            anchors.fill:parent
                            CheckBox{text:"Check 1"}
                            CheckBox{text:"Check 2";checked:true}
                        }
                    }
                    GroupBox{
                        text:"Radio Buttons"
                        Row {
                            anchors.fill:parent
                            RadioButton{text:"Radio 1"}
                            RadioButton{
                                text:"Radio 2";
                                checked:true
                            }
                        }
                    }
                    ScrollArea {
                        width:200
                        height:100
                        contentHeight: 400
                        Button {text:"hello"}
                    }

                }
            }
        }
    }
}
