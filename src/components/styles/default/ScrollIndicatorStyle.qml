import QtQuick 1.0

QtObject {
    property int minimumWidth: 12
    property int minimumHeight: 40

    property Component content: Component {
        Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: 3
                border.color: "black"
                color: "gray"
                radius: width/2
            }
        }
    }
}
