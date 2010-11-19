import Qt 4.7

QtObject {

    property int preferredWidth: 32
    property int preferredHeight: 32

    property Component background:
    Component {
        Rectangle{
            border.color:"#333"
            width: 32
            height: 32
            anchors.centerIn: parent
            color: backgroundColor
            radius: width/2
        }
    }

    property Component checkmark: Component {
        Item {
            anchors.centerIn: parent
            Rectangle {
                width: 10
                height: 10
                anchors.centerIn: parent
                border.color:"#333"
                color: !parent.enabled ? "gray" : "black"
                radius: width/2
            }
        }
    }
}
