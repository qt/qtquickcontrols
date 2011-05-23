import QtQuick 1.0
import "private"

Item {
    id: root
    default property alias items: splitterItems.children
    property alias handles: splitterHandles.children
    property Component handleBackground: Rectangle { width:3; color: "black" }

    Component.onCompleted: init();
    onWidthChanged: updateLayout();

    QtObject {
        id: d
        property int expandingIndex: items.length-1
        property bool updateOptimizationBlock: true
        property bool bindingRecursionGuard: false
    }

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
                // And 'updateLayout will be triggered when an item changes width.

                var leftHandle, leftItem, handle, rightItem, rightHandle
                var leftEdge, rightEdge, newWidth

                handle = handles[handleIndex]

                if (d.expandingIndex > handleIndex) {
                    // Resize item to the left.
                    // Ensure that the handle is not crossing other handles:
                    leftHandle = handles[handleIndex-1]
                    leftItem = items[handleIndex]
                    leftEdge = leftHandle ? (leftHandle.x + leftHandle.width) : 0
                    handle.x = Math.max(leftEdge, handle.x)
                    newWidth = handle.x - leftEdge
                    if (root.width != 0 && leftItem.percentageWidth != undefined && leftItem.percentageWidth !== -1)
                        leftItem.percentageWidth = newWidth * (100 / root.width)
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    leftItem.width = newWidth
                } else {
                    // Resize item to the right:
                    // Since the first item in the splitter always will have x=0, we need
                    // to ensure that the user cannot drag the handle more left than what
                    // we got space for:
                    var min = accumulatedWidth(0, handleIndex+1, true)
                    // Ensure that the handle is not crossing other handles:
                    rightItem = items[handleIndex+1]
                    rightHandle = handles[handleIndex+1]
                    rightEdge = (rightHandle ? rightHandle.x : root.width)
                    handle.x = Math.max(min, Math.max(Math.min((rightEdge - handle.width), handle.x)))
                    newWidth = rightEdge - (handle.x + handle.width)
                    if (root.width != 0 && rightItem.percentageWidth != undefined && rightItem.percentageWidth !== -1)
                        rightItem.percentageWidth = newWidth * (100 / root.width)
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    rightItem.width = newWidth
                }
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

    Component {
        // This dummy item is creates as a child of all
        // items it the splitter, just to provide a way
        // to listed for changes to their width (and then
        // do an updateLayout). In addition, it gives us
        // a way to listed for changes to 'expanding' as well.
        id: propertyChangeListener
        Item {
            id: target
            width: parent.width
            property bool expanding: (parent.expanding != undefined) ? parent.expanding : false
            property real percentageWidth: (parent.percentageWidth != undefined) ? parent.percentageWidth : -1
            property real minimumWidth: (parent.minimumWidth != undefined) ? parent.minimumWidth : -1
            property real maximumWidth: (parent.maximumWidth != undefined) ? parent.maximumWidth : -1

            onPercentageWidthChanged: updateLayout();
            onMinimumWidthChanged: updateLayout();
            onMaximumWidthChanged: updateLayout();

            onExpandingChanged: {
                // Find out which item that has the expanding flag:
                for (var i=0; i<items.length; ++i) {
                    var item = items[i]
                    if (item.expanding && item.expanding === true) {
                        d.expandingIndex = i
                        updateLayout();
                        return
                    }
                }
                d.expandingIndex = i-1
                updateLayout();
            }

            onWidthChanged: {
                // We need to update the layout:
                if (d.bindingRecursionGuard === true)
                    return
                d. bindingRecursionGuard = true

                // Break binding:
                width = 0
                updateLayout()
                // Restablish binding:
                width = function() { return parent.width; }
                
                d.bindingRecursionGuard = false
            }
        }
    }

    function init()
    {
        for (var i=0; i<items.length-1; ++i) {
            // Anchor each item to fill out all space vertically:
            var item = items[i];
            item.anchors.top = splitterItems.top
            item.anchors.bottom = splitterItems.bottom
            // Listen for changes to width and expanding:
            propertyChangeListener.createObject(item);
            // Create a handle for the item:
            var handle = handleBackgroundLoader.createObject(splitterHandles, {"handleIndex":i});
            handle.anchors.top = splitterHandles.top
            handle.anchors.bottom = splitterHandles.bottom
        }
        // Do the same for the last item as well, since
        // the for-loop skipped the last item:
        items[i].anchors.top = splitterItems.top
        items[i].anchors.bottom = splitterItems.bottom
        propertyChangeListener.createObject(items[i]);
        d.updateOptimizationBlock = false
        updateLayout()
    }

    function accumulatedWidth(firstIndex, lastIndex, includeExpandingMinimum)
    {
        // Go through items and handles, and
        // calculate their acummulated width.
        var w = 0
        for (var i=firstIndex; i<lastIndex; ++i) {
            var item = items[i]
            if (i !== d.expandingIndex)
                w += item.width;
            else if (includeExpandingMinimum && item.minimumWidth != undefined && item.minimumWidth != -1)
                w += item.minimumWidth
            if (handles[i] && (i !== d.expandingIndex || includeExpandingMinimum === false))
                w += handles[i].width
        }
        return w
    }

    function updateLayout()
    {
        if (d.updateOptimizationBlock === true)
            return
        d.updateOptimizationBlock = true

        // This function will reposition both handles and
        // items according to the _width of the each item_
        var item, prevItem
        var handle, prevHandle
        var newValue 

        // Ensure all items within min/max:
        for (var i=0; i<items.length; ++i) {
            if (i !== d.expandingIndex) {
                item = items[i];
                // If the item is using percentage width, convert
                // that number to real width now:
                if (item.percentageWidth != undefined && item.percentageWidth !== -1) {
                    newValue = item.percentageWidth * (root.width / 100)
                    if (newValue !== item.width)
                        item.width = newValue
                }
                // Ensure item width is not more than maximumWidth:
                if (item.maximumWidth != undefined && item.maximumWidth != -1) {
                    newValue = Math.min(item.width, item.maximumWidth)
                    if (newValue !== item.width)
                        item.width = newValue
                }
                // Ensure item width is not more less minimumWidth:
                if (item.minimumWidth != undefined && item.minimumWidth != -1) {
                    newValue = Math.max(item.width, item.minimumWidth)
                    if (newValue !== item.width)
                        item.width = newValue
                }
            }
        }

        // Special case: set width of expanding item to available space:
        newValue = root.width - accumulatedWidth(0, items.length, false);
        var expandingItem = items[d.expandingIndex]
        if (expandingItem.minimumWidth != undefined && expandingItem.minimumWidth != -1)
            newValue = Math.max(newValue, expandingItem.minimumWidth)
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

        d.updateOptimizationBlock = false
    }
}
