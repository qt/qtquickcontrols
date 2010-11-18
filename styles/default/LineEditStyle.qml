import Qt 4.7

QtObject {

    property int preferredWidth: 200
    property int preferredHeight: 25

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
                anchors.fill: parent
                border.left: 6; border.top: 3
                border.right: 6; border.bottom: 3
                smooth: true
                source: "../../images/lineedit_normal.png"
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
