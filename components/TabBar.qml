import QtQuick 2.0
import "custom" as Components
import "plugin"


Item {
    id: tabbar
    property int tabHeight: styleitem.sizeFromContents(100, 24).height
    property int tabWidth: tabrow.width
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
        visible:false
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

                QStyleItem {
                    id: style
                    elementType: "tab"
                    selected: tab.selected
                    info: tabbar.position
                    text: tabFrame.tabs[index].title
                    property bool first: index === 0
                    paintMargins: first ? 0 : 1
                    activeControl: tabFrame.count == 1 ? "only" : index === 0 ? "beginning" :
                            index == tabFrame.count-1 ? "end" : "middle"
                    anchors.leftMargin: (style.text == "North" &&
                                                      (style.activeControl == "middle" || style.activeControl == "end")
                                        && tab.selected ? -__overlap : 0) - (first ? 0 : paintMargins)

                    anchors.rightMargin: -tabOverlap + (style.text == "North" && (style.activeControl == "middle"  || style.activeControl == "beginning")
                                         && tab.selected ? -__overlap : 0) - paintMargins - (!first ? 0 : paintMargins)
                    anchors.fill:parent
                    anchors.margins:-paintMargins
                    Text {
                        id: textitem
                        // Used for size hint
                        visible: false
                        text: tabFrame.tabs[index].title
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: tabFrame.current = index
                }
            }
        }
    }
}
