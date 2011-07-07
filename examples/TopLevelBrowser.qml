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
                text: "New Tab"
                shortcut: "Ctrl+T"
                onTriggered: {
                    browser.addTab()
                }
            }
            MenuItem {
                text: "New Window"
                shortcut: "Ctrl+N"
                onTriggered: {
                    var component = Qt.createComponent("TopLevelBrowser.qml")
                    console.log("component:", component, "status:", component.status)
                    if (component.status == Component.Ready) {
                        console.log("creating browserWindow")
                        var browserWindow = component.createObject(null);
                    }
                }
            }
            MenuItem {
                text: "Open Location"
                shortcut: "Ctrl+L"
                onTriggered: {
                    browser.address.focus = true
                    browser.address.selectAll()
                }
            }
            Separator {}
            MenuItem {
                text: "Close Tab"
                shortcut: "Ctrl+W"
//                onTriggered: Qt.quit()
            }
            MenuItem {
                text: "Close Window"
                shortcut: "Ctrl+Shift+W"
//                onTriggered: Qt.quit()
            }
            Separator {}
            MenuItem {
                text: "Close Browser"
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

