import QtQuick 2.0
import QtDesktop 1.0
import "content"

ApplicationWindow {
    title: "Component Gallery"

    width: 580
    height: 400
    minimumHeight: 400
    minimumWidth: 340
    property string loremIpsum:
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. ";

    ToolBar {
        id: toolbar
        width: parent.width
        height: 40
        Row {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter
            ToolButton {
                iconName: "window-new"
                iconSource: "images/window-new.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: window1.visible = !window1.visible
                Accessible.name: "New window"
                tooltip: "Toggle visibility of the second window"
            }
            ToolButton {
                iconName: "document-open"
                iconSource: "images/document-open.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogLoad.open()
                tooltip: "(Pretend to) open a file"
            }
            ToolButton {
                iconName: "document-save-as"
                iconSource: "images/document-save-as.png"
                anchors.verticalCenter: parent.verticalCenter
                onClicked: fileDialogSave.open()
                tooltip: "(Pretend to) save as..."
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

        FileDialog {
            id: fileDialogSave
            folder: "/tmp"
            title: "Save as..."
            modal: true
            selectExisting: false

            onAccepted: { console.log("Accepted: " + filePath) }
        }

        ChildWindow { id: window1 }

        ContextMenu {
            id: editmenu
            MenuItem { text: "Copy" ;  iconName: "edit-copy" }
            MenuItem { text: "Cut" ;   iconName: "edit-cut" }
            MenuItem { text: "Paste" ; iconName: "edit-paste" }
        }
        MouseArea {
            anchors.fill:  parent
            acceptedButtons: Qt.RightButton
            onPressed: editmenu.showPopup(mouseX, mouseY)
        }

        CheckBox {
            id: enabledCheck
            text: "Enabled"
            checked: true
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
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


    SystemPalette {id: syspal}
    StyleItem{ id: styleitem}
    color: syspal.window
    ListModel {
        id: choices
        ListElement { text: "Banana" }
        ListElement { text: "Orange" }
        ListElement { text: "Apple" }
        ListElement { text: "Coconut" }
    }

    TabFrame {
        id:frame
        enabled: enabledCheck.checked
        position: controlPage.tabPosition
        anchors.top: toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: styleitem.style == "mac" ? 12 : 0
        Tab {
            title: "Control"
            Controls { id: controlPage }
        }
        Tab {
            id:mytab
            title: "Itemviews"
            ModelView { }
        }
        Tab {
            title: "Range"
            RangeTab { }
        }
        Tab {
            title: "Styles"
            Styles { anchors.fill: parent}
        }
        Tab {
            title: "Sidebar"
            Panel { anchors.fill:parent }
        }
    }
}

