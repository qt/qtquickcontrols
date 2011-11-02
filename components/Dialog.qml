import QtQuick 1.1

Window {
    id: dialog

    width: 400
    height: 200

    signal closed
    signal accepted
    signal rejected
    signal buttonClicked

    property QtObject clickedButton: null

    property int noRole: 0
    property int acceptRole: 1
    property int rejectRole: 2
    property int helpRole: 3

    property int ok: 0x00000400
    property int cancel: 0x00400000
    property int close: 0x00200000
    property int help: 0x02000000

    property int buttons: ok | cancel

    modal: false

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
        property bool mac: (style.style == "mac")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 16
        anchors.topMargin:0
        anchors.bottomMargin: style.isMac ? 12 : 8
        spacing: 6

        Button {
            id: helpbutton
            property int role: helpRole
            visible: buttons & help
            text: "Help"
            focus: false
            Component.onCompleted: if (style.isMac) width = 22
            background: style.isMac ? machelpdelegate : cancelbutton.background
            onClicked: {
                clickedButton = helpbutton
                buttonClicked()
            }
            Component {
                id: machelpdelegate
                StyleItem {
                    anchors.fill: parent
                    elementType: "machelpbutton"
                    width: 22
                    height: 22
                    sunken: helpbutton.pressed
                    anchors.centerIn: parent
                }
            }
        }
    }
    Row {
        id: buttonrow
        spacing: 6
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        anchors.topMargin: 0
        anchors.bottomMargin: 8
        layoutDirection: style.isMac ? Qt.LeftToRight : Qt.RightToLeft

        Button {
            id: cancelbutton
            visible: buttons & cancel
            property int role: rejectRole
            text: "Cancel"
            onClicked: {
                visible: dialog.visible = false
                clickedButton = cancelbutton
                rejected()
                closed()
                buttonClicked(role)
            }
        }
        Button {
            id: okbutton
            property int role: acceptRole
            visible: buttons & ok
            text: "OK"
            defaultbutton: true
            onClicked: {
                visible: dialog.visible = false
                clickedButton = okbutton
                accepted()
                closed()
                buttonClicked()
            }
        }
    }
    StyleItem {
        id: style
        visible: false
        property bool isMac: (style.style == "mac")

    }
}
