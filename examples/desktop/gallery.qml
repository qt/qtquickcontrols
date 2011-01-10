import QtQuick 1.0
import "widgets"

Rectangle {
    width: 4*240
    height: 440

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
                CheckBox{}
                CheckBox{checked:true}
                RadioButton{}
                RadioButton{checked:true}
            }
            Row {
                spacing:4
                TextField{}
                TextArea{}
                Slider{}
            }
            Slider{orientation:Qt.Vertical}
        }
    }
}
