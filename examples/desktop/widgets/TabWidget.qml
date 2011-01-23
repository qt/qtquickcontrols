import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item{
    id: tabWidget
    width:100
    height:100

    // Setting the default property to stack.children means any child items
    // of the TabWidget are actually added to the 'stack' item's children.
    // See the "Writing QML Components: Properties, Methods and Signals"
    // documentation for details on default properties.
    default property alias content: stack.children

    property int current: 0

    onCurrentChanged: setOpacities()
    Component.onCompleted: setOpacities()

    function setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].opacity = (i == current ? 1 : 0)
        }
    }

    Row {
        id: header
        anchors.left:parent.left
        anchors.top:parent.top
        height:20

        Repeater {
            model: stack.children.length
            delegate: Rectangle {
                //width: tabWidget.width / stack.children.length; height: 36
                width:textitem.width + 42
                height:30
                QStyleBackground {
                    style: QStyleItem {
                        elementType:"tab"
                        selected: tabWidget.current == index
                    }
                    anchors { fill: parent; }
                }
                Text {
                    id:textitem
                    y:6
                    anchors.horizontalCenter:parent.horizontalCenter
                    horizontalAlignment: Qt.AlignHCenter; verticalAlignment: Qt.AlignVCenter
                    text: stack.children[index].title
                    elide: Text.ElideRight
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: tabWidget.current = index
                }
            }
        }
    }

    QStyleBackground {
        id: stack
        anchors.fill:parent
        anchors.topMargin:14
        style: QStyleItem {
            elementType:"tabframe"
            value: header.children[current].x
            minimum:header.children[current].width
        }
        width: tabWidget.width
        anchors.top: header.bottom; anchors.bottom: tabWidget.bottom
    }
}
