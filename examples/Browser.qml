import QtQuick 1.0
import QtWebKit 1.0
import "../components"

Rectangle {
    id:root
    width: 540
    height: 340

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
            enabled:  view.back.enabled
            onClicked: view.back.trigger()
        }

        ToolButton{
            id:forward
            text:"Forward"
            iconSource:"images/go-next.png"
            anchors.left: back.right
            anchors.verticalCenter:parent.verticalCenter
            enabled:  view.forward.enabled
            onClicked: view.forward.trigger()
        }

        ToolButton{
            id:reload
            anchors.left: forward.right
            text: view.progress < 1 ? "Stop" : "Reload"
            iconSource: view.progress < 1 ?  "images/process-stop.png" : "images/view-refresh.png"
            anchors.verticalCenter:parent.verticalCenter
            onClicked: {
                if(view.progress < 1) view.stop.trigger()
                else view.reload.trigger()
            }
        }

        TextField{
            id:textfield;
            text: "http://osnews.com"
            anchors.left:  reload.right;
            anchors.right: settings.left
            anchors.rightMargin: 9
            anchors.leftMargin: 6
            anchors.verticalCenter:parent.verticalCenter
            Keys.onReturnPressed:  {
                if (textfield.text.substring(0, 7) != "http://")
                    textfield.text = "http://" + textfield.text;
                view.url = textfield.text
            }
        }

        ProgressBar{
            id:progressbar
            anchors.left: settings.right
            anchors.rightMargin: 6
            anchors.verticalCenter:parent.verticalCenter
            value:view.progress
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
        Tab {
            title: view.title.length < 11 ? view.title :
                   view.title.substring(0, 8) + "..."
            ScrollArea{
                id: area
                frame: false
                anchors.fill: parent
                WebView{
                    id:view
                    newWindowParent:root
                    onLoadFinished: area.contentY = -1 // workaround to force webview repaint
                    Component.onCompleted: url = textfield.text
                }
            }
        }
    }
}
