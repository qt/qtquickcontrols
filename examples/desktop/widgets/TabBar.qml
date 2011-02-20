import QtQuick 1.0
import "../../../components" as Components
import "../plugin"


Item {
    id: tabbar
    property int tabHeight: styleitem.sizeFromContents(100, 24).height
    height: tabHeight

    property Item tabFrame
    onTabFrameChanged:parent = tabFrame
    visible: tabFrame ? tabFrame.tabsVisible : true
    property int __overlap : styleitem.pixelMetric("tabvshift");
    property string position: tabFrame ? tabFrame.position : "North"
    property string tabBarAlignment: styleitem.styleHint("tabbaralignment");
    property int tabOverlap: styleitem.pixelMetric("taboverlap");

    function tab(index) {
        for (var i = 0; i < tabrow.children.length; ++i) {
            if (tabrow.children[i].tabindex == index) {
                return tabrow.children[i]
            }
        }
        return null;
    }

    QStyleItem {
        id:styleitem
        elementType: "tab"
        text: "generic"
    }

    Row {
        id:tabrow
        states:
        State {
            when: tabBarAlignment == "center"
            name: "centered"
            AnchorChanges {
                target:tabrow
                anchors.horizontalCenter: tabbar.horizontalCenter
            }
        }
        Repeater {
            id:repeater
            model: tabFrame ? tabFrame.tabs.length : null
            delegate: Item {
                id:tab
                property int tabindex: index
                property bool selected : tabFrame.current == index
                width: textitem.width + 42
                height: tabHeight
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
                    anchors.fill:parent
                }

                Text {
                    id:textitem
                    anchors.centerIn:parent
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
}
