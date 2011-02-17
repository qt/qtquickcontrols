import QtQuick 1.0
import QtWebKit 1.0
import "widgets"

Rectangle {
    id:root
    width: 540
    height: 340

    ToolBar{
        id:toolbar
        width:parent.width
        height:46
        ToolButton{
            id:button
            text:"Back"
            iconSource:"image://desktoptheme/go-previous"
            onClicked: view.back.trigger()
            anchors.verticalCenter:parent.verticalCenter
            enabled:  view.back.enabled
        }
        TextField{
            id:textfield;
            text:"http://reddit.com"
            anchors.left:  button.right;
            anchors.right: progressbar.left
            anchors.rightMargin: 6
            anchors.verticalCenter:parent.verticalCenter
            Keys.onReturnPressed:  {
                if (textfield.text.substring(0, 7) != "http://")
                    textfield.text = "http://" + textfield.text;
                view.url = textfield.text
            }
        }
        ProgressBar{
            id:progressbar
            anchors.right: parent.right
            anchors.rightMargin: 6
            anchors.verticalCenter:parent.verticalCenter
            value:view.progress
            width: value < 1.0 ? 200 : 0
            Behavior on width {NumberAnimation{duration:160; easing.type: Easing.OutCubic}}
        }
        anchors.left: parent.left
        anchors.right: parent.right
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
            title: {
                if (view.title.length < 11)
                    return view.title
                else
                    return view.title.substring(0, 8) + "..."
            }
            ScrollArea{
                id:area
                clip:true
                frame:false
                anchors.fill:parent
                contentHeight: view.contentsSize.height
                contentWidth: view.contentsSize.width
                WebView{
                    id:view
                    height: contentsSize.height
                    width: contentsSize.width
                    onLoadFinished: area.contentY = -1 // workaround to force webview repaint
                    Component.onCompleted: url = textfield.text
                }
            }
        }
    }
}
