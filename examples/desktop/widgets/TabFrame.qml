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
    property string position: "North"

    default property alias tabs : stack.children

    onTabbarChanged: {
        anchors.top = tabWidget.top
        tabbar.anchors.left=tabWidget.left
        tabbar.anchors.right=tabWidget.right
        tabbar.tabFrame = tabWidget
    }
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
            text: position
            value: tabbar && tabbar.tab(current) ? tabbar.tab(current).x : 0
            minimum: tabbar && tabbar.tab(current) ? tabbar.tab(current).width : 0
        }
        anchors.fill:parent
        Item {
            id:stack
            anchors.fill:parent
            anchors.margins: frame ? 2 : 0
        }
        anchors.topMargin: tabbar && position == "North" ? tabbar.height - __baseOverlap : 0
        states: [
            State {
                name: "South"
                when: position == "South"
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
