/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0 as Private

/*!
    \qmltype Splitter
    \inqmlmodule QtQuick.Controls 1.0
    \brief Splitter is a component that lays out items horisontally or
    vertically with a draggable splitter between each item.
*/

/*
*
* Splitter
*
* Splitter is a component that lays out items horisontally or
* vertically with a draggable splitter between each item.
*
* There will always be one (and only one) item in the Splitter that is 'expanding'.
* Being expanding means that the item will get all the remaining space when other
* items have been laid out according to their own width and height.
* By default, the last visible child of the Splitter will be expanding, but
* this can changed by setting Layout.horizontalSizePolicy to \c Layout.Expanding.
* Since the expanding item will automatically be resized to fit the extra space, it
* will ignore explicit assignments to width and height.
*
* A handle can belong to the item on the left/top side, or the right/bottom side, of the
* handle. Which one depends on the expaning item. If the expanding item is to the right
* of the handle, the handle will belong to the item on the left. If it is to the left, it
* will belong to the item on the right. This will again control which item that gets resized
* when the user drags a handle, and which handle that gets hidden when an item is told to hide.
*
* The Splitter contains the following API:
*
* int orientation - the orientation of the splitter. Can be either Qt.Horizontal
*   or Qt.Vertical.
* Component handleDelegate - delegate that will be instanciated between each
*   child item. Inside the delegate, the following properties are available:
*   int handleIndex - specifies the index of the splitter handle. The handle
*       between the first and the second item will get index 0, the next handle index 1 etc.
*   bool containsMouse - the mouse hovers the handle.
*   bool pressed: the handle is being pressed.
*   bool dragged: the handle is being dragged.
*
* Splitter supports setting Layout properties on child items, which means that you
* can control minimumWidth, minimumHeight, maximumWidth and maximumHeight (in addition
* to horizontalSizePolicy/verticalSizePolicy) for each child.
*
* Example:
*
* To create a Splitter with three items, and let
* the center item be expanding, one could do the following:
*
*    Splitter {
*        anchors.fill: parent
*        orientation: Qt.Horizontal
*
*        Rectangle {
*            width: 200
*            Layout.maximumWidth: 400
*            color: "gray"
*        }
*        Rectangle {
*            id: centerItem
*            Layout.minimumWidth: 50
*            Layout.horizontalSizePolicy: Layout.Expanding
*            color: "darkgray"
*        }
*        Rectangle {
*            width: 200
*            color: "gray"
*        }
*    }
*/

