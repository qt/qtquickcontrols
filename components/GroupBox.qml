import QtQuick 2.0
import "custom" as Components
import "plugin"

FocusScope {

    width: Math.max(200, content.childrenRect.width + sizehint.width)
    height: 52

    property variant sizehint: styleitem.sizeFromContents(0, 0)

    default property alias children: content.children
    property alias text: styleitem.text
    property bool checkable: false
    property int topMargin: 24

    QStyleItem {
        id: styleitem
        elementType: "groupbox"
        anchors.fill: parent
        hover:checkbox.containsMouse
        on: checkbox.checked
        focus: checkbox.activeFocus
        activeControl: checkable ? "checkbox" : ""

        Item {
            id:content
            anchors.topMargin: topMargin
            anchors.leftMargin: 8
            anchors.top:parent.top
            anchors.left:parent.left
            enabled: (!checkable || checkbox.checked)
        }
        Components.CheckBox{
            id: checkbox
            checked: true
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: topMargin
        }
    }
}
