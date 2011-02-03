import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Item{
    id: tabWidget
    width:100
    height:100

    property int current: 0
    default property alias content: stack.children

    property TabBar tabbar: TabBar{tabs:tabWidget}

    onCurrentChanged: __setOpacities()
    Component.onCompleted: __setOpacities()

    function __setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].opacity = (i == current ? 1 : 0)
        }
    }

    QStyleBackground {
        id: stack
        anchors.fill:parent
        anchors.topMargin:14
        style: QStyleItem {
            elementType: "tabframe"
            value: tabbar ? tabbar.children[current].x : 0
            minimum: tabbar ? tabbar.children[current].width : 0
        }
        width: tabWidget.width
        y: tabbar ? tabbar.height : 0
        anchors.bottom: tabWidget.bottom
    }
}
