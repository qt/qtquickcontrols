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

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.0

/*!
   \qmltype TableView
   \inqmlmodule QtQuick.Controls 1.0
   \since QtQuick.Controls 1.0
   \ingroup views
   \brief Provides a list view with scroll bars, styling and header sections.

   \image tableview.png

   A TableView is similar to \l ListView, and adds scroll bars, selection, and
   resizable header sections. As with \l ListView, data for each row is provided through a \l model:

 \code
 ListModel {
    id: libraryModel
    ListElement{ title: "A Masterpiece" ; author: "Gabriel" }
    ListElement{ title: "Brilliance"    ; author: "Jens" }
    ListElement{ title: "Outstanding"   ; author: "Frederik" }
 }
 \endcode

   You provide title and size of a column header
   by adding a \l TableViewColumn to the default \l header property
   as demonstrated below.
 \code

 TableView {
    TableViewColumn{ role: "title"  ; title: "Title" ; width: 100 }
    TableViewColumn{ role: "author" ; title: "Author" ; width: 200 }
    model: libraryModel
 }
 \endcode

   The header sections are attached to values in the \l model by defining
   the model role they attach to. Each property in the model will
   then be shown in their corresponding column.

   You can customize the look by overriding the \l itemDelegate,
   \l rowDelegate, or \l headerDelegate properties.

   The view itself does not provide sorting. This has to
   be done on the model itself. However you can provide sorting
   on the model, and enable sort indicators on headers.

\list
    \li sortColumnIndex - The index of the current sort column
    \li sortIndicatorVisible - Whether the sort indicator should be enabled
    \li sortIndicatorOrder - Qt.AscendingOrder or Qt.DescendingOrder depending on state
\endlist
*/

