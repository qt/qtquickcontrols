import Qt 4.7

// KNOWN ISSUES
// 1) Screen is not redrawn correctly when popout is closed, see QTBUG-16180

Item {
    id: popupBehavior

    property bool showing: false
    property bool whenAlso: true    // modifier to the "showing" property
    property Item popup
    property Item positionBy
    property bool consumeCancelClick: true

    signal prepareToShow
    signal prepareToHide
    signal cancelledByClick

    function extendsOffTheTop() {
        var popupPos = popupBehavior.popupPos();
        return (popupPos.y < 0);
    }

    function extendsPastTheBottom() {
        var popupPos = popupBehavior.popupPos();
        return (popupPos.y > root.height-popup.height);
    }

    // implementation
    anchors.fill: parent

    onShowingChanged: notifyChange()
    onWhenAlsoChanged: notifyChange()
    function notifyChange() {
        if(state == "hidden" && (showing && whenAlso)) prepareToShow();
        if(state == "showing" && (!showing || !whenAlso)) prepareToHide();
    }

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
            mouse.accepted = consumeCancelClick;
            cancelledByClick();
        }
    }

    function popupPos() {   // making this a property doesn't work
        var popupPos = root.mapFromItem(positionBy, 0, 0);
        popupPos.x = Math.max(popupPos.x, 0);   // if outside to the left
        popupPos.x = Math.min(popupPos.x, root.width-popup.width); // if outside to the right
        return popupPos;
    }

    states: [
        State {
            name: "showing"
            when: popupBehavior.showing && popupBehavior.whenAlso
            ParentChange { target: popupBehavior; parent: root }
            PropertyChanges { target: popup; x: popupPos().x; y: popupPos().y }
        },
        State {
            name: "hidden"
            when: !popupBehavior.showing || !popupBehavior.whenAlso
            PropertyChanges { target: popupBehavior; opacity: 0 }
        }
    ]
}

