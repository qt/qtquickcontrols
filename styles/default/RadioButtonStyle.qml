import Qt 4.7
import "tools" as StyleTools

QtObject {
    property int minimumWidth: 32
    property int minimumHeight: 32
    property Item item;

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
            StyleTools.ColorConverter{id:cc; color:backgroundColor}
            source: cc.grayValue() < 70? "../../images/radiobutton_check_white.png" : "../../images/radiobutton_check.png"
            anchors.centerIn: parent
            opacity: (!enabled && checked) || pressed == true ? 0.5 : (!checked ? 0 : 1)
            Behavior on opacity { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        }
    }
}
