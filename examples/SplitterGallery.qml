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
//            property bool expanding: true
            property int minimumWidth: 100
            property int percentageWidth: 30
            color: "gray"
            width: 200
//            Behavior on width { PropertyAnimation{} } 
        }
        Rectangle {
            id: r2
            color: "darkGray"
            width: 50
        }
        Rectangle {
            property int minimumWidth: 10
            color: "gray"
            width: r2.width
        }
        Rectangle {
            color: "darkgray"
        }
    }
}
