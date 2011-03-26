import QtQuick 1.0

FocusScope {
    id: groupbox

    width: Math.max(200, contentWidth + loader.topMargin)
    height: contentHeight + sizehint.height + loader.topMargin

    default property alias children: content.children

    property string text
    property bool checkable: false
    property int contentWidth: content.childrenRect.width
    property int contentHeight: content.childrenRect.height

    property Component background: null
    property Item backgroundItem: loader.item

    property CheckBox checkbox: check

    Loader {
        id: loader
        property int topMargin: 24

        anchors.fill: parent
        property alias styledItem: groupbox
        sourceComponent: background

        Item {
            id:content
            anchors.topMargin: loader.topMargin
            anchors.leftMargin: 8
            anchors.top:parent.top
            anchors.left:parent.left
            enabled: (!checkable || checkbox.checked)
        }

        CheckBox {
            id: check
            checked: true
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: loader.topMargin
        }
    }
}
