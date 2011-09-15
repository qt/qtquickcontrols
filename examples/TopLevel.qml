import QtQuick 1.0
import QtDesktop 0.1
import "content"

Window {
    title: "parent window"

    width: gallery.width
    height: gallery.height
    maximumHeight: gallery.height
    minimumHeight: gallery.height
    maximumWidth: gallery.width
    minimumWidth: gallery.width
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

    Gallery {
        id: gallery
    }

}

