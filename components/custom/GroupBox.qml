import QtQuick 1.1

Item {
    id: groupbox

    implicitWidth: adjustToContentSize ? Math.max(200, contentWidth + loader.leftMargin + loader.rightMargin) : 100
    implicitHeight: adjustToContentSize ? contentHeight + loader.topMargin + loader.bottomMargin : 100

    default property alias data: content.data

    property string title
    property bool checkable: false
    property int contentWidth: content.childrenRect.width
    property int contentHeight: content.childrenRect.height
    property double contentOpacity: 1

    property Component background: null
    property Item backgroundItem: loader.item

    property Item checkbox: check
    property alias checked: check.checked
    property bool adjustToContentSize: false // Resizes groupbox to fit contents.
                                             // Note when using this, you cannot anchor children
    Loader {
        id: loader
        anchors.fill: parent
        property int topMargin: title.length > 0 || checkable ? 22 : 4
        property int bottomMargin: 4
        property int leftMargin: 4
        property int rightMargin: 4
        property alias styledItem: groupbox
        sourceComponent: background
    }
    CheckBox {
        id: check
        checked: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: loader.topMargin
    }
    Item {
        id:content
        z: 1
        focus: true
        opacity: contentOpacity
        anchors.topMargin: loader.topMargin
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.bottomMargin: 8
        anchors.fill: parent
        enabled: (!checkable || checkbox.checked)
    }
}
