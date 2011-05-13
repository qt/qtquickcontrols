import QtQuick 1.0

Row {
    id: root
    Component.onCompleted: resizeChildren();
    onChildrenChanged: if (Component.Status == Component.Ready) resizeChildren();

    function resizeChildren() {
        for (var i=0, c; (c = children[i]); ++i) {
            c.anchors.top = root.top
            c.anchors.bottom = root.bottom
        }
    }
}
