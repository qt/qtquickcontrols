import QtQuick 1.0
import QtDesktop 0.1
import QtWebKit 1.0
import "content"

Tab {
    property alias webView : view
    property alias url: view.url
    property int tabId: 0

    onUrlChanged: {
        if (tabFrame.current == tabId)
            addressField.text = url
    }

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
            Component.onCompleted: url = addressField.text
        }
    }
}
