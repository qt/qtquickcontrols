import QtQuick 1.0
import "private"

/*
*
* SplitterRow
*
* SplitterRow is a component that provides a way to layout items horisontally with
* a draggable splitter added in-between each item.
*
* Add items to the SplitterRow by inserting them as child items. The splitter handle
* is outsourced as a delegate (handleBackground). To enable the user to drag the handle,
* it will need to contain a mouse area that communicates with the SplitterRow by binding
* 'drag.target: handle'. The 'handle' property points to the handle item that embedds
* the delegate. To change handle positions, either change 'x' (or 'width') of 'handle', or
* change the width of the child items inside the SplitterRow.
*
* The SplitterRow contains the following API:
*
* Component handleBackground - delegate that will be instanciated between each
*   child item. Inside the delegate, the following properties are available:
*   int handleIndex - specifies the index of the splitter handle. The handle
*       between the first and the second item will get index 0, the next handle index 1 etc.
*   Item handle - convenience property that points to the item where the handle delegate is
*       placed. Identical to splitterRow.handles[handleIndex]. Modify 'handle.x' to move the
*       handle (or change 'width' of SplitterRow child items).
*   Item splitterRow - points to the SplitterRow that the handle is in.
* List<Item> items - contains the list of child items in the SplitterRow. Currently read-only.
* List<Item> handles - contains the list of handles in the SplitterRow. Read-only.
*
* The following properties can optionally be added for each child item of SplitterRow:
*
* real minimumWidth - ensures that the item cannot be resized below the
*   given value. A value of -1 will disable it.
* real maximumWidth - ensures that the item cannot be resized above the
*   given value. A value of -1 will disable it.
* real percentageWidth - This value specifies a percentage (0 - 100) of the width of the
*   SplitterRow width. If the width of the SplitterRow change, the width of the item will
*   change as well. 'percentageWidth' have precedence over 'width', which means that
*   SplitterRow will ignore any assignments to 'width'. A value of -1 disables it.
* bool expanding - if present, the item will consume all extra space in the SplitterRow, down to
*   minimumWidth. This means that that 'width', 'percentageWidth' and 'maximumWidth' will be ignored.
*   There will always be one (and only one) item in the SplitterRow that has this behaviour, and by
*   default, it will be the last child item of the SplitterRow. Also note that which item that gets
*   resized upon dragging a handle depends on whether the expanding item is located towards the left
*   or the right of the handle.
* int itemIndex - will be assigned a read-only value with the item index. Can be used to e.g. look-up
*   the handles sourrounding the item (parent.handles[itemIndex])
*
* Example:
*
* To create a SplitterRow with three items, and let
* the center item be the one that should be expanding, one
* could do the following:
*
*    SplitterRow {
*        anchors.fill: parent
*
*        handleBackground: Rectangle {
*            width: 1
*            color: "black"
*
*            MouseArea {
*                anchors.fill: parent
*                anchors.leftMargin: -2
*                anchors.rightMargin: -2
*                drag.axis: Qt.YAxis
*                drag.target: handle
*            }
*        }
*
*        Rectangle {
*            color: "gray"
*            width: 200
*        }
*        Rectangle {
*            property real minimumWidth: 50
*            property real maximumWidth: 400
*            property bool expanding: true
*            color: "darkgray"
*        }
*        Rectangle {
*            color: "gray"
*            width: 200
*        }
*    }
*/

