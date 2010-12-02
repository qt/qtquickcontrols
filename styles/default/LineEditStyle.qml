import Qt 4.7

QtObject {

    property int minimumWidth: 200
    property int minimumHeight: 25

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 8
    property int bottomMargin: 8

    property Component background: Component {
        Item {  // see QTBUG-14873
            Rectangle { // Background center fill
                anchors.fill: parent
                anchors.margins: 1
                radius: 5
                color: backgroundColor
            }
            BorderImage { // Background border
                opacity: enabled ? 1 : 0.7
                anchors.fill: parent
                border.left: 6; border.top: 6
                border.right: 6; border.bottom: 6
                smooth: true
                source: "images/lineedit_normal.png"
            }
        }
    }

    property Component hints: Component {
        Item {
            property color textColor: "#444"
            property color backgroundColor: "white"
            property int fontPixelSize: 14
            property bool fontBold: false
            property int passwordEchoMode: TextInput.PasswordEchoOnEdit
        }
    }
}
