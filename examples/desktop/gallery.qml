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

    Flickable{
        id:flickable
        boundsBehavior: Flickable.StopAtBounds
        clip:true
        interactive: false
        anchors.top: toolbar.bottom
        anchors.left:parent.left
        anchors.right: parent.right
        anchors.bottom:parent.bottom
        contentHeight: parent.height*1.1

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
                            model: ["Button 1", "Button 2", "Button 3" ]
                            Button { text:modelData }
                        }
                    }
                    ChoiceList{model:choices}
                    SpinBox{}
                    TextField{text:"TextField"}
                    TextArea{text:"TextArea\n"}
                    Row {
                        spacing:4
                        ProgressBar{value:slider.value}
                    }
                    Slider{id:slider; value:50}

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
                            RadioButton{text:"Radio 2";checked:true}
                        }
                    }
                    ScrollBar{minimum: 0; maximum: 200}
                }

            }
        }
        contentY: scrollbar.value
    }
    ScrollBar{
        id:scrollbar
        orientation: Qt.Vertical
        maximum: flickable.contentHeight- flickable.height
        minimum: 0
        value:flickable.contentY
        anchors.right:parent.right
        anchors.top:parent.top
        anchors.bottom:parent.bottom
    }
}
