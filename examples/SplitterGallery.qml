import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 800
    height: 600

    SplitterRow {
        anchors.fill: parent
        Rectangle {
            color: "red"
            width: 100
            height: 50
        }
        Rectangle {
            color: "blue"
            width: 150
        }
        Rectangle {
            color: "green"
            width: 150
        }
    }
}
