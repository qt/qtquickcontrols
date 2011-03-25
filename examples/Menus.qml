import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 540
    height: 340

    MenuBar {
        id : mainMenuBar

        Menu {
            id : fileMenu
            text : "File"
        }
        Menu {
            id : editMenu
            text : "Edit"
        }
        Menu {
            id : windowMenu
            text : "Window"
        }
    }
}

