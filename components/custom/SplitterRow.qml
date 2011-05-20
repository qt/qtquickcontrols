import QtQuick 1.0
import "private"

Item {
    id: root
    default property alias items: splitterItems.children
    property alias handles: splitterHandles.children
    property Component handleBackground: Rectangle { width:3; color: "black" }
    property int expandingIndex

    Component.onCompleted: init();
//    onItemsChanged: if (Component.Status == Component.Ready) updateItems();
    onWidthChanged: { updateExpandingIndex(); updateLayout(); }

    Component {
        id: handleBackgroundLoader
        Loader {
            id: loader
            property int handleIndex: 0
            property Item handleDragTarget: loader
            sourceComponent: handleBackground

            function handleDragged(handleIndex)
            {
                // Moving the handle means resizing an item. Which one,
                // left or right, depends on where the expanding item is.
                // 'updateLayout' will override in case new width violates max/min.
                updateExpandingIndex()

                // [leftHandle - leftItem - handle - rightItem - rightHandle]
                var leftHandle = handles[handleIndex-1]
                var leftItem = items[handleIndex]
                var handle = handles[handleIndex]
                var rightItem = items[handleIndex+1]
                var rightHandle = handles[handleIndex+1]
                var leftEdge = leftHandle ? (leftHandle.x + leftHandle.width) : 0
                var rightEdge = (rightHandle ? rightHandle.x : root.width)
                var expandingItem = items[expandingIndex]

                if (expandingIndex > handleIndex) {
                    // Resize item to the left.
                    // Ensure that the handle is not crossing other handles:
                    handle.x = Math.max(leftEdge, handle.x)
                    leftItem.width = handle.x - leftEdge
                    if (root.width != 0 && leftItem.percentageWidth != undefined && leftItem.percentageWidth !== -1)
                        leftItem.percentageWidth = leftItem.width * (100 / root.width)
                } else {
                    // Resize item to the right:
                    // Since the first item in the splitter always will have x=0, we need
                    // to ensure that the user cannot drag the handle more left than what
                    // we got space for:
                    var min = accumulatedWidth(0, handleIndex+1, true)
                    // Ensure that the handle is not crossing other handles:
                    handle.x = Math.max(min, Math.max(Math.min((rightEdge - handle.width), handle.x)))
                    rightItem.width = rightEdge - (handle.x + handle.width)
                    if (root.width != 0 && rightItem.percentageWidth != undefined && rightItem.percentageWidth !== -1)
                        rightItem.percentageWidth = rightItem.width * (100 / root.width)
                }
                updateLayout();
            }

        }
    }

    Item {
        id: splitterItems
        anchors.fill: parent
    }
    Item {
        id: splitterHandles
        anchors.fill: parent
    }

    function accumulatedWidth(firstIndex, lastIndex, includeExpandingMinimum)
    {
        // Go through items and handles, and
        // calculate their acummulated width.
        var w = 0
        for (var i=firstIndex; i<lastIndex; ++i) {
            var item = items[i]
            if (i !== expandingIndex)
                w += item.width;
            else if (includeExpandingMinimum && item.minimumWidth != undefined && item.minimumWidth != -1)
                w += item.minimumWidth
            if (handles[i] && (i !== expandingIndex || includeExpandingMinimum === false))
                w += handles[i].width
        }
        return w
    }

    function updateExpandingIndex()
    {
        for (var i=0; i<items.length; ++i) {
            var item = items[i]
            if (item.expanding && item.expanding === true) {
                expandingIndex = i
                return
            }
        }
        expandingIndex = i-1
    }

    function init()
    {
        for (var i=0; i<items.length-1; ++i) {
            // Anchor each item to fill out all space vertically:
            var item = items[i];
            item.anchors.top = splitterItems.top
            item.anchors.bottom = splitterItems.bottom
            // Create a handle for the item:
            var handle = handleBackgroundLoader.createObject(splitterHandles, {"handleIndex":i});
            handle.anchors.top = splitterHandles.top
            handle.anchors.bottom = splitterHandles.bottom
        }
        // Anchor the last item to fill out all space vertically as
        // well, since the for-loop skipped the last item:
        items[i].anchors.top = splitterItems.top
        items[i].anchors.bottom = splitterItems.bottom
    }

    function updateLayout()
    {
        // This function will reposition both handles and
        // items according to the _width of the each item_
        var item, prevItem
        var handle, prevHandle
        var newValue 

        // Ensure all items within min/max:
        for (var i=0; i<items.length; ++i) {
            if (i !== expandingIndex) {
                item = items[i];
                // Ensure item width is within its own max/min:
                if (item.percentageWidth != undefined && item.percentageWidth !== -1) {
                    newValue = item.percentageWidth * (root.width / 100)
                    if (newValue !== item.width)
                        item.width = newValue
                }
                if (item.maximumWidth != undefined && item.maximumWidth != -1) {
                    newValue = Math.min(item.width, item.maximumWidth)
                    if (newValue !== item.width)
                        item.width = newValue
                }
                if (item.minimumWidth != undefined && item.minimumWidth != -1) {
                    newValue = Math.max(item.width, item.minimumWidth)
                    if (newValue !== item.width)
                        item.width = newValue
                }
            }
        }

        // Special case: set width of expanding item to available space:

        newValue = root.width - accumulatedWidth(0, items.length, false);
        var expandingItem = items[expandingIndex]
        if (expandingItem.width !== newValue)
            expandingItem.width = newValue 

        // Then, position items and handles according to their width:
        for (i=0; i<items.length; ++i) {
            item = items[i];
            handle = handles[i]

            // Position item to the right of the previus handle:
            if (prevHandle) {
                newValue = prevHandle.x + prevHandle.width
                if (newValue !== item.x)
                    item.x = newValue
            }

            // Position handle to the right of item:
            if (handle) {
                newValue = item.x + Math.max(0, item.width)
                if (newValue !== handle.x)
                    handle.x = newValue
            }

            prevItem = item
            prevHandle = handle
        }
    }
}