Item {
    id: root
    property int orientation: Qt.Horizontal

    property Component handleDelegate:
    Rectangle{
        width: 1
        height: 1
        color: Qt.darker(pal.window, 1.5)
    }

    // **** PRIVATE ****

    clip: true
    default property alias __items: splitterItems.children
    property alias __handles: splitterHandles.children
    Component.onCompleted: d.init()
    onWidthChanged: d.updateLayout()
    onHeightChanged: d.updateLayout()

    SystemPalette { id: pal }

    QtObject {
        id: d
        property bool horizontal: orientation == Qt.Horizontal
        property string minimum: horizontal ? "minimumWidth" : "minimumHeight"
        property string maximum: horizontal ? "maximumWidth" : "maximumHeight"
        property string offset: horizontal ? "x" : "y"
        property string otherOffset: horizontal ? "y" : "x"
        property string size: horizontal ? "width" : "height"
        property string otherSize: horizontal ? "height" : "width"

        property int expandingIndex: -1
        property bool updateLayoutGuard: true

        function init()
        {
            for (var i=0; i<__items.length; ++i) {
                var item = __items[i];
                item.widthChanged.connect(d.updateLayout);
                item.heightChanged.connect(d.updateLayout);
                item.Layout.maximumWidthChanged.connect(d.updateLayout);
                item.Layout.minimumWidthChanged.connect(d.updateLayout);
                item.Layout.maximumHeightChanged.connect(d.updateLayout);
                item.Layout.minimumHeightChanged.connect(d.updateLayout);
                item.Layout.horizontalSizePolicyChanged.connect(d.updateExpandingIndex)
                item.Layout.verticalSizePolicyChanged.connect(d.updateExpandingIndex)
                d.listenForVisibleChanged(item)
                if (i < __items.length-1)
                    handleLoader.createObject(splitterHandles, {"handleIndex":i});
            }

            d.updateExpandingIndex()
            d.updateLayoutGuard = false
            d.updateLayout()
        }

        function listenForVisibleChanged(item) {
            item.visibleChanged.connect(function() {
                if (!root.visible)
                    return
                if (item.visible) {
                    // Try to keep all items within the SplitterRow. When an item
                    // has been hidden, the expanding item might no longer be large enough
                    // to give away space to the new items width. So we need to resize:
                    var overflow = d.accumulatedSize(0, __items.length, true) - root[d.size];
                    if (overflow > 0)
                        item[d.size] -= overflow
                }
                updateExpandingIndex()
            });
        }

        function updateExpandingIndex()
        {
            var policy = (root.orientation === Qt.Horizontal) ? "horizontalSizePolicy" : "verticalSizePolicy"
            for (var i=__items.length-1; i>=0; --i) {
                if (__items[i].visible && __items[i].Layout[policy] === Layout.Expanding) {
                    d.expandingIndex = i
                    break;
                }
            }

            if (i === -1) {
                for (i=__items.length-1; i>0; --i) {
                    if (__items[i].visible)
                        break;
                }
            }

            d.expandingIndex = i
            d.updateLayout()
        }

        function accumulatedSize(firstIndex, lastIndex, includeExpandingMinimum)
        {
            // Go through items and handles, and
            // calculate their acummulated width.
            var w = 0
            for (var i=firstIndex; i<lastIndex; ++i) {
                var item = __items[i]
                if (item.visible) {
                    if (i !== d.expandingIndex)
                        w += item[d.size];
                    else if (includeExpandingMinimum && item.Layout[minimum] !== undefined)
                        w += item.Layout[minimum]
                }

                var handle = __handles[i]
                if (handle && __items[i + ((d.expandingIndex > i) ? 0 : 1)].visible)
                    w += handle[d.size]
            }
            return w
        }

        function updateLayout()
        {
            // This function will reposition both handles and
            // items according to the their width/height:
            if (__items.length === 0)
                return;
            if (d.updateLayoutGuard === true)
                return
            d.updateLayoutGuard = true

            // Ensure all items within their min/max:
            for (var i=0; i<__items.length; ++i) {
                if (i !== d.expandingIndex) {
                    var item = __items[i];
                    if (item.Layout[maximum] !== undefined) {
                        if (item[d.size] > item.Layout[maximum])
                            item[d.size] = item.Layout[maximum]
                    }
                    if (item.Layout[minimum] !== undefined) {
                        if (item[d.size] < item.Layout[minimum])
                            item[d.size] = item.Layout[minimum]
                    }
                }
            }

            // Set size of expanding item to remaining available space:
            var expandingItem = __items[expandingIndex]
            var min = expandingItem.Layout[minimum] !== undefined ? expandingItem.Layout[minimum] : 0
            expandingItem[d.size] = Math.max(min, root[d.size] - d.accumulatedSize(0, __items.length, false))

            // Then, position items and handles according to their width:
            var lastVisibleItem, lastVisibleHandle, handle
            var implicitSize = min - expandingItem[d.size]

            for (i=0; i<__items.length; ++i) {
                // Position item to the right of the previous visible handle:
                item = __items[i];
                if (item.visible) {
                    item[d.offset] = lastVisibleHandle ? lastVisibleHandle[d.offset] + lastVisibleHandle[d.size] : 0
                    item[d.otherOffset] = 0
                    item[d.otherSize] = root[d.otherSize]
                    implicitSize += item[d.size]
                    lastVisibleItem = item
                }

                // Position handle to the right of the previous visible item. We use an alterative way of
                // checking handle visibility because that property might not have updated correctly yet:
                handle = __handles[i]
                if (handle && __items[i + ((d.expandingIndex > i) ? 0 : 1)].visible) {
                    handle[d.offset] = lastVisibleItem[d.offset] + Math.max(0, lastVisibleItem[d.size])
                    handle[d.otherOffset] = 0
                    handle[d.otherSize] = root[d.otherSize]
                    implicitSize += handle[d.size]
                    lastVisibleHandle = handle
                }
            }

            if (root.orientation === Qt.horizontal) {
                root.implicitWidth = implicitSize
                root.implicitHeight = 0
            } else {
                root.implicitWidth = 0
                root.implicitHeight = implicitSize
            }

            d.updateLayoutGuard = false
        }
    }

    Component {
        id: handleLoader
        Loader {
            id: itemHandle
            property int handleIndex: -1
            property alias containsMouse: mouseArea.containsMouse
            property alias pressed: mouseArea.pressed
            property bool dragged: mouseArea.drag.active

            visible: __items[handleIndex + ((d.expandingIndex > handleIndex) ? 0 : 1)].visible
            sourceComponent: handleDelegate
            onWidthChanged: d.updateLayout()
            onHeightChanged: d.updateLayout()
            onXChanged: moveHandle()
            onYChanged: moveHandle()

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.leftMargin: (parent.width <= 1) ? -2 : 0
                anchors.rightMargin: (parent.width <= 1) ? -2 : 0
                anchors.topMargin: (parent.height <= 1) ? -2 : 0
                anchors.bottomMargin: (parent.height <= 1) ? -2 : 0
                hoverEnabled: true
                drag.target: parent
                drag.axis: root.orientation === Qt.Horizontal ? Drag.XAxis : Drag.YAxis
                cursorShape: root.orientation === Qt.Horizontal ? Qt.SplitHCursor : Qt.SplitVCursor
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
                        leftHandle = __handles[i]
                        if (leftHandle.visible) {
                            leftEdge = leftHandle[d.offset] + leftHandle[d.size]
                            break;
                        }
                    }

                    // Ensure: leftStopX >= itemHandle[d.offset] >= rightStopX
                    var min = d.accumulatedSize(handleIndex+1, __items.length, true)
                    rightStopX = root[d.size] - min - itemHandle[d.size]
                    leftStopX = Math.max(leftEdge, itemHandle[d.offset])
                    itemHandle[d.offset] = Math.min(rightStopX, Math.max(leftStopX, itemHandle[d.offset]))

                    newWidth = itemHandle[d.offset] - leftEdge
                    leftItem = __items[handleIndex]
                    // The next line will trigger 'updateLayout':
                    leftItem[d.size] = newWidth
                } else {
                    // Resize item to the right.
                    // Ensure that the handle is not crossing other handles. So
                    // find the first visible handle to the right to determine the right edge:
                    rightEdge = root[d.size]
                    for (i=handleIndex+1; i<__handles.length; ++i) {
                        rightHandle = __handles[i]
                        if (rightHandle.visible) {
                            rightEdge = rightHandle[d.offset]
                            break;
                        }
                    }

                    // Ensure: leftStopX <= itemHandle[d.offset] <= rightStopX
                    min = d.accumulatedSize(0, handleIndex+1, true)
                    leftStopX = min - itemHandle[d.size]
                    rightStopX = Math.min((rightEdge - itemHandle[d.size]), itemHandle[d.offset])
                    itemHandle[d.offset] = Math.max(leftStopX, Math.min(itemHandle[d.offset], rightStopX))

                    newWidth = rightEdge - (itemHandle[d.offset] + itemHandle[d.size])
                    rightItem = __items[handleIndex+1]
                    // The next line will trigger 'updateLayout':
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

}
