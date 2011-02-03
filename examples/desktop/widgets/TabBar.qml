import QtQuick 1.0
import "../../../components" as Components
import "../plugin"


Row {
    id: tabbar
    height:30
    property Item tabs
    onTabsChanged:parent = tabs

    Repeater {
        model: tabs ? tabs.content.length : 0
        onModelChanged: if(tabs)print(tabs.content.length)
        delegate: Rectangle {
            width: textitem.width + 42
            height: 30
            QStyleBackground {
                style: QStyleItem {
                    elementType: "tab"
                    selected: tabs.current == index
                }
                anchors { fill: parent }
            }
            Text {
                id:textitem
                y:6
                anchors.horizontalCenter:parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                text:  tabs.content[index].title
                elide: Text.ElideRight
            }
            MouseArea {
                anchors.fill: parent
                onClicked: tabs.current = index
            }
        }
    }
}
