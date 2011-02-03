import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item{
    id: tabWidget
    width:100
    height:100

    property int current: 0
    property int count: stack.children.length
    default property alias content: stack.children

    property TabBar tabbar: TabBar{tabFrame:tabWidget; z:1}

    onCurrentChanged: __setOpacities()
    Component.onCompleted: __setOpacities()
    function __setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].opacity = (i == current ? 1 : 0)
        }
    }

    property int __baseHeight : style.pixelMetric("tabbaseheight");

    QStyleBackground {
        id: stack
        z:-1
        style: QStyleItem {
            id:style
            elementType: "tabframe"
            value: tabbar && tabbar.tab(current) ? tabbar.tab(current).x : 0
            minimum: tabbar && tabbar.tab(current)? tabbar.tab(current).width : 0
        }
        anchors.fill:parent
        anchors.topMargin: tabbar ? tabbar.height - __baseHeight + 1: 0
    }
}
