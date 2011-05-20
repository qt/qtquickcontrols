import QtQuick 1.0
import "../components"

Rectangle {
    width: 540
    height: 340
    color: "green"
    id : rect

    ContextMenu {
        id : editMenu

        MenuItem { text : "blue"
                   onSelected : { rect.color = "blue" }
        }

        MenuItem { text : "red"
                   onSelected : { rect.color = "red" }
        }

        MenuItem { text : "pink"
                   onSelected : { rect.color = "pink" }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons : Qt.RightButton
        onClicked: editMenu.showPopup(mouseX, mouseY)
    }
}
