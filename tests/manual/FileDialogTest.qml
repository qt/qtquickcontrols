import QtQuick 2.0
//import "../components"
import QtQuick.Window 2.0
import QtDesktop 0.2


Rectangle {

    width: 538
    height: 360

    ToolBar {
        id: toolbar
        width: parent.width
        height: 40
        Row {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            ToolButton{
                text: "Toggle"
                tooltip: "Toggle file dialog visible"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.visible = !fileDialogLoad.visible
            }
            ToolButton{
                text: "Open"
                tooltip: "Open the file dialog"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.open()
            }
            ToolButton{
                text: "Close"
                tooltip: "Close the file dialog"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.close()
            }
        }
    }

    FileDialog {
        id: fileDialogLoad
        folder: "/tmp"
        title: "Choose a file to open"
        selectMultiple: true
        nameFilters: [ "Image files (*.png *.jpg)", "All files (*)" ]

        onAccepted: { console.log("Accepted: " + filePaths) }
    }

    Column {
        anchors.bottom: parent.bottom
        Text { text: "File dialog geometry " + fileDialogLoad.x + "," + fileDialogLoad.y + " " + fileDialogLoad.width + "x" + fileDialogLoad.height }
        Text { text: "File dialog visible? " + fileDialogLoad.visible }
    }
}

