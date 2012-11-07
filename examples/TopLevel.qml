import QtQuick 2.0
import QtDesktop 0.2
import "content"

ApplicationWindow {
    title: "parent window"

    width: gallery.width
    height: gallery.height
    maximumHeight: gallery.height
    minimumHeight: gallery.height
    maximumWidth: gallery.width
    minimumWidth: gallery.width


    FileDialog {
        id: fileDialogLoad
        folder: "/tmp"
        title: "Choose a file to open"
        selectMultiple: true
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]
        onAccepted: { console.log("Accepted: " + filePaths) }
    }

    menuBar: MenuBar {
        Menu {
            text: "File"
            MenuItem {
                text: "Open"
                shortcut: "Ctrl+O"
                onTriggered: fileDialogLoad.open();
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

