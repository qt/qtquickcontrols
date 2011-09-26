import QtQuick 1.1

Window {
    id: dialog

    width: 400
    height: 200

    signal finished
    signal accepted
    signal rejected

    property int ok: 0x00000400
    property int cancel: 0x00400000
    property int close: 0x00200000
    property int help: 0x02000000

    property int buttons: ok | cancel

    modal: true

    default property alias data: content.data

    Item {
        id: content
        anchors.topMargin:16
        anchors.margins: 16
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: buttonrow.top
    }

    // Dialogs should center on parent
    onVisibleChanged: center()

    Row {
        id: buttonrow

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 16
        anchors.topMargin:0
        anchors.bottomMargin:8
        spacing: 6

        Button {
            visible: buttons & help
            text: "Help"
            onClicked: {
                visible: dialog.visible = false
                rejected()
            }
        }
        Button {
            visible: buttons & cancel
            text: "Cancel"
            onClicked: {
                visible: dialog.visible = false
                rejected()
            }
        }
        Button {
            visible: buttons & ok
            text: "OK"
            defaultbutton: true
            onClicked: {
                visible: dialog.visible = false
                accepted()
            }
        }
    }
}
