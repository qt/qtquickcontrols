import QtQuick 1.0
import "widgets"

Rectangle {
    width: 4*240
    height: 440

    SystemPalette{id:syspal}
    gradient: Gradient{ GradientStop{ position:1 ; color:syspal.window}
        GradientStop{ position:0 ; color:Qt.darker(syspal.window, 1.2)}
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
            TextField{}
            TextArea{text:"\n"}
            Row {
                spacing:4
                ProgressBar{value:50}
            }
            Slider{}

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