Item {
    id: root
    default property alias items: splitterItems.children
    property alias handles: splitterHandles.children
    property Component handleBackground: Rectangle { width:3; color: "black" }
    property bool restrictHandlePositions: false
    clip: true

    Component.onCompleted: d.init();
    onWidthChanged: d.updateLayout();

    QtObject {
        id: d
        property int expandingIndex: -1
        property bool updateLayoutGuard: true
        property bool itemWidthGuard: false
        property bool itemExpandingGuard: true

        function init()
        {
            for (var i=0; i<items.length; ++i) {
                var item = items[i];
                if (item.itemIndex != undefined)
                    item.itemIndex = i
                // Assign one, and only one, item to be expanding:
                if (item.expanding != undefined && item.expanding === true) {
                    if (d.expandingIndex === -1)
                        d.expandingIndex = i
                    else
                        item.expanding = false
                }
                // Anchor each item to fill out all space vertically:
                item.anchors.top = splitterItems.top
                item.anchors.bottom = splitterItems.bottom
                // Listen for changes to width and expanding:
                propertyChangeListener.createObject(item, {"itemIndex":i});
                if (i < items.length-1) {
                    // Create a handle for the item, unless its the last:
                    var handle = handleBackgroundLoader.createObject(splitterHandles, {"handleIndex":i});
                    handle.anchors.top = splitterHandles.top
                    handle.anchors.bottom = splitterHandles.bottom
                }
            }

            if (d.expandingIndex === -1) {
                // No item had expanding set to true.
                d.expandingIndex = items.length - 1
                if (item.expanding != undefined)
                    item.expanding = true
            }

            d.itemExpandingGuard = false
            d.updateLayoutGuard = false
            d.updateLayout()
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
                if (handles[i])
                    w += handles[i].width
            }
            return w
        }

        function updateLayout()
        {
            if (items.length === 0)
                return;
            if (d.updateLayoutGuard === true)
                return
            d.updateLayoutGuard = true

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
            newValue = root.width - d.accumulatedWidth(0, items.length, false);
            var expandingItem = items[d.expandingIndex]
            if (expandingItem.minimumWidth != undefined && expandingItem.minimumWidth != -1)
                newValue = Math.max(newValue, expandingItem.minimumWidth)
            if (expandingItem.width != 0 && expandingItem.percentageWidth != undefined && expandingItem.percentageWidth !== -1)
                expandingItem.percentageWidth = newValue * (100 / root.width)
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

            d.updateLayoutGuard = false
        }
    }

    Component {
        id: handleBackgroundLoader
        Loader {
            id: myHandle
            property int handleIndex: 0
            property Item handle: myHandle
             // 'splitterRow' should be an alias, but that fails to resolve runtime:
            property Item splitterRow: root

            sourceComponent: handleBackground
            onWidthChanged: d.updateLayout()

            onXChanged: {
                // Moving the handle means resizing an item. Which one,
                // left or right, depends on where the expanding item is.
                // 'updateLayout' will override in case new width violates max/min.
                // And 'updateLayout will be triggered when an item changes width.
                if (d.updateLayoutGuard)
                    return

                var leftHandle, leftItem, rightItem, rightHandle
                var leftEdge, rightEdge, newWidth, leftStopX, rightStopX

                if (d.expandingIndex > handleIndex) {
                    // Resize item to the left.
                    // Ensure that the handle is not crossing other handles:
                    leftHandle = handles[handleIndex-1]
                    leftItem = items[handleIndex]
                    leftEdge = leftHandle ? (leftHandle.x + leftHandle.width) : 0

                    // Ensure: leftStopX >= myHandle.x >= rightStopX
                    var min = d.accumulatedWidth(handleIndex+1, items.length, true)
                    rightStopX = root.width - min - myHandle.width
                    leftStopX = Math.max(leftEdge, myHandle.x)
                    if (root.restrictHandlePositions)
                        myHandle.x = Math.min(rightStopX, Math.max(leftStopX, myHandle.x))
                    else
                        myHandle.x = Math.max(leftStopX, myHandle.x)

                    newWidth = myHandle.x - leftEdge
                    if (root.width != 0 && leftItem.percentageWidth != undefined && leftItem.percentageWidth !== -1)
                        leftItem.percentageWidth = newWidth * (100 / root.width)
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    leftItem.width = newWidth
                } else {
                    // Resize item to the right.
                    // Ensure that the handle is not crossing other handles:
                    rightItem = items[handleIndex+1]
                    rightHandle = handles[handleIndex+1]
                    rightEdge = (rightHandle ? rightHandle.x : root.width)

                    // Ensure: leftStopX <= myHandle.x <= rightStopX
                    var min = d.accumulatedWidth(0, handleIndex+1, true)
                    leftStopX = min - myHandle.width
                    rightStopX = Math.min((rightEdge - myHandle.width), myHandle.x)
                    if (restrictHandlePositions)
                        myHandle.x = Math.max(leftStopX, Math.min(myHandle.x, rightStopX))
                    else
                        myHandle.x = Math.min(myHandle.x, rightStopX)

                    newWidth = rightEdge - (myHandle.x + myHandle.width)
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
        // This dummy item becomes a child of all
        // items it the splitter, just to provide a way
        // to listed for changes to their width, expanding etc.
        id: propertyChangeListener
        Item {
            id: target
            width: parent.width
            property bool expanding: (parent.expanding != undefined) ? parent.expanding : false
            property real percentageWidth: (parent.percentageWidth != undefined) ? parent.percentageWidth : -1
            property real minimumWidth: (parent.minimumWidth != undefined) ? parent.minimumWidth : -1
            property real maximumWidth: (parent.maximumWidth != undefined) ? parent.maximumWidth : -1
            property int itemIndex: 0

            onPercentageWidthChanged: d.updateLayout();
            onMinimumWidthChanged: d.updateLayout();
            onMaximumWidthChanged: d.updateLayout();

            onExpandingChanged: {
                if (d.itemExpandingGuard === true)
                    return
                d.itemExpandingGuard = true
                // break binding:
                expanding = false

                // 'expanding' follows radio button behavior:
                // First, find the new expanding item:
                var newIndex = items.length-1
                for (var i=0; i<items.length; ++i) {
                    var item = items[i]
                    if (i !== d.expandingIndex && item.expanding != undefined && item.expanding === true) {
                        newIndex = i
                        break
                    }
                }
                // Tell the found item that it is expanding:
                item = items[newIndex]
                if (item.expanding != undefined && item.expanding !== true)
                    item.expanding = true
                // ...and the old one that it is not:
                if (newIndex !== d.expandingIndex) {
                    item = items[d.expandingIndex]
                    if (item.expanding != undefined && item.expanding !== false)
                        item.expanding = false
                }
                // update index:
                d.expandingIndex = newIndex
                d.updateLayout();
                // recreate binding:
                expanding = function() { return (parent.expanding != undefined) ? parent.expanding : false; }
                d.itemExpandingGuard = false
            }

            onWidthChanged: {
                // We need to update the layout:
                if (d.itemWidthGuard === true)
                    return
                d.itemWidthGuard = true

                // Break binding:
                width = 0
                d.updateLayout()
                // Restablish binding:
                width = function() { return parent.width; }
                
                d.itemWidthGuard = false
            }
        }
    }
}
