import Qt 4.7

QtObject {
    property int minimumWidth: 32
    property int minimumHeight: 32

    property Component background:
    Component {
        Item {
            width: minimumWidth
            height: minimumHeight
            Rectangle { // Background center fill
                anchors.fill: parent
                anchors.margins: 1
                radius: width/2
                color: backgroundColor
            }
            Image {
                opacity: enabled ? 1 : 0.7
                id: bulletImage
                source: "../../images/radiobutton_normal.png"
                fillMode: Image.Stretch
                anchors.centerIn:parent
            }
        }
    }

    property Component checkmark: Component {
        Image {
            source: "../../images/radiobutton_check.png"
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.centerIn: parent
            opacity: (!enabled && checked) || pressed == true ? 0.5 : (!checked ? 0 : 1)
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        }
    }
}
