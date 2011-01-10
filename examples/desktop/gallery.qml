import QtQuick 1.0
import "widgets"

Rectangle {
    width: 4*240
    height: 440

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


    Item {
        anchors.margins:8
        anchors.fill:parent
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
            TextField{}
            TextArea{text:"\n"}
            Row {
                spacing:4
                ProgressBar{value:slider.value}
            }
            Slider{id:slider; value:50}

            GroupBox{
                text:"CheckBox"
                Row {
                    anchors.fill:parent
                    CheckBox{text:"CheckBox 1"}
                    CheckBox{text:"CheckBox 2";checked:true}
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

        }
    }
}
