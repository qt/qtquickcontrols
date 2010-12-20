import Qt 4.7

// KNOWN ISSUES
// 1) Screen is not redrawn correctly when popout is closed, see QTBUG-16180

Item {
    id: popupBehavior

    property bool showing: false
    property Item popup
    property Item positionBy

    // implementation
    anchors.fill: parent

    property Item root: findRoot()
    function findRoot() {
        var p = parent;
        while(p.parent != undefined)
            p = p.parent;

        return p;
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            popupBehavior.showing = false;
            mouse.accepted = false;
        }
    }

    function popupPos() {   // making this a property doesn't work
        return mapFromItem(positionBy, 0, 0);
    }

    states: [
        State {
            name: "showing"
            when: popupBehavior.showing
            ParentChange { target: popupBehavior; parent: root }
            PropertyChanges { target: popup; x: popupPos().x; y: popupPos().y }
        },
        State {
            name: "hidden"
            when: !popupBehavior.showing
            PropertyChanges { target: popupBehavior; opacity: 0 }
        }
    ]
}