ScrollView {
    id: root

    /*! \qmlproperty model TableView::model
    This property holds the model providing data for the table view.

    The model provides the set of data that is used to create the items in the view.
    Models can be created directly in QML using ListModel, XmlListModel or VisualItemModel,
    or provided by C++ model classes. \sa ListView::model

    Example model:

    \code
    model: ListModel {
        ListElement{ column1: "value 1" ; column2: "value 2" }
        ListElement{ column1: "value 3" ; column2: "value 4" }
    }
    \endcode
    \sa {qml-data-models}{Data Models}
    */
    property var model

    /*! This property is set to \c true if the view alternates the row color.
        The default value is \c true. */
    property bool alternatingRowColors: true

    /*! This property determines if the header is visible.
        The default value is \c true. */
    property bool headerVisible: true

    /*! This property defines a delegate to draw a specific cell.

    In the item delegate you have access to the following special properties:
    \list
    \li  itemSelected - if the item is currently selected
    \li  itemValue - the value or text for this item
    \li  itemTextColor - the default text color for an item
    \li  rowIndex - the index of the row
    \li  columnIndex - the index of the column
    \li  itemElideMode - the elide mode of the column
    \li  itemTextAlignment - the horizontal text alignment of the column
    \endlist
    Example:
    \code
    itemDelegate: Item {
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: itemTextColor
            elide: itemElideMode
            text: itemValue
        }
    }
    \endcode */
    property Component itemDelegate: __style ? __style.itemDelegate : null

    /*! This property defines a delegate to draw a row.

    In the row delegate you have access to the following special properties:
    \list
    \li  alternateBackground - if the row uses the alternate background color
    \li  rowSelected - if the row is currently selected
    \li  index - the index of the row
    \endlist
    */
    property Component rowDelegate: __style ? __style.rowDelegate : null

    /*! \qmlproperty color TableView::backgroundColor

        This property sets the background color of the viewport.
        The default value is the base color of the SystemPalette. */
    property alias backgroundColor: colorRect.color

    /*! This property defines a delegate to draw a header. */
    property Component headerDelegate: __style ? __style.headerDelegate : null

    /*! Index of the current sort column.
        The default value is \c {0}. */
    property int sortColumnIndex

    /*! This property shows or hides the sort indicator
        The default value is \c false.
        \note The view itself does not sort the data. */
    property bool sortIndicatorVisible: false

    /*!
       \qmlproperty enumeration TableView::sortIndicatorOrder

       This sets the sorting order of the sort indicator
       The allowed values are:
       \list
       \li Qt.AscendingOrder - the default
       \li Qt.DescendingOrder
       \endlist
    */
    property int sortIndicatorOrder: Qt.AscendingOrder

    /*! \qmlproperty list<TableViewColumn> TableView::columns
    This property contains the TableViewColumn items */
    default property alias columns: listView.columnheader

    /*! \qmlproperty Component TableView::contentHeader
    This is the content header of the TableView */
    property alias contentHeader: listView.header

    /*! \qmlproperty Component TableView::contentFooter
    This is the content footer of the TableView */
    property alias contentFooter: listView.footer

    /*! \qmlproperty Item TableView::currentRowItem
    This is the current item of the TableView */
    property alias currentRowItem: listView.currentItem

    /*! \qmlproperty int TableView::rowCount
    The current number of rows */
    readonly property alias rowCount: listView.count

    /*! The current number of columns */
    readonly property int columnCount: columns.length

    /*! \qmlproperty string TableView::section.property
        \qmlproperty enumeration TableView::section.criteria
        \qmlproperty Component TableView::section.delegate
        \qmlproperty enumeration TableView::section.labelPositioning
    These properties determine the section labels.
    \sa ListView::section */
    property alias section: listView.section

    /*! \qmlproperty int TableView::currentRow
    The current row index of the view.
    The default value is \c -1 to indicate that no row is selected.
    */
    property alias currentRow: listView.currentIndex

    /*! \qmlsignal TableView::activated()
        Emitted when the user activates an item by single or double-clicking (depending on the platform).
    */
    signal activated

    /*!
        \qmlmethod TableView::positionViewAtIndex

    Positions the view such that the \a index is at the position specified by \a mode:
       \list
       \li ListView.Beginning - position item at the top of the view.
       \li ListView.Center - position item in the center of the view.
       \li ListView.End - position item at bottom of the view.
       \li ListView.Visible - if any part of the item is visible then take no action, otherwise bring the item into view.
       \li ListView.Contain - ensure the entire item is visible. If the item is larger than the view the item is positioned
           at the top of the view.
       \endlist

    If using the \a index to position the view creates an empty space at the beginning
    or end of the view, then the view is positioned at the boundary.

    The correct way to bring an item into view is with positionViewAtIndex.

    Note that this method should only be called after the Component has completed.
    To position the view at startup, this method should be called by Component.onCompleted.
    For example, to position the view at the end at startup:

    \code
    Component.onCompleted: table.positionViewAtIndex(rowCount -1, ListView.Contain)
    \endcode

    Depending on how the model is populated, the model may not be ready when
    TableView Component.onCompleted is called. In that case you may need to
    delay the call to positionViewAtIndex by using a \l {Timer}.

    */

    function positionViewAtIndex(index, mode) {
        listView.positionViewAtIndex(index, mode)
    }

    style: Qt.createComponent(Settings.theme() + "/TableViewStyle.qml", root)


    Accessible.role: Accessible.Table

    width: 200
    height: 200

    frameVisible: true
    __scrollBarTopMargin: Qt.platform.os === "mac" ? headerrow.height : 0
    __viewTopMargin: headerrow.height

    /*! \internal */
    property bool __activateItemOnSingleClick: __style ? __style.activateItemOnSingleClick : false

    /*! \internal */
    function __decrementCurrentIndex() {
        __scroller.blockUpdates = true;
        listView.decrementCurrentIndex();
        __scroller.blockUpdates = false;
    }

    /*! \internal */
    function __incrementCurrentIndex() {
        __scroller.blockUpdates = true;
        listView.incrementCurrentIndex();
        __scroller.blockUpdates = false;
    }

    ListView {
        id: listView
        focus: true
        activeFocusOnTab: true
        anchors.topMargin: tableHeader.height
        anchors.fill: parent
        currentIndex: -1

        interactive: false
        SystemPalette {
            id: palette
            colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
        }

        Rectangle {
            id: colorRect
            parent: viewport
            anchors.fill: parent
            color: palette.base
            z: -1
        }

        MouseArea {
            id: mousearea

            anchors.fill: listView
            propagateComposedEvents: true

            property bool autoincrement: false
            property bool autodecrement: false

            onReleased: {
                autoincrement = false
                autodecrement = false
            }

            // Handle vertical scrolling whem dragging mouse outside boundraries
            Timer { running: mousearea.autoincrement && __scroller.verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: __incrementCurrentIndex()}
            Timer { running: mousearea.autodecrement && __scroller.verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: __decrementCurrentIndex()}

            onPositionChanged: {
                if (mouseY > listView.height && pressed) {
                    if (autoincrement) return;
                    autodecrement = false;
                    autoincrement = true;
                } else if (mouseY < 0 && pressed) {
                    if (autodecrement) return;
                    autoincrement = false;
                    autodecrement = true;
                } else  {
                    autoincrement = false;
                    autodecrement = false;
                }
                var y = Math.min(flickableItem.contentY + listView.height - 5, Math.max(mouseY + flickableItem.contentY, flickableItem.contentY));
                var newIndex = listView.indexAt(0, y);
                if (newIndex >= 0)
                    listView.currentIndex = listView.indexAt(0, y);
            }

            onClicked: {
                if (root.__activateItemOnSingleClick)
                    root.activated()
                mouse.accepted = false
            }

            onPressed: {
                listView.forceActiveFocus()
                var x = Math.min(flickableItem.contentWidth - 5, Math.max(mouseX + flickableItem.contentX, 0))
                var y = Math.min(flickableItem.contentHeight - 5, Math.max(mouseY + flickableItem.contentY, 0))
                listView.currentIndex = listView.indexAt(x, y)
            }

            onDoubleClicked: {
                if (!root.__activateItemOnSingleClick)
                    root.activated()
            }

            // Note:  with boolean preventStealing we are keeping the flickable from
            // eating our mouse press events
            preventStealing: true

        }

        // Fills extra rows with alternate color
        Column {
            id: rowfiller
            property int rowHeight: flickableItem.contentHeight/count
            property int paddedRowCount: height/rowHeight
            property int count: flickableItem.count
            y: flickableItem.contentHeight
            width: parent.width
            visible: flickableItem.contentHeight > 0 && alternatingRowColors
            height: viewport.height - flickableItem.contentHeight
            Repeater {
                model: visible ? parent.paddedRowCount : 0
                Loader {
                    width: rowfiller.width
                    height: rowfiller.rowHeight
                    sourceComponent: root.rowDelegate
                    readonly property bool alternateBackground: (index + rowCount) % 2 === 1
                    readonly property bool rowSelected: false
                    readonly property var model: listView.model
                    readonly property var modelData: null
                    readonly property bool hasActiveFocus: root.activeFocus
                }
            }
        }

        property list<TableViewColumn> columnheader
        highlightFollowsCurrentItem: true
        model: root.model

        Keys.onUpPressed: root.__decrementCurrentIndex()
        Keys.onDownPressed: root.__incrementCurrentIndex()

        Keys.onPressed: {
            if (event.key === Qt.Key_PageUp) {
                verticalScrollBar.value = __scroller.verticalScrollBar.value - listView.height
            } else if (event.key === Qt.Key_PageDown)
                verticalScrollBar.value = __scroller.verticalScrollBar.value + listView.height
        }

        Keys.onReturnPressed: root.activated();

        delegate: Item {
            id: rowitem
            width: row.width
            height: rowstyle.height

            property int rowIndex: model.index
            property bool alternateBackground: alternatingRowColors && rowIndex % 2 == 1
            property var itemModelData: typeof modelData == "undefined" ? null : modelData
            property var itemModel: model

            Loader {
                id: rowstyle
                // row delegate
                sourceComponent: root.rowDelegate
                // Row fills the view width regardless of item size
                // But scrollbar should not adjust to it
                width: parent.width + __scroller.horizontalScrollBar.width
                x: flickableItem.contentX

                // these properties are exposed to the row delegate
                // Note: these properties should be mirrored in the row filler as well
                readonly property bool alternateBackground: rowitem.alternateBackground
                readonly property bool rowSelected: rowitem.ListView.isCurrentItem
                readonly property int index: rowitem.rowIndex
                readonly property var model: listView.model
                readonly property var modelData: rowitem.itemModelData
                readonly property var itemModel: rowitem.itemModel
                readonly property bool hasActiveFocus: root.activeFocus
            }
            Row {
                id: row
                anchors.left: parent.left
                height: parent.height
                Repeater {
                    id: repeater
                    model: root.columns.length
                    Loader {
                        id: itemDelegateLoader
                        width: columns[index].width
                        height: parent ? parent.height : 0
                        visible: columns[index].visible
                        sourceComponent: columns[index].delegate ? columns[index].delegate : itemDelegate

                        // these properties are exposed to the item delegate
                        property var model: listView.model
                        property var modelData: itemModelData

                        property var itemValue: __getValue()
                        property bool itemSelected: rowitem.ListView.isCurrentItem
                        property color itemTextColor: itemSelected ? __style.highlightedTextColor : __style.textColor
                        property int rowIndex: rowitem.rowIndex
                        property int columnIndex: index
                        property int itemElideMode: columns[index].elideMode
                        property int itemTextAlignment: columns[index].horizontalAlignment
                        property string role: columns[index].role

                        function __getValue() {
                            var role = columns[index].role
                            if (role.length && itemModel.hasOwnProperty(role))
                                return itemModel[role] // Qml ListModel and QAbstractItemModel
                            else if (modelData != undefined && modelData.hasOwnProperty(role))
                                return modelData[role] // QObjectList / QObject
                            else if (modelData != undefined)
                                return modelData // Models without role
                            else
                                return ""
                        }
                    }
                }
                onWidthChanged: listView.contentWidth = width
            }
        }

        Text{ id:text }

        Item {
            id: tableHeader
            clip: true
            parent: __scroller
            visible: headerVisible
            anchors.top: parent.top
            anchors.topMargin: viewport.anchors.topMargin
            anchors.leftMargin: viewport.anchors.leftMargin
            anchors.margins: viewport.anchors.margins
            anchors.rightMargin: __scroller.rightMargin +
                                 (__scroller.outerFrame && __scrollBarTopMargin ? 0 : __scroller.verticalScrollBar.width
                                                          + __scroller.scrollBarSpacing)

            anchors.left: parent.left
            anchors.right: parent.right

            height: headerrow.height

            Row {
                id: headerrow
                x: -listView.contentX

                Repeater {
                    id: repeater

                    property int targetIndex: -1
                    property int dragIndex: -1

                    model: columns.length

                    delegate: Item {
                        z:-index
                        width: columns[index].width
                        visible: columns[index].visible
                        height: headerVisible ? headerStyle.height : 0

                        Loader {
                            id: headerStyle
                            sourceComponent: root.headerDelegate
                            anchors.left: parent.left
                            anchors.right: parent.right
                            property string itemValue: columns[index].title
                            property string itemSort:  (sortIndicatorVisible && index == sortColumnIndex) ? (sortIndicatorOrder == Qt.AscendingOrder ? "up" : "down") : "";
                            property bool itemPressed: headerClickArea.pressed
                            property bool itemContainsMouse: headerClickArea.containsMouse
                            property string itemPosition: columns.length === 1 ? "only" :
                                                                                index===columns.length-1 ? "end" :
                                                                                                          index===0 ? "beginning" : ""
                        }
                        Rectangle{
                            id: targetmark
                            width: parent.width
                            height:parent.height
                            opacity: (index == repeater.targetIndex && repeater.targetIndex != repeater.dragIndex) ? 0.5 : 0
                            Behavior on opacity { NumberAnimation{duration:160}}
                            color: palette.highlight
                        }

                        MouseArea{
                            id: headerClickArea
                            drag.axis: Qt.YAxis
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                if (sortColumnIndex == index)
                                    sortIndicatorOrder = sortIndicatorOrder == Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                                sortColumnIndex = index
                            }
                            // Here we handle moving header sections
                            // NOTE: the direction is different from the master branch
                            // so this indicates that I am using an invalid assumption on item ordering
                            onPositionChanged: {
                                if (pressed) { // only do this while dragging
                                    for (var h = columns.length-1 ; h >= 0 ; --h) {
                                        if (drag.target.x > headerrow.children[h].x) {
                                            repeater.targetIndex = h
                                            break
                                        }
                                    }
                                }
                            }

                            onPressed: {
                                repeater.dragIndex = index
                                draghandle.x = parent.x
                            }

                            onReleased: {
                                if (repeater.targetIndex >= 0 && repeater.targetIndex != index ) {
                                    // Rearrange the header sections
                                    var items = new Array
                                    for (var i = 0 ; i< columns.length ; ++i)
                                        items.push(columns[i])
                                    items.splice(index, 1);
                                    items.splice(repeater.targetIndex, 0, columns[index]);
                                    columns = items
                                    if (sortColumnIndex == index)
                                        sortColumnIndex = repeater.targetIndex
                                }
                                repeater.targetIndex = -1
                            }
                            drag.maximumX: 1000
                            drag.minimumX: -1000
                            drag.target: draghandle
                        }

                        Loader {
                            id: draghandle
                            property string itemValue: columns[index].title
                            property string itemSort:  (sortIndicatorVisible && index == sortColumnIndex) ? (sortIndicatorOrder == Qt.AscendingOrder ? "up" : "down") : "";
                            property bool itemPressed: headerClickArea.pressed
                            property bool itemContainsMouse: headerClickArea.containsMouse
                            property string itemPosition

                            parent: tableHeader
                            width: columns[index].width
                            height: parent.height
                            sourceComponent: root.headerDelegate
                            visible: headerClickArea.pressed
                            opacity: 0.5
                        }


                        MouseArea {
                            id: headerResizeHandle
                            property int offset: 0
                            property int minimumSize: 20
                            anchors.rightMargin: -width/2
                            width: 16 ; height: parent.height
                            anchors.right: parent.right
                            onPositionChanged:  {
                                var newHeaderWidth = columns[index].width + (mouseX - offset)
                                columns[index].width = Math.max(minimumSize, newHeaderWidth)
                            }
                            property bool found:false

                            onDoubleClicked: {
                                var row
                                var minWidth =  0
                                var listdata = listView.children[0]
                                for (row = 0 ; row < listdata.children.length ; ++row){
                                    var item = listdata.children[row+1]
                                    if (item && item.children[1] && item.children[1].children[index] &&
                                            item.children[1].children[index].children[0].hasOwnProperty("implicitWidth"))
                                        minWidth = Math.max(minWidth, item.children[1].children[index].children[0].implicitWidth)
                                }
                                if (minWidth)
                                    columns[index].width = minWidth
                            }
                            onPressedChanged: if (pressed) offset=mouseX
                            cursorShape: Qt.SplitHCursor
                        }
                    }
                }
            }
            Loader {
                id: loader
                property string itemValue
                property string itemSort
                property bool itemPressed
                property bool itemContainsMouse
                property string itemPosition

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: headerrow.bottom
                anchors.rightMargin: -2
                sourceComponent: root.headerDelegate
                width: root.width - headerrow.width + 2
                visible: root.columns.length
                z:-1
            }
        }
    }
}
