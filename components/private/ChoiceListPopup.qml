import Qt 4.7

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

    property string behavior: "MacOS"
    property bool desktopBehavior: (behavior == "MacOS" || behavior == "Windows" || behavior == "Linux")
    property int previousCurrentIndex: -1
    onOpacityChanged: {
        if(opacity == 1) // remember what current index was when the popup opened
            previousCurrentIndex = currentIndex;
    }

    property alias model: listView.model
    property alias currentIndex: listView.currentIndex
    onModelChanged: if(!model) currentIndex = -1;

    property Component listItem
    property Component listHighlight
    property Component popupFrame

    function togglePopup(choiceList) {
        positionPopup(choiceList);
        popupFrameLoader.item.opacity = popupFrameLoader.item.opacity ? 0 : 1
    }
    function setCurrentIndex(index) { listView.currentIndex = index; }
    function cancelSelection() { listView.currentIndex = previousCurrentIndex; }
    function closePopup() { popupFrameLoader.item.opacity = 0; }    

    property int itemHeight: 0  // set when an list delegate is created
    function positionPopup(choiceList) {
        switch(behavior) {
        case "MacOS":
            var mappedListPos = mapFromItem(choiceList, 0, 0);
            var currentItemY = Math.max(currentIndex*popup.itemHeight, 0);

            listView.y = mappedListPos.y - currentItemY;
            listView.x = mappedListPos.x;

            listView.width = choiceList.width;
            listView.height = listView.contentHeight

            if(listView.y < topMargin) {
                var excess = currentItemY - mappedListPos.y;
                listView.y = topMargin;
                listView.contentY = excess;
                listView.height += excess;

                if(listView.contentY != excess) //mm setting listView.height seems to make it worse
                    print("!!! ChoiceListPopup.qml: listView.contentY should be " + excess + " but is " + listView.contentY)
            }

            if(listView.height+listView.contentY > listView.contentHeight) {
                listView.height = listView.contentHeight-listView.contentY;
            }

            if(listView.y+listView.height+bottomMargin > popup.height) {
                listView.height = popup.height-listView.y-bottomMargin;
            }
            break;
        case "Windows":
            var point = popup.mapFromItem(choiceList, 0, listView.height);
            listView.y = point.y;
            listView.x = point.x;

            listView.width = choiceList.width;
            listView.height = 200;

            break;
        case "MeeGo":
            break;
        }
    }

    Loader {
        id: popupFrameLoader
        property alias styledItem: popup.parent

        anchors.fill: listView
        anchors.leftMargin: item.leftMargin ? item.leftMargin : -6
        anchors.rightMargin: item.rightMargin ? item.rightMargin : -6
        anchors.topMargin: item.topMargin ? item.topMargin : -6
        anchors.bottomMargin: item.bottomMargin ? item.bottomMargin : -6
        sourceComponent: popupFrame

        onLoaded: item.opacity = 0  // start off hidden
    }

    ListView {
        id: listView

        opacity: popupFrameLoader.item.opacity

        focus: true
        clip: true
        boundsBehavior: desktopBehavior ? ListView.StopAtBounds : ListView.DragOverBounds
        keyNavigationWraps: !desktopBehavior
        highlightFollowsCurrentItem: false  // explicitly handled below

        interactive: !desktopBehavior   // disable flicking. also disables key handling
        onCurrentItemChanged: {
            if(desktopBehavior) {
                positionViewAtIndex(currentIndex, ListView.Contain);
            }
        }

        property int highlightedIndex: 0
        onHighlightedIndexChanged: positionViewAtIndex(highlightedIndex, ListView.Contain)  //mm see QTBUG-15972

        property variant highlightedItem
        onHighlightedItemChanged: {
            if(desktopBehavior) {
                positionHighlight();
            }
        }

        onOpacityChanged: {                                     // when the popup is hidden,
            if(opacity == 0 && Qt.isQtObject(highlightItem)) {  // hide the highlight and don't show it
                highlightItem.opacity = 0;                      // again until positioned correctly (below)
            }
        }

        function positionHighlight() {
            if(!Qt.isQtObject(highlightItem) || !Qt.isQtObject(highlightItem))
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

            onHeightChanged: if(height > 0 && height != popup.itemHeight) popup.itemHeight = height;
            Loader {
                id: delegateLoader
                property alias index: itemDelegate.theIndex //mm Somehow the "model" gets through automagically, but not index
                property Item styledItem: choiceList
                sourceComponent: listItem
                MouseArea { // handle list selection on mobile platforms
//                    enabled: !desktopBehavior
                    anchors.fill: parent
//                    onPressed: listView.currentIndex = index;
                    onClicked: { listView.currentIndex = index; closePopup(); }
//                    onCanceled: popup.cancelSelection();
                }
            }

            states: State {
                name: "highlighted"
                when: index == listView.highlightedIndex
            }

            transitions: Transition {
                to: "highlighted"   // when an item becomes the highlighted one
                ScriptAction {
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

        Keys.onPressed: {
            // with the ListView !interactive (non-flicking) we have to handle arrow keys
            if (event.key == Qt.Key_Up) {
                if(highlightedIndex > 0) highlightedIndex--;
            } else if (event.key == Qt.Key_Down) {
                if(highlightedIndex+1 < model.count) highlightedIndex++;
            } else if (event.key == Qt.Key_PageUp) {
                highlightedIndex = Math.max(highlightedIndex-5, 0); //mm how to get actuall page size?
            } else if (event.key == Qt.Key_PageDown) {
                highlightedIndex = Math.min(highlightedIndex+5, model.count-1);
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
        }

        highlight: popup.listHighlight
    }

    hoverEnabled: true
    onClicked: { popup.cancelSelection(); popup.closePopup(); } // clicked outside the list
    onPressed: {
        var mappedPos = mapToItem(listView.contentItem, mouse.x, mouse.y);
        var indexAt = listView.indexAt(mappedPos.x, mappedPos.y);
        if( indexAt != -1) {
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

//                if(pressed) {
//                    if(indexAt == listView.currentIndex)
//                        return;

//                    if(indexAt >= 0) {
//                        listView.currentIndex = indexAt;
//                    } else {
//                        if(mouse.y+listView.contentY > listView.currentItem.y+listView.currentItem.height && listView.currentIndex+1 < listView.count ) {
//                            listView.currentIndex++;
//                        } else if(mouse.y+listView.contentY < listView.currentItem.y && listView.currentIndex > 0) {
//                            listView.currentIndex--;
//                        }
//                    }
//                }
    }
}




