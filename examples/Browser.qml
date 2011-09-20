import QtQuick 1.0
import QtDesktop 0.1
import QtWebKit 1.0
import "content"

Rectangle {
    id:root
    width: 540
    height: 340

    property alias tabFrame: frame
    property alias address: addressField

    function addTab() {
        var component = Qt.createComponent("BrowserTab.qml")
        if (component.status == Component.Ready) {
            frame.addTab(component)
        }
    }

    function closeTab() {
        if (frame.count > 1)
            frame.removeTab(frame.current)
    }

    Window {
        id: settingsDialog
        width: 200
        height: 200
        modal: true

        Rectangle {
            anchors.centerIn: parent
            width: 150
            height: 150

            Component.onCompleted: {
                javaCheckBox.checked = tab.webView.settings.javaEnabled
                javascriptCheckBox.checked = tab.webView.settings.javascriptEnabled
                pluginsCheckBox.checked = tab.webView.settings.pluginsEnabled
            }

            CheckBox {
                id: javaCheckBox
                text: "Enable Java"
                anchors.margins: 10
                anchors.top: parent.top
                anchors.left: parent.left

                onCheckedChanged: {
                    for (var i=0; i<tabFrame.tabs.length; i++) {
                        tabFrame.tabs[i].webView.settings.javaEnabled = checked
                    }
                }
            }
            CheckBox {
                id: javascriptCheckBox
                text: "Enable Javascript"
                anchors.margins: 10
                anchors.top: javaCheckBox.bottom
                anchors.left: parent.left

                onCheckedChanged: {
                    for (var i=0; i<tabFrame.tabs.length; i++) {
                        tabFrame.tabs[i].webView.settings.javascriptEnabled = checked
                    }
                }
            }
            CheckBox {
                id: pluginsCheckBox
                text: "Enable Plugins"
                anchors.margins: 10
                anchors.top: javascriptCheckBox.bottom
                anchors.left: parent.left

                onCheckedChanged: {
                    for (var i=0; i<tabFrame.tabs.length; i++) {
                        tabFrame.tabs[i].webView.settings.pluginsEnabled = checked
                    }
                }
            }
        }

        Button {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: "okay"
            onClicked: {
                settingsDialog.visible = false
            }
        }
    }

    ToolBar{
        id:toolbar
        width:parent.width
        anchors.left: parent.left
        anchors.right: parent.right
        height:46

        ToolButton{
            id:back
            text:"Back"
            iconSource:"images/go-previous.png"
            anchors.verticalCenter:parent.verticalCenter
            enabled:  frame.tabs[frame.current].webView.back.enabled
            onClicked: frame.tabs[frame.current].webView.back.trigger()
        }

        ToolButton{
            id:forward
            text:"Forward"
            iconSource:"images/go-next.png"
            anchors.left: back.right
            anchors.verticalCenter:parent.verticalCenter
            enabled:  frame.tabs[frame.current].webView.forward.enabled
            onClicked: frame.tabs[frame.current].webView.forward.trigger()
        }

        ToolButton{
            id:reload
            anchors.left: forward.right
            text: frame.tabs[frame.current].webView.progress < 1 ? "Stop" : "Reload"
            iconSource: frame.tabs[frame.current].webView.progress < 1 ?  "images/process-stop.png" : "images/view-refresh.png"
            anchors.verticalCenter:parent.verticalCenter
            onClicked: {
                if(frame.tabs[frame.current].webView.progress < 1) frame.tabs[frame.current].webView.stop.trigger()
                else frame.tabs[frame.current].webView.reload.trigger()
            }
        }

        TextField{
            id:addressField;
            text: "http://osnews.com"
            anchors.left:  reload.right;
            anchors.right: settings.left
            anchors.rightMargin: 9
            anchors.leftMargin: 6
            anchors.verticalCenter:parent.verticalCenter

            Keys.onReturnPressed:  {
                if (addressField.text.substring(0, 7) != "http://")
                    addressField.text = "http://" + addressField.text;
                frame.tabs[frame.current].webView.url = addressField.text
            }
        }

        ProgressBar{
            id:progressbar
            anchors.left: settings.right
            anchors.rightMargin: 6
            anchors.verticalCenter:parent.verticalCenter
            value:tab.webView.progress
            width: value < 1.0 ? 200 : 0
            Behavior on width {NumberAnimation{duration:160; easing.type: Easing.OutCubic}}
        }

        ToolButton{
            id:settings
            anchors.right: parent.right
            text: "Settings"
            iconSource: "images/preferences-system.png"
            anchors.verticalCenter:parent.verticalCenter
            onClicked: {
                settingsDialog.visible = true
            }
        }
    }

    SystemPalette{id:syspal}
    color:syspal.window

    TabFrame {
        id:frame
        anchors.top:toolbar.bottom
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.left:parent.left

        onCurrentChanged: {
            addressField.text = tabs[current].url
        }

        BrowserTab {
            id: tab
        }
    }
}
