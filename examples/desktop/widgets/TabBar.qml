import QtQuick 1.0
import "../../../components" as Components
import "../plugin"


Row {
    z:10
    id: tabbar
    height:28
    property Item tabFrame
    onTabFrameChanged:parent = tabFrame
    property int __overlap : styleitem.pixelMetric("tabvshift");
    property string position: tabFrame ? tabFrame.position : "North"
    QStyleItem {id:styleitem}

    function tab(index) {
        for (var i = 0; i < children.length; ++i) {
            if (children[i].tabindex == index) {
                return children[i]
            }
        }
        return null;
    }

    Repeater {
        id:repeater
        model: tabFrame ? tabFrame.tabs.length : null
        delegate: Item {
            id:tab
            property int tabindex: index
            property bool selected : tabFrame.current == index
            width: textitem.width + 42
            height: tabbar.height
            z: selected ? 1 : -1

            QStyleBackground {
                style: QStyleItem {
                    id:style
                    elementType: "tab"
                    selected: tab.selected
                    text: tabbar.position

                    activeControl: tabFrame.count == 1 ?
                            "only" :
                            index == 0 ? "beginning" :
                            index == tabFrame.count-1 ? "end" : "middle"
                }
                anchors.leftMargin: style.text == "North" && (style.activeControl == "middle" || style.activeControl == "end")
                                     && tab.selected ? -__overlap : 0

                anchors.rightMargin: style.text == "North" && (style.activeControl == "middle"  || style.activeControl == "beginning")
                                     && tab.selected ? -__overlap : 0
                anchors { fill: parent }
            }
            Text {
                id:textitem
                y:6
                anchors.horizontalCenter:parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                text:  tabFrame.tabs[index].title
                elide: Text.ElideRight
            }
            MouseArea {
                anchors.fill: parent
                onPressed: tabFrame.current = index
            }
        }
    }
}
