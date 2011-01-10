import QtQuick 1.0
import "widgets"

Rectangle {
    width: 540
    height: 330

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
        contentHeight: 420
        frame:false
        enabled:enabledCheck.checked

        Column {
            x:220; y:8
            spacing: 8
            ScrollArea {
                width:200
                height:110
                contentHeight: 180
                Rectangle{
                    anchors.fill: parent
                    TextEdit {id:edit; text:loremIpsum; wrapMode: TextEdit.WordWrap; width:parent.width}
                }
            }
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
        }
        Row {
            anchors.margins: 8
            anchors.fill: parent
            id:contentRow
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

                }
            }
        }
    }
    property string loremIpsum:
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud "+
        "exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ";
}
