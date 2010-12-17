import QtQuick 1.0
import "exampletheme"

Rectangle {
    width: 4*240
    height: 440

    Item {
        anchors.margins:8
        anchors.fill:parent
        Column {
            spacing:6
            Row {
                spacing:6
                Repeater {
                    model: ["Button 1", "Button 2", "Button 3" ]
                    Button { text:modelData }
                }
            }
            LineEdit { text:modelData }
            Slider { value:50 }
            Row {
                spacing:4
                CheckBox { }
                RadioButton { }
            }
        }
    }
}
