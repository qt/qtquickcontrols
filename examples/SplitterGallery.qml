import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 800
    height: 600

    SplitterRow {
        id: splitter
        anchors.fill: parent

        Rectangle {
            id: r1
//            property bool expanding: true
//            property int minimumWidth: 100
//            property real percentageWidth: 50
            color: "gray"
            width: slider.value
//            Behavior on width { PropertyAnimation{} } 
        }
        Rectangle {
            id: r2
            color: "darkGray"
//            property bool expanding: true
            width: 50
        }
        Slider {
            id: slider
            maximumValue: 300
            value: 150
            onValueChanged: r1.width = value
        }
        Rectangle {
            property int minimumWidth: 10
            color: "gray"
            width: 100
        }
    }
}
