import QtQuick 1.0
import "custom" as Components
import "plugin"

Item{
    id: tabWidget
    width:100
    height:100
    property TabBar tabbar
    property int current: 0
    property int count: stack.children.length
    property bool frame:true
    property bool tabsVisible: true
    property string position: "North"
    default property alias tabs : stack.children

    onCurrentChanged: __setOpacities()
    Component.onCompleted: __setOpacities()
    onTabbarChanged: {
        tabbar.tabFrame = tabWidget
        tabbar.anchors.top = tabWidget.top
        tabbar.anchors.left = tabWidget.left
        tabbar.anchors.right = tabWidget.right
    }

    property int __baseOverlap : style.pixelMetric("tabbaseoverlap");
    function __setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].opacity = (i == current ? 1 : 0)
        }
    }

    QStyleBackground {
        id: frame
        z:-1
        style: QStyleItem {
            id:style
            elementType: "tabframe"
            info: position
            value: tabbar && tabsVisible && tabbar.tab(current) ? tabbar.tab(current).x : 0
            minimum: tabbar && tabsVisible && tabbar.tab(current) ? tabbar.tab(current).width : 0
        }
        anchors.fill:parent
        Item {
            id:stack
            anchors.fill:parent
            anchors.margins: frame ? 2 : 0
        }
        anchors.topMargin: tabbar && tabsVisible && position == "North" ? tabbar.height - __baseOverlap : 0

        states: [
            State {
                name: "South"
                when: position == "South" && tabbar!= undefined
                PropertyChanges {
                    target: frame
                    anchors.topMargin: 0
                    anchors.bottomMargin: tabbar ? tabbar.height - __baseOverlap: 0
                }
                PropertyChanges {
                    target: tabbar
                    anchors.topMargin: -__baseOverlap
                }
                AnchorChanges {
                    target: tabbar
                    anchors.top: frame.bottom
                    anchors.bottom: undefined
                }
            }
        ]
    }
}
