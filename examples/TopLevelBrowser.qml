import QtQuick 1.0
import QtDesktop 0.1
import "content"

Window {
    id: topLevelBrowser
    title: "Qml Desktop Browser"

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
                    var topLevelBrowserComponent = Qt.createComponent("TopLevelBrowser.qml")
                     if (topLevelBrowserComponent.status == Component.Ready) {
                        console.log("creating browserWindow")
                        var browserWindow = topLevelBrowserComponent.createObject(null);
                    }
                }
            }
            MenuItem {
                text: "Open Location"
                shortcut: "Ctrl+L"
                onTriggered: {
                    browser.address.focus = true
                    browser.address.selectAll()
                    browser.address.forceActiveFocus()
                }
            }
            Separator {}
            MenuItem {
                text: "Close Tab"
                shortcut: "Ctrl+W"
                onTriggered: {
                    browser.closeTab()
                }
            }
            MenuItem {
                text: "Close Window"
                shortcut: "Ctrl+Shift+W"
                onTriggered: {
                    topLevelBrowser.close = true
                }
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

