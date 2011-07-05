import QtQuick 1.0
import QtWebKit 1.0
import "../components"

Rectangle {
    id:root
    width: 540
    height: 340

    property alias tabFrame: frame
    property alias address: addressField

    function addTab() {
        var component = Qt.createComponent("BrowserTab.qml")
        if (component.status == Component.Ready) {
            tabFrame.addTab(component)
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
            enabled:  tab.webView.back.enabled
            onClicked: tab.webView.back.trigger()
        }

        ToolButton{
            id:forward
            text:"Forward"
            iconSource:"images/go-next.png"
            anchors.left: back.right
            anchors.verticalCenter:parent.verticalCenter
            enabled:  tab.webView.forward.enabled
            onClicked: tab.webView.forward.trigger()
        }

        ToolButton{
            id:reload
            anchors.left: forward.right
            text: tab.webView.progress < 1 ? "Stop" : "Reload"
            iconSource: tab.webView.progress < 1 ?  "images/process-stop.png" : "images/view-refresh.png"
            anchors.verticalCenter:parent.verticalCenter
            onClicked: {
                if(tab.webView.progress < 1) view.stop.trigger()
                else tab.webView.reload.trigger()
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
                console.log("display settings window here!")
            }
        }
    }

    SystemPalette{id:syspal}
    color:syspal.window

    TabFrame {
        id:frame
        tabbar: TabBar{parent:frame}
        anchors.top:toolbar.bottom
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.left:parent.left

        BrowserTab {
            id: tab
        }
    }
}
