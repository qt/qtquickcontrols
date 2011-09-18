import QtQuick 1.1
import "private"

/*
*
* SplitterColumn
*
* SplitterColumn is a component that provides a way to layout items horisontally with
* a draggable splitter added in-between each item.
*
* Add items to the SplitterColumn by inserting them as child items. The splitter handle
* is outsourced as a delegate (handleBackground). To enable the user to drag the handle,
* it will need to contain a mouse area that communicates with the SplitterColumn by binding
* 'drag.target: handle'. The 'handle' property points to the handle item that embedds
* the delegate. To change handle positions, either change 'x' (or 'height') of 'handle', or
* change the height of the child items inside the SplitterColumn. If you set the visibility
* of a child item to false, the corresponding handle will also be hidden, and the
* SplitterColumn will perform a layout update to fill up available space.
*
* There will always be one (and only one) item in the SplitterColumn that is 'expanding'.
* The expanding item is the child that will get all the remaining space in the SplitterColumn
* (down to its own mimimumSize) when all other items have been layed out.
* This means that that 'height', 'percentageHeight' and 'maximumHeight' will be ignored for this item.
* By default, the last visible child item of the SplitterColumn will be 'expanding'.
*
* A handle can belong to the item on the left side, or the right side, of the handle. Which one depends
* on the expaning item. If the expanding item is to the right of the handle, the
* handle will belong to the item on the left. If it is to the left, it will belong to the item on the
* right. This will again control which item that gets resized when the user drags a handle, and which
* handle that gets hidden when an item is told to hide.
*
* NB: Since SplitterColumn might modify geometry properties like 'height' and 'x' of child items
* to e.g. ensure they stay within minimumHeight/maximumHeight, explicit expression bindings
* to such properties can easily be broken up by the SplitterColumn, and is not recommended.
*
* The SplitterColumn contains the following API:
*
* Component handleBackground - delegate that will be instanciated between each
*   child item. Inside the delegate, the following properties are available:
*   int handleIndex - specifies the index of the splitter handle. The handle
*       between the first and the second item will get index 0, the next handle index 1 etc.
*   Item handle - convenience property that points to the item where the handle background is
*       instanciated as a child. Identical to splitterRow.handles[handleIndex]. The handle
*       background iteself can be accessed through handle.item.
*       Modify 'handle.y' to move the handle (or change 'height' of SplitterColumn child items).
*   Item splitterItem - convenience property that points to the child item that the handle controls.
*       Also refer to information about the expanding item above.
*   Item splitterRow - points to the SplitterColumn that the handle is in.
* List<Item> items - contains the list of child items in the SplitterColumn. Currently read-only.
* List<Item> handles - contains the list of splitter handles in the SplitterColumn. Note that this list will
*   be populated after all child items has completed, so accessing it from Component.onCompleted
*   inside a SplitterColumn child item will not work.  To get to the handle background, access the
*   'background' property of the handle, e.g. handles[0].background. Read-only.
* real preferredHeight - contains the accumulated with of all child items and handles, except
*   the expanding item. If the expanding item has a minimum height, the minimum height will
*   be included.
*
* The following properties can optionally be added for each child item of SplitterColumn:
*
* real minimumHeight - ensures that the item cannot be resized below the
*   given value. A value of -1 will disable it.
* real maximumHeight - ensures that the item cannot be resized above the
*   given value. A value of -1 will disable it.
* real percentageHeight - This value specifies a percentage (0 - 100) of the height of the
*   SplitterColumn height. If the height of the SplitterColumn change, the height of the item will
*   change as well. 'percentageHeight' have precedence over 'height', which means that
*   SplitterColumn will ignore any assignments to 'height'. A value of -1 disables it.
* bool expanding - See explanation of 'expanding' above. If set to true, the current item
*   will be the expanding item in the SplitterColumn. If set to false, the SplitterColumn will
*   autmatically choose the last visible child of the SplitterColumn as expanding instead.
* int itemIndex - will be assigned a read-only value with the item index. Can be used to e.g. look-up
*   the handles sourrounding the item (parent.handles[itemIndex])
*
* Example:
*
* To create a SplitterColumn with three items, and let
* the center item be the one that should be expanding, one
* could do the following:
*
*    SplitterColumn {
*           .fill: parent
*
*        handleBackground: Rectangle {
*            height: 1
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
*            property real maximumHeight: 400
*            color: "gray"
*            height: 200
*        }
*        Rectangle {
*            property real minimumHeight: 50
*            property bool expanding: true
*            color: "darkgray"
*        }
*        Rectangle {
*            color: "gray"
*            height: 200
*        }
*    }
*/

