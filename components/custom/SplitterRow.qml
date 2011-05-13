import QtQuick 1.0
import "private"

Rectangle {
    id: root
    color: "lightgrey"
    default property alias items: contents.children
    property Component splitter: Rectangle { color: "black" }

    Component.onCompleted: updateItems();
    onItemsChanged: if (Component.Status == Component.Ready) updateItems();

    Component {
        id: splitterMouseArea
        MouseArea {
            anchors.fill: parent
            drag.target: parent
            onPressed: console.debug("mouse pressed")
        }
    }

    function addSplitters()
    {
        for (var i=0; i<items.length-1; ++i) {
            var s = splitter.createObject(root);
            s.anchors.top = contents.top
            s.anchors.bottom = contents.bottom
            s.width = 10
            splitterMouseArea.createObject(s);
        }
    }

    function updateItems()
    {
        if (items.length === 0)
            return;

        addSplitters();

        var last = items[items.length-1]
        last.anchors.right = contents.right

        for (var i=0, item, prevItem; (item = items[i]); i+=2) {
            item.anchors.top = contents.top
            item.anchors.bottom = contents.bottom
            item.anchors.left = prevItem ? prevItem.right : contents.left
            prevItem = item
        }
    }

    Item {
        id: contents
        anchors.fill: parent
    }
}
