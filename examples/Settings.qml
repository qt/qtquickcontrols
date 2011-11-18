import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    id: rect

    width: 360
    height: 360
    color: "blue"

    property string nextState: "green"

    Text {
        text: "Click me!"
        color: "white"
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: rect.state = rect.nextState
    }

    states : [
        State {
            name: "blue"
            PropertyChanges { target: rect; color: rect.nextState }
            PropertyChanges { target: rect; nextState: rect.color }
        },
        State {
            name: "green"
            PropertyChanges { target: rect; color: rect.nextState }
            PropertyChanges { target: rect; nextState: rect.color }
        }
    ]

    Settings {
        property alias state: rect.state
        property alias width: rect.width
        property alias height: rect.height
    }
}
