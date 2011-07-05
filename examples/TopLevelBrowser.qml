import QtQuick 1.0
import "../components"
import "content"

Window {
    title: "parent window"

    width: 640
    height: 480
    visible: true

    MenuBar {
        Menu {
            text: "File"
            MenuItem {
                text: "Open"
                shortcut: "Ctrl+O"
                onTriggered: console.log("we should display a file open dialog")
            }
            MenuItem {
                text: "Close"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            text: "Edit"
            MenuItem {
                text: "Copy"
            }
            MenuItem {
                text: "Paste"
            }
        }
    }

    Browser {
        id: browser
        anchors.fill: parent
    }

}

