import Qt 4.7

Rectangle {
    id: popupBehavior

    property bool showing: false
    property Item popup
//    property variant globalPos

    // implementation
    anchors.fill: parent
    color: "red"
    opacity: 0.3

    property Item root: findRoot()
    function findRoot() {
        var p = parent;
        while(p.parent != undefined)
            p = p.parent;

        return p;
    }

    property variant popupPos
    Component.onCompleted: {
        popupPos = mapToItem(null, 0 ,0);
        popupPos.x += popup.x;
        popupPos.y += popup.y;
    }


    MouseArea {
        anchors.fill: parent
        onClicked: popupBehavior.showing = false
    }

    state: "hidden" // initially hidden
    states: [
        State {
            name: "showing"
            when: popupBehavior.showing
            ParentChange { target: popupBehavior; parent: root }
            PropertyChanges { target: popup; x: popupPos.x; y: popupPos.y }
        },
        State {
            name: "hidden"
            when: !popupBehavior.showing
            PropertyChanges { target: popupBehavior; opacity: 0 }
        }
    ]

}
