import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 800
    height: 600

    SplitterRow {
        id: sr
        anchors.fill: parent

        Rectangle {
            color: "gray"
            width: 200
        }
        Rectangle {
            property bool expanding: true
            property real minimumWidth: 50
            color: "darkgray"
        }
        Rectangle {
            color: "gray"
            width: 200
        }
    }
}
