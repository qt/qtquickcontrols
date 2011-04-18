import QtQuick 1.0
import "custom" as Components
import "plugin"


Item {
    id: tabbar
    property int tabHeight: tabrow.height
    property int tabWidth: tabrow.width
    height: tabHeight

    property Item tabFrame
    onTabFrameChanged:parent = tabFrame
    visible: tabFrame ? tabFrame.tabsVisible : true
    property int __overlap : styleitem.pixelMetric("tabvshift");
    property string position: tabFrame ? tabFrame.position : "North"
    property string tabBarAlignment: styleitem.styleHint("tabbaralignment");
    property int tabOverlap: styleitem.pixelMetric("taboverlap");
    property int tabBaseOverlap: styleitem.pixelMetric("tabbaseoverlap");
    property int tabHSpace: styleitem.pixelMetric("tabhspace");
    property int tabVSpace: styleitem.pixelMetric("tabvspace");

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
        property int paintMargins: 1
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
                z: selected ? 1 : -1
                function updateRect() {
                    var rect = style.sizeFromContents(textitem.width + tabHSpace + 2, Math.max(textitem.height + tabVSpace, 20))
                    width = rect.width
                    height = rect.height
                }
                QStyleItem {
                    id: style
                    elementType: "tab"
                    selected: tab.selected
                    info: tabbar.position
                    text: tabFrame.tabs[index].title

                    property bool first: index === 0
                    paintMargins: tabrow.paintMargins
                    activeControl: tabFrame.count == 1 ? "only" : index === 0 ? "beginning" :
                            index == tabFrame.count-1 ? "end" : "middle"
                    anchors.leftMargin: (style.text == "North" &&
                                                      (style.activeControl == "middle" || style.activeControl == "end")
                                        && tab.selected ? -__overlap : 0 - (first ? 0 : -paintMargins))

                    anchors.rightMargin: -tabOverlap + (style.text == "North" && (style.activeControl == "middle"  || style.activeControl == "beginning")
                                         && tab.selected ? -__overlap : 0)
                    anchors.fill: parent
                    anchors.margins: -paintMargins
                    Text {
                        id: textitem
                        // Used for size hint
                        visible: false
                        onWidthChanged: updateRect()
                        onHeightChanged: updateRect()
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