Item {
    id: root
    default property alias items: splitterItems.children
    property alias handles: splitterHandles.children
    property Component handleBackground: Rectangle { height:3; color: "black" }
    property real preferredHeight: 0
    clip: true

    Component.onCompleted: d.init();
    onHeightChanged: d.updateLayout();

    QtObject {
        id: d
        property int expandingIndex: -1
        property bool updateLayoutGuard: true
        property bool itemHeightGuard: false
        property bool itemExpandingGuard: true

        function init()
        {
            for (var i=0; i<items.length; ++i) {
                var item = items[i];
                // If the item has an 'itemIndex' defined, assign it a value:
                if (item.itemIndex != undefined)
                    item.itemIndex = i

                // Assign one, and only one, item to be expanding:
                if (item.expanding != undefined && item.expanding === true) {
                    if (d.expandingIndex === -1 && item.visible === true)
                        d.expandingIndex = i
                    else
                        item.expanding = false
                }

                // Anchor each item to fill out all space vertically:
                item.anchors.left = splitterItems.left
                item.anchors.right = splitterItems.right

                // Listen for changes to height and expanding:
                propertyChangeListener.createObject(item, {"itemIndex":i});
                if (i < items.length-1) {
                    // Create a handle for the item, unless its the last:
                    var handle = handleBackgroundLoader.createObject(splitterHandles, {"handleIndex":i});

                    handle.anchors.left = splitterHandles.left
                    handle.anchors.right = splitterHandles.right
                }
            }

            if (d.expandingIndex === -1) {
                // INVARIANT: No item was set as expanding.
                // We then choose the last visible item instead:
                d.expandingIndex = items.length - 1
                for (i=items.length-1; i>=0; --i) {
                    var item = items[i]
                    if (item.visible === true) {
                        d.expandingIndex = i
                        item = items[i]
                        break
                    }
                }
                if (item.expanding != undefined)
                    item.expanding = true
            }

            d.itemExpandingGuard = false
            d.updateLayoutGuard = false
            d.updateLayout()
        }

        function accumulatedHeight(firstIndex, lastIndex, includeExpandingMinimum)
        {
            // Go through items and handles, and
            // calculate their acummulated height.
            var w = 0
            for (var i=firstIndex; i<lastIndex; ++i) {
                var item = items[i]
                if (item.visible) {
                    if (i !== d.expandingIndex)
                        w += item.height;
                    else if (includeExpandingMinimum && item.minimumHeight != undefined && item.minimumHeight != -1)
                        w += item.minimumHeight
                }

                var handle = handles[i]
                if (handle && items[i + ((d.expandingIndex > i) ? 0 : 1)].visible)
                    w += handle.height
            }
            return w
        }

        function updateLayout()
        {
            // This function will reposition both handles and
            // items according to the _height of the each item_
            if (items.length === 0)
                return;
            if (d.updateLayoutGuard === true)
                return
            d.updateLayoutGuard = true

            // Use a temporary variable to store values to avoid breaking
            // property bindings when the value does not actually change:
            var newValue

            // Ensure all items within min/max:
            for (var i=0; i<items.length; ++i) {
                if (i !== d.expandingIndex) {
                    item = items[i];
                    // If the item is using percentage height, convert
                    // that number to real height now:
                    if (item.percentageHeight != undefined && item.percentageHeight !== -1) {
                        newValue = item.percentageHeight * (root.height / 100)
                        if (newValue !== item.height)
                            item.height = newValue
                    }
                    // Ensure item height is not more than maximumHeight:
                    if (item.maximumHeight != undefined && item.maximumHeight != -1) {
                        newValue = Math.min(item.height, item.maximumHeight)
                        if (newValue !== item.height)
                            item.height = newValue
                    }
                    // Ensure item height is not more less minimumHeight:
                    if (item.minimumHeight != undefined && item.minimumHeight != -1) {
                        newValue = Math.max(item.height, item.minimumHeight)
                        if (newValue !== item.height)
                            item.height = newValue
                    }
                }
            }

            // Special case: set height of expanding item to available space:
            newValue = root.height - d.accumulatedHeight(0, items.length, false);
            var expandingItem = items[d.expandingIndex]
            var expandingMinimum = 0
            if (expandingItem.minimumHeight != undefined && expandingItem.minimumHeight != -1)
                expandingMinimum = expandingItem.minimumHeight
            newValue = Math.max(newValue, expandingMinimum)
            if (expandingItem.height != 0 && expandingItem.percentageHeight != undefined && expandingItem.percentageHeight !== -1)
                expandingItem.percentageHeight = newValue * (100 / root.height)
            if (expandingItem.height !== newValue)
                expandingItem.height = newValue

            // Then, position items and handles according to their height:
            var item, lastVisibleItem
            var handle, lastVisibleHandle
            var newPreferredHeight = expandingMinimum - expandingItem.height

            for (i=0; i<items.length; ++i) {
                // Position item to the right of the previous visible handle:
                item = items[i];
                if (item.visible) {
                    if (lastVisibleHandle) {
                        newValue = lastVisibleHandle.y + lastVisibleHandle.height
                        if (newValue !== item.y)
                            item.y = newValue
                    } else {
                        newValue = 0
                        if (newValue !== item.y)
                            item.y = newValue
                    }
                    newPreferredHeight += item.height
                    lastVisibleItem = item
                }

                // Position handle to the right of the previous visible item. We use an alterative way of
                // checking handle visibility because that property might not have updated correctly yet:
                handle = handles[i]
                if (handle && items[i + ((d.expandingIndex > i) ? 0 : 1)].visible) {
                    newValue = lastVisibleItem.y + Math.max(0, lastVisibleItem.height)
                    if (newValue !== handle.y)
                        handle.y = newValue
                    newPreferredHeight += handle.height
                    lastVisibleHandle = handle
                }
            }

            root.preferredHeight = newPreferredHeight
            d.updateLayoutGuard = false
        }
    }

    Component {
        id: handleBackgroundLoader
        Loader {
            id: myHandle
            property int handleIndex: 0
            property Item handle: myHandle
            property Item splitterItem: items[handleIndex + ((d.expandingIndex > handleIndex) ? 0 : 1)]

             // 'splitterRow' should be an alias, but that fails to resolve runtime:
            property Item splitterRow: root
            property Item background: item

            visible: splitterItem.visible
            sourceComponent: handleBackground
            onHeightChanged: d.updateLayout()

            onYChanged: {
                // Moving the handle means resizing an item. Which one,
                // left or right, depends on where the expanding item is.
                // 'updateLayout' will override in case new height violates max/min.
                // And 'updateLayout will be triggered when an item changes height.
                if (d.updateLayoutGuard)
                    return

                var leftHandle, leftItem, rightItem, rightHandle
                var leftEdge, rightEdge, newHeight, leftStopX, rightStopX
                var i

                if (d.expandingIndex > handleIndex) {
                    // Resize item to the left.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the left to determine the left edge:
                    leftEdge = 0
                    for (i=handleIndex-1; i>=0; --i) {
                        leftHandle = handles[i]
                        if (leftHandle.visible) {
                            leftEdge = leftHandle.y + leftHandle.height
                            break;
                        }
                    }

                    // Ensure: leftStopX >= myHandle.y >= rightStopX
                    var min = d.accumulatedHeight(handleIndex+1, items.length, true)
                    rightStopX = root.height - min - myHandle.height
                    leftStopX = Math.max(leftEdge, myHandle.y)
                    myHandle.y = Math.min(rightStopX, Math.max(leftStopX, myHandle.y))

                    newHeight = myHandle.y - leftEdge
                    leftItem = items[handleIndex]
                    if (root.height != 0 && leftItem.percentageHeight != undefined && leftItem.percentageHeight !== -1)
                        leftItem.percentageHeight = newHeight * (100 / root.height)
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    leftItem.height = newHeight
                } else {
                    // Resize item to the right.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the right to determine the right edge:
                    rightEdge = root.height
                    for (i=handleIndex+1; i<handles.length; ++i) {
                        rightHandle = handles[i]
                        if (rightHandle.visible) {
                            rightEdge = rightHandle.y
                            break;
                        }
                    }

                    // Ensure: leftStopX <= myHandle.y <= rightStopX
                    var min = d.accumulatedHeight(0, handleIndex+1, true)
                    leftStopX = min - myHandle.height
                    rightStopX = Math.min((rightEdge - myHandle.height), myHandle.y)
                    myHandle.y = Math.max(leftStopX, Math.min(myHandle.y, rightStopX))

                    newHeight = rightEdge - (myHandle.y + myHandle.height)
                    rightItem = items[handleIndex+1]
                    if (root.height != 0 && rightItem.percentageHeight != undefined && rightItem.percentageHeight !== -1)
                        rightItem.percentageHeight = newHeight * (100 / root.height)
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    rightItem.height = newHeight
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
        // to listen for changes to their height, expanding etc.
        id: propertyChangeListener
        Item {
            id: target
            height: parent.height
            property bool expanding: (parent.expanding != undefined) ? parent.expanding : false
            property real percentageHeight: (parent.percentageHeight != undefined) ? parent.percentageHeight : -1
            property real minimumHeight: (parent.minimumHeight != undefined) ? parent.minimumHeight : -1
            property real maximumHeight: (parent.maximumHeight != undefined) ? parent.maximumHeight : -1
            property int itemIndex: 0

            onPercentageHeightChanged: d.updateLayout();
            onMinimumHeightChanged: d.updateLayout();
            onMaximumHeightChanged: d.updateLayout();
            onExpandingChanged: updateExpandingIndex()

            function updateExpandingIndex()
            {
                // The following code is needed to avoid a binding
                // loop, since we might change 'expanding' again to a different item:
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
                    if (i !== d.expandingIndex && item.expanding != undefined && item.expanding === true && item.visible === true) {
                        newIndex = i
                        break
                    }
                }
                item = items[newIndex]
                if (item.visible === false) {
                    // So now we ended up with the last item in the splitter to be
                    // expanding, but it turns out to not be visible. So we need to
                    // traverse backwards again to find one that is visible...
                    for (i=items.length-2; i>=0; --i) {
                        var item = items[i]
                        if (item.visible === true) {
                            newIndex = i
                            item = items[newIndex]
                           break
                        }
                    }
                }

                // Tell the found item that it is expanding:
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

            onHeightChanged: {
                // We need to update the layout.
                // The following code is needed to avoid a binding
                // loop, since we might change 'height' again to a different value:
                if (d.itemHeightGuard === true)
                    return
                d.itemHeightGuard = true
                // Break binding:
                height = 0

                d.updateLayout()

                // Restablish binding:
                height = function() { return parent.height; }
                d.itemHeightGuard = false
            }

            onVisibleChanged: {
                // Hiding the expanding item forces us to
                // select a new one (and therefore not recommended):
                if (d.expandingIndex === itemIndex) {
                    updateExpandingIndex()
                } else {
                    if (visible) {
                        // Try to keep all items within the SplitterColumn. When an item
                        // has been hidden, the expanding item might no longer be large enough
                        // to give away space to the new items height. So we need to resize:
                        var overflow = d.accumulatedHeight(0, items.length, true) - root.height;
                        if (overflow > 0)
                            parent.height -= overflow
                    }
                    d.updateLayout()
                }
            }
        }
    }
}
