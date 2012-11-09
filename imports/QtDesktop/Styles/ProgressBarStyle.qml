import QtQuick 2.0
import QtDesktop 1.0
Item {
    anchors.fill: parent
    implicitWidth: 200
    implicitHeight: 20

    property color backgroundColor: "darkgrey"
    property color progressColor: "#47f"

    property Component background: Rectangle {
        id: styleitem
        clip: true
        radius: 2
        antialiasing: true
        border.color: "#aaa"

        gradient: Gradient {
            GradientStop {color: Qt.lighter(backgroundColor, 1.6)  ; position: 0}
            GradientStop {color: backgroundColor ; position: 1.55}
        }

        Rectangle {
            id: progressItem
            implicitWidth: parent.width * control.value / control.maximumValue
            radius: 2
            antialiasing: true
            implicitHeight: 20
            gradient: Gradient {
                GradientStop {color: Qt.lighter(progressColor, 1.6)  ; position: 0}
                GradientStop {color: progressColor ; position: 1.4}
            }
            border.width: 1
            border.color: Qt.darker(progressColor, 1.2)
            Rectangle {
                color: "transparent"
                radius: 1.5
                antialiasing: true
                anchors.fill: parent
                anchors.margins: 1
                border.color: Qt.rgba(1,1,1,0.2)
            }
        }
    }

    Loader {
        id: backgroundLoader
        anchors.fill: parent
        sourceComponent: background
    }
}
