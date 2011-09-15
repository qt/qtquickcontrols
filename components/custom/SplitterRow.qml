import QtQuick 1.1
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
* change the width of the child items inside the SplitterRow. If you set the visibility
* of a child item to false, the corresponding handle will also be hidden, and the
* SplitterRow will perform a layout update to fill up available space.
*
* There will always be one (and only one) item in the SplitterRow that is 'expanding'.
* The expanding item is the child that will get all the remaining space in the SplitterRow
* (down to its own mimimumSize) when all other items have been layed out.
* This means that that 'width', 'percentageWidth' and 'maximumWidth' will be ignored for this item.
* By default, the last visible child item of the SplitterRow will be 'expanding'.
*
* A handle can belong to the item on the left side, or the right side, of the handle. Which one depends
* on the expaning item. If the expanding item is to the right of the handle, the
* handle will belong to the item on the left. If it is to the left, it will belong to the item on the
* right. This will again control which item that gets resized when the user drags a handle, and which
* handle that gets hidden when an item is told to hide.
*
* NB: Since SplitterRow might modify geometry properties like 'width' and 'x' of child items
* to e.g. ensure they stay within minimumWidth/maximumWidth, explicit expression bindings
* to such properties can easily be broken up by the SplitterRow, and is not recommended.
*
* The SplitterRow contains the following API:
*
* Component handleBackground - delegate that will be instanciated between each
*   child item. Inside the delegate, the following properties are available:
*   int handleIndex - specifies the index of the splitter handle. The handle
*       between the first and the second item will get index 0, the next handle index 1 etc.
*   Item handle - convenience property that points to the item where the handle background is
*       instanciated as a child. Identical to splitterRow.handles[handleIndex]. The handle
*       background iteself can be accessed through handle.item.
*       Modify 'handle.x' to move the handle (or change 'width' of SplitterRow child items).
*   Item splitterItem - convenience property that points to the child item that the handle controls.
*       Also refer to information about the expanding item above.
*   Item splitterRow - points to the SplitterRow that the handle is in.
* List<Item> items - contains the list of child items in the SplitterRow. Currently read-only.
* List<Item> handles - contains the list of splitter handles in the SplitterRow. Note that this list will
*   be populated after all child items has completed, so accessing it from Component.onCompleted
*   inside a SplitterRow child item will not work.  To get to the handle background, access the
*   'background' property of the handle, e.g. handles[0].background. Read-only.
* real preferredWidth - contains the accumulated with of all child items and handles, except
*   the expanding item. If the expanding item has a minimum width, the minimum width will
*   be included.
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
* bool expanding - See explanation of 'expanding' above. If set to true, the current item
*   will be the expanding item in the SplitterRow. If set to false, the SplitterRow will
*   autmatically choose the last visible child of the SplitterRow as expanding instead.
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
*            property real maximumWidth: 400
*            color: "gray"
*            width: 200
*        }
*        Rectangle {
*            property real minimumWidth: 50
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
    property real preferredWidth: 0
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

        function accumulatedWidth(firstIndex, lastIndex, includeExpandingMinimum)
        {
            // Go through items and handles, and
            // calculate their acummulated width.
            var w = 0
            for (var i=firstIndex; i<lastIndex; ++i) {
                var item = items[i]
                if (item.visible) {
                    if (i !== d.expandingIndex)
                        w += item.width;
                    else if (includeExpandingMinimum && item.minimumWidth != undefined && item.minimumWidth != -1)
                        w += item.minimumWidth
                }

                var handle = handles[i]
                if (handle && items[i + ((d.expandingIndex > i) ? 0 : 1)].visible)
                    w += handle.width
            }
            return w
        }

        function updateLayout()
        {
            // This function will reposition both handles and
            // items according to the _width of the each item_
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
            var expandingMinimum = 0
            if (expandingItem.minimumWidth != undefined && expandingItem.minimumWidth != -1)
                expandingMinimum = expandingItem.minimumWidth
            newValue = Math.max(newValue, expandingMinimum)
            if (expandingItem.width != 0 && expandingItem.percentageWidth != undefined && expandingItem.percentageWidth !== -1)
                expandingItem.percentageWidth = newValue * (100 / root.width)
            if (expandingItem.width !== newValue)
                expandingItem.width = newValue

            // Then, position items and handles according to their width:
            var item, lastVisibleItem
            var handle, lastVisibleHandle
            var newPreferredWidth = expandingMinimum - expandingItem.width

            for (i=0; i<items.length; ++i) {
                // Position item to the right of the previous visible handle:
                item = items[i];
                if (item.visible) {
                    if (lastVisibleHandle) {
                        newValue = lastVisibleHandle.x + lastVisibleHandle.width
                        if (newValue !== item.x)
                            item.x = newValue
                    } else {
                        newValue = 0
                        if (newValue !== item.x)
                            item.x = newValue
                    }
                    newPreferredWidth += item.width
                    lastVisibleItem = item
                }

                // Position handle to the right of the previous visible item. We use an alterative way of
                // checking handle visibility because that property might not have updated correctly yet:
                handle = handles[i]
                if (handle && items[i + ((d.expandingIndex > i) ? 0 : 1)].visible) {
                    newValue = lastVisibleItem.x + Math.max(0, lastVisibleItem.width)
                    if (newValue !== handle.x)
                        handle.x = newValue
                    newPreferredWidth += handle.width
                    lastVisibleHandle = handle
                }
            }

            root.preferredWidth = newPreferredWidth
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
                var i

                if (d.expandingIndex > handleIndex) {
                    // Resize item to the left.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the left to determine the left edge:
                    leftEdge = 0
                    for (i=handleIndex-1; i>=0; --i) {
                        leftHandle = handles[i]
                        if (leftHandle.visible) {
                            leftEdge = leftHandle.x + leftHandle.width
                            break;
                        }
                    }

                    // Ensure: leftStopX >= myHandle.x >= rightStopX
                    var min = d.accumulatedWidth(handleIndex+1, items.length, true)
                    rightStopX = root.width - min - myHandle.width
                    leftStopX = Math.max(leftEdge, myHandle.x)
                    myHandle.x = Math.min(rightStopX, Math.max(leftStopX, myHandle.x))

                    newWidth = myHandle.x - leftEdge
                    leftItem = items[handleIndex]
                    if (root.width != 0 && leftItem.percentageWidth != undefined && leftItem.percentageWidth !== -1)
                        leftItem.percentageWidth = newWidth * (100 / root.width)
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    leftItem.width = newWidth
                } else {
                    // Resize item to the right.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the right to determine the right edge:
                    rightEdge = root.width
                    for (i=handleIndex+1; i<handles.length; ++i) {
                        rightHandle = handles[i]
                        if (rightHandle.visible) {
                            rightEdge = rightHandle.x
                            break;
                        }
                    }

                    // Ensure: leftStopX <= myHandle.x <= rightStopX
                    var min = d.accumulatedWidth(0, handleIndex+1, true)
                    leftStopX = min - myHandle.width
                    rightStopX = Math.min((rightEdge - myHandle.width), myHandle.x)
                    myHandle.x = Math.max(leftStopX, Math.min(myHandle.x, rightStopX))

                    newWidth = rightEdge - (myHandle.x + myHandle.width)
                    rightItem = items[handleIndex+1]
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
        // to listen for changes to their width, expanding etc.
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

            onWidthChanged: {
                // We need to update the layout.
                // The following code is needed to avoid a binding
                // loop, since we might change 'width' again to a different value:
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

            onVisibleChanged: {
                // Hiding the expanding item forces us to
                // select a new one (and therefore not recommended):
                if (d.expandingIndex === itemIndex) {
                    updateExpandingIndex()
                } else {
                    if (visible) {
                        // Try to keep all items within the SplitterRow. When an item
                        // has been hidden, the expanding item might no longer be large enough
                        // to give away space to the new items width. So we need to resize:
                        var overflow = d.accumulatedWidth(0, items.length, true) - root.width;
                        if (overflow > 0)
                            parent.width -= overflow
                    }
                    d.updateLayout()
                }
            }
        }
    }
}
