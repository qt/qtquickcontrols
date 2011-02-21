import QtQuick 1.0

MouseArea {
    id: popup
    // There is no global toplevel so we have to make one
    // We essentially reparent this item to the root item
    Component.onCompleted: {
        var p = parent;
        while (p.parent != undefined)
            p = p.parent
        parent = p;
    }

    anchors.fill: parent  // fill the while app area
    opacity: popupFrameLoader.item.opacity  // let the frame control opacity, so it can set the behavior

    property string behavior: popupFrameLoader.item && popupFrameLoader.item.behavior ? popupFrameLoader.item.behavior : "MacOS"
    property bool desktopBehavior: (behavior == "MacOS" || behavior == "Windows" || behavior == "Linux")
    property int previousCurrentIndex: -1   // set in state transition last in this file

    property alias model: listView.model
    property alias currentIndex: listView.currentIndex

    property Component listItem
    property Component listHighlight
    property Component popupFrame

    function togglePopup() { state = (state == "" ? "hidden" : "") }
    function setCurrentIndex(index) { listView.currentIndex = index; }
    function cancelSelection() { listView.currentIndex = previousCurrentIndex; }
    function closePopup() { state = "hidden" }

    function positionPopup() {
        switch(behavior) {
        case "MacOS":
            var mappedListPos = mapFromItem(choiceList, 0, 0);
            var itemHeight = Math.max(listView.contentHeight/listView.count, 0);
            var currentItemY = Math.max(currentIndex*itemHeight, 0);
            currentItemY += Math.floor(itemHeight/2 - choiceList.height/2);  // correct for choiceLists that are higher than items in the list

            listView.y = mappedListPos.y - currentItemY;
            listView.x = mappedListPos.x;

            listView.width = choiceList.width;
            listView.height = listView.contentHeight    //mm see QTBUG-16037

            if(listView.y < topMargin) {
                var excess = Math.floor(currentItemY - mappedListPos.y);
                listView.y = topMargin;
                listView.height += excess;
                listView.contentY = excess + topMargin;

                if(listView.contentY != excess+topMargin) //mm setting listView.height seems to make it worse
                    print("!!! ChoiceListPopup.qml: listView.contentY should be " + excess+topMargin + " but is " + listView.contentY)
            }

            if(listView.height+listView.contentY > listView.contentHeight) {
                listView.height = listView.contentHeight-listView.contentY;
            }

            if(listView.y+listView.height+bottomMargin > popup.height) {
                listView.height = popup.height-listView.y-bottomMargin;
            }
            break;
        case "Windows":
            var point = popup.mapFromItem(choiceList, 0, choiceList.height);
            listView.y = point.y;
            listView.x = point.x;

            listView.width = choiceList.width;
            listView.height = choiceList.contentHeight;
            listView.width = choiceList.width;
            listView.height = listView.contentHeight    //mm see QTBUG-16037

            if(listView.y < topMargin) {
                var excess = Math.floor(currentItemY - mappedListPos.y);
                listView.y = topMargin;
                listView.height += excess;
                listView.contentY = excess + topMargin;

                if(listView.contentY != excess+topMargin) //mm setting listView.height seems to make it worse
                    print("!!! ChoiceListPopup.qml: listView.contentY should be " + excess+topMargin + " but is " + listView.contentY)
            }

            if(listView.height+listView.contentY > listView.contentHeight) {
                listView.height = listView.contentHeight-listView.contentY;
            }

            if(listView.y+listView.height+bottomMargin > popup.height) {
                listView.height = popup.height-listView.y-bottomMargin;
            }

            break;
        case "MeeGo":
            break;
        }
    }

    Loader {
        id: popupFrameLoader
        property alias styledItem: popup.parent
        anchors.fill: listView
        anchors.leftMargin: -item.anchors.leftMargin
        anchors.rightMargin: -item.anchors.rightMargin
        anchors.topMargin: -item.anchors.topMargin
        anchors.bottomMargin: -item.anchors.bottomMargin
        sourceComponent: popupFrame
    }

    ListView {
        id: listView
        focus: true
        boundsBehavior: desktopBehavior ? ListView.StopAtBounds : ListView.DragOverBounds
        keyNavigationWraps: !desktopBehavior
        highlightFollowsCurrentItem: false  // explicitly handled below

        interactive: !desktopBehavior   // disable flicking. also disables key handling
        onCurrentItemChanged: {
            if(desktopBehavior) {
                positionViewAtIndex(currentIndex, ListView.Contain);
            }
        }

        property int highlightedIndex: -1
        onHighlightedIndexChanged: positionViewAtIndex(highlightedIndex, ListView.Contain)

        property variant highlightedItem: null
        onHighlightedItemChanged: {
            if(desktopBehavior) {
                positionHighlight();
            }
        }

        function positionHighlight() {
            if(!Qt.isQtObject(highlightItem))
                return;

            if(!Qt.isQtObject(highlightedItem)) {
                highlightItem.opacity = 0;  // hide when no item is highlighted
            } else {
                highlightItem.x = highlightedItem.x;
                highlightItem.y = highlightedItem.y;
                highlightItem.width = highlightedItem.width;
                highlightItem.height = highlightedItem.height;
                highlightItem.opacity = 1;  // show once positioned
            }
        }

        function hideHighlight() {
            highlightedIndex = -1;
            highlightedItem = null; // will trigger positionHighlight() what will hide the highlight
        }

        delegate: Item {
            id: itemDelegate
            width: delegateLoader.item.width
            height: delegateLoader.item.height
            property int theIndex: index    // for some reason the loader can't bind directly to the "index"

            Loader {
                id: delegateLoader
                property variant model: listView.model
                property alias index: itemDelegate.theIndex //mm Somehow the "model" gets through automagically, but not index
                property Item styledItem: choiceList
                property bool highlighted: theIndex == listView.highlightedIndex
                sourceComponent: listItem
                MouseArea { // handle list selection on mobile platforms
                    id:itemMouseArea
                    anchors.fill: parent
                    onClicked: { setCurrentIndex(index); closePopup(); }
                }
            }

            states: State {
                name: "highlighted"
                when: index == listView.highlightedIndex
                StateChangeScript {
                    script: {
                        if(Qt.isQtObject(listView.highlightedItem)) {
                            listView.highlightedItem.yChanged.disconnect(listView.positionHighlight);
                        }
                        listView.highlightedItem = itemDelegate;
                        listView.highlightedItem.yChanged.connect(listView.positionHighlight);
                    }
                }

            }
        }

        function firstVisibleItem() { return indexAt(contentX+10,contentY+10); }
        function lastVisibleItem() { return indexAt(contentX+width-10,contentY+height-10); }
        function itemsPerPage() { return lastVisibleItem() - firstVisibleItem(); }

        Keys.onPressed: {
            // with the ListView !interactive (non-flicking) we have to handle arrow keys
            if (event.key == Qt.Key_Up) {
                if(!highlightedItem) highlightedIndex = lastVisibleItem();
                else if(highlightedIndex > 0) highlightedIndex--;
            } else if (event.key == Qt.Key_Down) {
                if(!highlightedItem) highlightedIndex = firstVisibleItem();
                else if(highlightedIndex+1 < model.count) highlightedIndex++;
            } else if (event.key == Qt.Key_PageUp) {
                if(!highlightedItem) highlightedIndex = lastVisibleItem();
                else highlightedIndex = Math.max(highlightedIndex-itemsPerPage(), 0);
            } else if (event.key == Qt.Key_PageDown) {
                if(!highlightedItem) highlightedIndex = firstVisibleItem();
                else highlightedIndex = Math.min(highlightedIndex+itemsPerPage(), model.count-1);
            } else if (event.key == Qt.Key_Home) {
                highlightedIndex = 0;
            } else if (event.key == Qt.Key_End) {
                highlightedIndex = model.count-1;
            } else if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                if(highlightedIndex != -1) {
                    popup.setCurrentIndex(highlightedIndex);
                } else {
                    popup.cancelSelection();
                }

                popup.closePopup();
            } else if (event.key == Qt.Key_Escape) {
                popup.cancelSelection();
                popup.closePopup();
            }
            event.accepted = true;  // consume all keys while popout has focus
        }

        highlight: popup.listHighlight
    }

    enabled: (state != "hidden") // to avoid stray events when poput is about to close
    hoverEnabled: true
    onClicked: { popup.cancelSelection(); popup.closePopup(); } // clicked outside the list
    onPressed: {
        var mappedPos = mapToItem(listView.contentItem, mouse.x, mouse.y);
        var indexAt = listView.indexAt(mappedPos.x, mappedPos.y);
        if(indexAt != -1) {
            listView.currentIndex = indexAt;
        }
    }
    onPositionChanged: {
        var mappedPos = mapToItem(listView.contentItem, mouse.x, mouse.y);
        var indexAt = listView.indexAt(mappedPos.x, mappedPos.y);
        if(!pressed) {   // hovering
            if(indexAt == listView.highlightedIndex)
                return;

            if(indexAt >= 0) {
                listView.highlightedIndex = indexAt;
            } else {
                if(mouse.y > listView.y+listView.height && listView.highlightedIndex+1 < listView.count ) {
                    listView.highlightedIndex++;
                } else if(mouse.y < listView.y && listView.highlightedIndex > 0) {
                    listView.highlightedIndex--;
                } else if(mouse.x < popupFrameLoader.x || mouse.x > popupFrameLoader.x+popupFrameLoader.width) {
                    listView.hideHighlight();
                }
            }
        }
    }

    state: "hidden" // hidden by default
    states: [
        State {
            name: ""    // not hidden, i.e. showing
            PropertyChanges { target: popupFrameLoader.item; opacity: 1 }
        },
        State {
            name: "hidden"
            PropertyChanges { target: popupFrameLoader.item; opacity: 0 }
        }
    ]

    transitions: [
        Transition { to: "";
            ScriptAction {
                script: {
                    previousCurrentIndex = currentIndex;
                    positionPopup();
                    listView.forceActiveFocus();
                }
            }
        },
        Transition { to: "hidden"; ScriptAction { script: listView.hideHighlight(); } }
    ]
}




