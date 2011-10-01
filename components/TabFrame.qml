import QtQuick 1.1
import "custom" as Components

Item {
    id: tabWidget
    width: 100
    height: 100
    property int current: 0
    property int count: stack.children.length
    property bool frame: true
    property bool tabsVisible: true
    property string position: "North"
    default property alias tabs : stack.children
    property Item tabBar: tabbarItem

    onCurrentChanged: __setOpacities()
    Component.onCompleted: __setOpacities()

    property int __baseOverlap : frameitem.pixelMetric("tabbaseoverlap")// add paintmargins;
    function __setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].visible = (i == current ? true : false)
        }
    }

    Component {
        id: tabcomp
        Tab {}
    }

    function addTab(component, title) {
        var tab = tabcomp.createObject(this);
        component.createObject(tab)
        tab.parent = stack
        tab.title = title
        __setOpacities()
        return tab
    }

    function removeTab(id) {
        var tab = tabs[id]
        tab.destroy()
        if (current > 0)
            current-=1
    }

    StyleItem {
        id: frameitem
        z: style == "oxygen" ? 1 : 0
        elementType: "tabframe"
        info: position
        value: tabbarItem && tabsVisible && tabbarItem.tab(current) ? tabbarItem.tab(current).x : 0
        minimum: tabbarItem && tabsVisible && tabbarItem.tab(current) ? tabbarItem.tab(current).width : 0
        maximum: tabbarItem && tabsVisible ? tabbarItem.tabWidth : width
        anchors.fill: parent

        property int frameWidth: pixelMetric("defaultframewidth")

        Item {
            id: stack
            anchors.fill: parent
            anchors.margins: (frame ? frameitem.frameWidth : 0)
            anchors.topMargin: anchors.margins + (frameitem.style =="mac" ? 6 : 0)
            anchors.bottomMargin: anchors.margins + (frameitem.style =="mac" ? 6 : 0)
        }

        anchors.topMargin: tabbarItem && tabsVisible && position == "North" ? Math.max(0, tabbarItem.height - __baseOverlap) : 0

        states: [
            State {
                name: "South"
                when: position == "South" && tabbarItem!= undefined
                PropertyChanges {
                    target: frameitem
                    anchors.topMargin: 0
                    anchors.bottomMargin: tabbarItem ? tabbarItem.height - __baseOverlap: 0
                }
                PropertyChanges {
                    target: tabbarItem
                    anchors.topMargin: -__baseOverlap
                }
                AnchorChanges {
                    target: tabbarItem
                    anchors.top: frameitem.bottom
                    anchors.bottom: undefined
                }
            }
        ]
    }
    TabBar {
        id: tabbarItem
        tabFrame: tabWidget
        anchors.top: tabWidget.top
        anchors.left: tabWidget.left
        anchors.right: tabWidget.right
    }
}
