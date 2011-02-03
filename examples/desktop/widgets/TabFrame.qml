import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item{
    id: tabWidget
    width:100
    height:100

    property TabBar tabbar
    property int current: 0
    property int count: stack.children.length
    property bool frame:true
    default property alias tabs : stack.children

    onTabbarChanged:tabbar.tabFrame = tabWidget
    onCurrentChanged: __setOpacities()
    Component.onCompleted: __setOpacities()

    function __setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].opacity = (i == current ? 1 : 0)
        }
    }

    property int __baseOverlap : style.pixelMetric("tabbaseoverlap");

    QStyleBackground {
        id: frame
        z:-1
        style: QStyleItem {
            id:style
            elementType: "tabframe"
            value: tabbar && tabbar.tab(current) ? tabbar.tab(current).x : 0
            minimum: tabbar && tabbar.tab(current)? tabbar.tab(current).width : 0
        }
        anchors.fill:parent
        Item {
            id:stack
            anchors.fill:parent
            anchors.margins: frame ? 2 : 0
        }
        anchors.topMargin: (tabbar ? tabbar.height - __baseOverlap: 0)
    }
}
