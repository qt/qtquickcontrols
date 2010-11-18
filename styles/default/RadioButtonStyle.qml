import Qt 4.7

QtObject {

    property int preferredWidth: 90
    property int preferredHeight: 32

    property Component background:
    Component {
        id: defaultBackground
        Rectangle{
            width: button.width-2
            height: button.height-2
            anchors.centerIn: parent
            color: button.backgroundColor
            radius: width/2
            Item {
                anchors.centerIn: parent
                Rectangle {
                    width: 10
                    height: 10
                    anchors.centerIn: parent
                    color: button.pressed || !button.enabled ? "gray" : "black"
                    radius: width/2
                    opacity: button.checked || button.pressed ? 1 : 0
                }
            }
        }
    }
}
