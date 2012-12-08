/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtDesktop 1.0

Splitter {
    id: root
    default property alias items: splitterItems.children
    property alias handles: splitterHandles.children
    property Component handleDelegate: Rectangle { width:3; color: "black" }
    property int handleWidth: -1
    property real preferredSize: 0
    property int orientation: Qt.Horizontal

    clip: true
    Component.onCompleted: d.init();
    onWidthChanged: d.updateLayout();
    onHeightChanged: d.updateLayout();

    QtObject {
        id: d

        property bool horizontal: orientation == Qt.Horizontal
        property string size: horizontal ? "width" : "height"
        property string minimum: horizontal ? "minimumWidth" : "minimumHeight"
        property string maximum: horizontal ? "maximumWidth" : "maximumHeight"

        property string offset: horizontal ? "x" : "y"
        property int expandingIndex: -1
        property bool updateLayoutGuard: true
        property bool itemWidthGuard: false
        property bool itemExpandingGuard: true

        function init()
        {
            for (var i=0; i<items.length; ++i) {
                var item = items[i];

                item.Splitter.itemIndex = i
                // Assign one, and only one, item to be expanding:
                if (item.Splitter.expanding === true) {
                    if (d.expandingIndex === -1 && item.visible === true)
                        d.expandingIndex = i
                    else
                        item.Splitter.expanding = false
                }

                // Anchor each item to fill out all space vertically:
                if (d.horizontal) {
                    item.anchors.top = splitterItems.top
                    item.anchors.bottom = splitterItems.bottom
                } else  {
                    item.anchors.left = splitterItems.left
                    item.anchors.right = splitterItems.right

                }

                // Listen for changes to width and expanding:
                propertyChangeListener.createObject(item, {"itemIndex":i});
                if (i < items.length-1) {
                    // Create a handle for the item, unless its the last:
                    var handle = handleloader.createObject(splitterHandles, {"handleIndex":i});

                    if (d.horizontal) {
                        handle.anchors.top = splitterHandles.top
                        handle.anchors.bottom = splitterHandles.bottom
                    } else {
                        handle.anchors.left = splitterHandles.left
                        handle.anchors.right = splitterHandles.right
                    }
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
                if (items.length && item.visible) {
                    item.Splitter.expanding = true
                }
            }

            d.itemExpandingGuard = false
            d.updateLayoutGuard = false
            d.updateLayout()
        }

        function accumulatedSize(firstIndex, lastIndex, includeExpandingMinimum)
        {
            // Go through items and handles, and
            // calculate their acummulated width.
            var w = 0
            for (var i=firstIndex; i<lastIndex; ++i) {
                var item = items[i]
                if (item.visible) {
                    if (i !== d.expandingIndex)
                        w += item[d.size];
                    else if (includeExpandingMinimum && item.Splitter[minimum] != -1)
                        w += item[minimum]
                }

                var handle = handles[i]
                if (handle && items[i + ((d.expandingIndex > i) ? 0 : 1)].visible)
                    w += handle[d.size]
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
                    if (item.Splitter.percentageSize !== -1) {
                        newValue = item.Splitter.percentageSize * (root[d.size] / 100)
                        if (newValue !== item[d.size])
                            item[d.size] = newValue
                    }
                    // Ensure item width is not more than maximumSize:
                    if (item.Splitter[maximum] !== -1) {
                        newValue = Math.min(item[d.size], item.Splitter[maximum])
                        if (newValue !== item[d.size])
                            item[d.size] = newValue
                    }
                    // Ensure item width is not more less minimumWidth:
                    if (item.Splitter[minimum] !== -1) {
                        newValue = Math.max(item[d.size], item.Splitter[minimum])
                        if (newValue !== item[d.size])
                            item[d.size] = newValue
                    }
                }
            }

            // Special case: set width of expanding item to available space:
            newValue = root[d.size] - d.accumulatedSize(0, items.length, false);
            var expandingItem = items[d.expandingIndex]
            var expandingMinimum = 0
            if (expandingItem.Splitter[minimum] !== -1)
                expandingMinimum = expandingItem.Splitter[minimum]
            newValue = Math.max(newValue, expandingMinimum)
            if (expandingItem[d.size] !== 0 && expandingItem.Splitter.percentageSize !== -1)
                expandingItem.Splitter.percentageSize = newValue * (100 / root[d.size])
            if (expandingItem[d.size] !== newValue)
                expandingItem[d.size] = newValue

            // Then, position items and handles according to their width:
            var item, lastVisibleItem
            var handle, lastVisibleHandle
            var newpreferredSize = expandingMinimum - expandingItem[d.size]

            for (i=0; i<items.length; ++i) {
                // Position item to the right of the previous visible handle:
                item = items[i];
                if (item.visible) {
                    if (lastVisibleHandle) {
                        newValue = lastVisibleHandle[d.offset] + lastVisibleHandle[d.size]
                        if (newValue !== item[d.offset])
                            item[d.offset] = newValue
                    } else {
                        newValue = 0
                        if (newValue !== item[d.offset])
                            item[d.offset] = newValue
                    }
                    newpreferredSize += item[d.size]
                    lastVisibleItem = item
                }

                // Position handle to the right of the previous visible item. We use an alterative way of
                // checking handle visibility because that property might not have updated correctly yet:
                handle = handles[i]
                if (handle && items[i + ((d.expandingIndex > i) ? 0 : 1)].visible) {
                    newValue = lastVisibleItem[d.offset] + Math.max(0, lastVisibleItem[d.size])
                    if (newValue !== handle[d.offset])
                        handle[d.offset] = newValue
                    newpreferredSize += handle[d.size]
                    lastVisibleHandle = handle
                }
            }

            root.preferredSize = newpreferredSize
            d.updateLayoutGuard = false
        }
    }

    Component {
        id: handleloader
        Loader {
            id: myHandle
            property int handleIndex: 0
            property Item handle: myHandle
            property Item splitterItem: items[handleIndex + ((d.expandingIndex > handleIndex) ? 0 : 1)]

             // 'splitterRow' should be an alias, but that fails to resolve runtime:
            property Item splitterRow: root
            property Item background: item

            visible: splitterItem.visible
            sourceComponent: handleDelegate
            onWidthChanged: d.updateLayout()
            onHeightChanged: d.updateLayout()

            onXChanged: {
                // For some unknown reason, dragging by X axis only not working in MouseArea, so
                // to enable it Drag.XandYAxis should be used, therefore not only Y coordinate
                // changes, but also X and we need to filter out this events, if we have splitter,
                // that should move vertically
                if (d.horizontal) {
                    moveHandle()
                }
            }

            onYChanged: {
                moveHandle()
            }

            function moveHandle() {
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
                            leftEdge = leftHandle[d.offset] + leftHandle[d.size]
                            break;
                        }
                    }

                    // Ensure: leftStopX >= myHandle[d.offset] >= rightStopX
                    var min = d.accumulatedSize(handleIndex+1, items.length, true)
                    rightStopX = root[d.size] - min - myHandle[d.size]
                    leftStopX = Math.max(leftEdge, myHandle[d.offset])
                    myHandle[d.offset] = Math.min(rightStopX, Math.max(leftStopX, myHandle[d.offset]))

                    newWidth = myHandle[d.offset] - leftEdge
                    leftItem = items[handleIndex]
                    if (root[d.size] != 0 && leftItem.Splitter.percentageSize !== -1)
                        leftItem.Splitter.percentageSize = newWidth * (100 / root[d.size])
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    leftItem[d.size] = newWidth
                } else {
                    // Resize item to the right.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the right to determine the right edge:
                    rightEdge = root[d.size]
                    for (i=handleIndex+1; i<handles.length; ++i) {
                        rightHandle = handles[i]
                        if (rightHandle.visible) {
                            rightEdge = rightHandle[d.offset]
                            break;
                        }
                    }

                    // Ensure: leftStopX <= myHandle[d.offset] <= rightStopX
                    var min = d.accumulatedSize(0, handleIndex+1, true)
                    leftStopX = min - myHandle[d.size]
                    rightStopX = Math.min((rightEdge - myHandle[d.size]), myHandle[d.offset])
                    myHandle[d.offset] = Math.max(leftStopX, Math.min(myHandle[d.offset], rightStopX))

                    newWidth = rightEdge - (myHandle[d.offset] + myHandle[d.size])
                    rightItem = items[handleIndex+1]
                    if (root[d.size] !== 0 && rightItem[d.percentageSize] !== -1)
                        rightItem.Splitter.percentageSize = newWidth * (100 / root[d.size])
                    // The next line will trigger 'updateLayout' inside 'propertyChangeListener':
                    rightItem[d.size] = newWidth
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
            width: (d.horizontal ? parent[d.size] : 0)
            height: (!d.horizontal ? parent[d.size] : 0)
            property bool expanding: parent.Splitter.expanding
            property real percentageSize: parent.Splitter.percentageSize
            property real minimumWidth: parent.Splitter[d.minimum]
            property real maximumSize: parent.Splitter[d.maximum]
            property int itemIndex: parent.Splitter.itemIndex

            onPercentageSizeChanged: d.updateLayout();
            onMinimumWidthChanged: d.updateLayout();
            onMaximumSizeChanged: d.updateLayout();
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
                    if (i !== d.expandingIndex && item.Splitter.expanding === true && item.visible === true) {
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
                if (item.Splitter.expanding !== true)
                    item.Splitter.expanding = true
                // ...and the old one that it is not:
                if (newIndex !== d.expandingIndex) {
                    item = items[d.expandingIndex]
                    if (item.Splitter.expanding !== false)
                        item.Splitter.expanding = false
                }
                // update index:
                d.expandingIndex = newIndex
                d.updateLayout();
                // recreate binding:
                expanding = Qt.binding(function() { return parent.Splitter.expanding })
                d.itemExpandingGuard = false
            }

            function handleSizeChanged() {
                // We need to update the layout.
                // The following code is needed to avoid a binding
                // loop, since we might change 'width' again to a different value:
                if (d.itemWidthGuard === true)
                    return
                d.itemWidthGuard = true
                // Break binding:
                if (d.horizontal) {
                    width = 0
                } else {
                    height = 0
                }

                d.updateLayout()

                // Restablish binding:
                if (d.horizontal) {
                    width = Qt.binding(function() { return parent[d.size]; })
                } else {
                    height = Qt.binding(function() { return parent[d.size]; })
                }
                d.itemWidthGuard = false
            }

            onWidthChanged:  handleSizeChanged()
            onHeightChanged: handleSizeChanged()
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
                        var overflow = d.accumulatedSize(0, items.length, true) - root[d.size];
                        if (overflow > 0)
                            parent[d.size] -= overflow
                    }
                    d.updateLayout()
                }
            }
        }
    }
}
