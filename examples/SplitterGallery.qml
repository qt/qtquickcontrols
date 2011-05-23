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
//            property real maximumWidth: 100
            property real percentageWidth: 50
            color: "gray"
            width: 100
//            Behavior on width { PropertyAnimation{} } 
        }
        Rectangle {
            id: r2
            property real minimumWidth: slider.value
            color: "darkGray"
//            property bool expanding: true
            width: 50
        }
        Slider {
            id: slider
            maximumValue: 100
            value: 50
        }
        Rectangle {
            property real minimumWidth: 10
            color: "gray"
            width: 100
        }
    }
}
