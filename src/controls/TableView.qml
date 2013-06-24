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
   by adding a \l TableViewColumn as demonstrated below.
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
    \li int sortIndicatorColumn - The index of the current sort column
    \li bool sortIndicatorVisible - Whether the sort indicator should be enabled
    \li enum sortIndicatorOrder - Qt.AscendingOrder or Qt.DescendingOrder depending on state
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

    /*! \qmlproperty bool TableView::backgroundVisible

        This property determines if the background should be filled or not.

        The default value is \c true.

        \note The rowDelegate is not affected by this property
    */
    property alias backgroundVisible: colorRect.visible

    /*! This property defines a delegate to draw a specific cell.

    In the item delegate you have access to the following special properties:
    \list
    \li  styleData.selected - if the item is currently selected
    \li  styleData.value - the value or text for this item
    \li  styleData.textColor - the default text color for an item
    \li  styleData.row - the index of the row
    \li  styleData.column - the index of the column
    \li  styleData.elideMode - the elide mode of the column
    \li  styleData.textAlignment - the horizontal text alignment of the column
    \endlist

    Example:
    \code
    itemDelegate: Item {
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: styleData.textColor
            elide: styleData.elideMode
            text: styleData.value
        }
    }
    \endcode */
    property Component itemDelegate: __style ? __style.itemDelegate : null

    /*! This property defines a delegate to draw a row.

    In the row delegate you have access to the following special properties:
    \list
    \li  styleData.alternate - true when the row uses the alternate background color
    \li  styleData.selected - true when the row is currently selected
    \li  styleData.row - the index of the row
    \endlist
    */
    property Component rowDelegate: __style ? __style.rowDelegate : null

    /*! This property defines a delegate to draw a header.

    In the header delegate you have access to the following special properties:
    \list
    \li  styleData.value - the value or text for this item
    \li  styleData.column - the index of the column
    \li  styleData.pressed - true when the column is being pressed
    \li  styleData.containsMouse - true when the column is under the mouse
    \endlist
    */
    property Component headerDelegate: __style ? __style.headerDelegate : null

    /*! Index of the current sort column.
        The default value is \c {0}. */
    property int sortIndicatorColumn

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

    /*! \internal */
    default property alias __columns: root.data

    /*! \qmlproperty Component TableView::contentHeader
    This is the content header of the TableView */
    property alias contentHeader: listView.header

    /*! \qmlproperty Component TableView::contentFooter
    This is the content footer of the TableView */
    property alias contentFooter: listView.footer

    /*! \qmlproperty int TableView::rowCount
    The current number of rows */
    readonly property alias rowCount: listView.count

    /*! \qmlproperty int TableView::columnCount
    The current number of columns */
    readonly property alias columnCount: columnModel.count

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

    /*! \internal */
    property alias __currentRowItem: listView.currentItem

    /*! \qmlsignal TableView::activated(int row)

        Emitted when the user activates an item by mouse or keyboard interaction.
        Mouse activation is triggered by single- or double-clicking, depending on the platform.

        \a row int provides access to the activated row index.
    */
    signal activated(int row)

    /*! \qmlsignal TableView::clicked(int row)

        Emitted when the user clicks a valid row by single clicking

        \a row int provides access to the clicked row index.
    */
    signal clicked(int row)

    /*! \qmlsignal TableView::doubleClicked(int row)

        Emitted when the user double clicks a valid row.

        \a row int provides access to the clicked row index.
    */
    signal doubleClicked(int row)

    /*!
        \qmlmethod TableView::positionViewAtRow( int row, PositionMode mode )

    Positions the view such that the specified \a row is at the position defined by \a mode:
       \list
       \li ListView.Beginning - position item at the top of the view.
       \li ListView.Center - position item in the center of the view.
       \li ListView.End - position item at bottom of the view.
       \li ListView.Visible - if any part of the item is visible then take no action, otherwise bring the item into view.
       \li ListView.Contain - ensure the entire item is visible. If the item is larger than the view the item is positioned
           at the top of the view.
       \endlist

    If positioning the \a row creates an empty space at the beginning
    or end of the view, then the view is positioned at the boundary.

    For example, to position the view at the end at startup:

    \code
    Component.onCompleted: table.positionViewAtRow(rowCount -1, ListView.Contain)
    \endcode

    Depending on how the model is populated, the model may not be ready when
    TableView Component.onCompleted is called. In that case you may need to
    delay the call to positionViewAtRow by using a \l {QtQml::Timer}{Timer}.

    \note This method should only be called after the component has completed.
    */

    function positionViewAtRow(row, mode) {
        listView.positionViewAtIndex(row, mode)
    }

    /*!
        \qmlmethod int TableView::rowAt( int x, int y )

        Returns the index of the visible row at the point \a x, \a y in content
        coordinates. If there is no visible row at the point specified, \c -1 is returned.

        \note This method should only be called after the component has completed.
    */

    function rowAt(x, y) {
        var obj = root.mapToItem(listView.contentItem, x, y)
        return listView.indexAt(obj.x, obj.y)
    }

    /*! Adds a \a column and returns the added column.

        The \a column argument can be an instance of TableViewColumn,
        or a Component. The component has to contain a TableViewColumn.
        Otherwise  \c null is returned.
    */
    function addColumn(column) {
        return insertColumn(columnCount, column)
    }

    /*! Inserts a \a column at the given \a index and returns the inserted column.

        The \a column argument can be an instance of TableViewColumn,
        or a Component. The component has to contain a TableViewColumn.
        Otherwise  \c null is returned.
    */
    function insertColumn(index, column) {
        var object = column
        if (typeof column['createObject'] === 'function')
            object = column.createObject(root)

        else if (object.__view) {
            console.warn("TableView::insertColumn(): you cannot add a column to multiple views")
            return null
        }
        if (index >= 0 && index <= columnCount && object.Accessible.role === Accessible.ColumnHeader) {
            object.__view = root
            columnModel.insert(index, {columnItem: object})
            return object
        }

        if (object !== column)
            object.destroy()
        console.warn("TableView::insertColumn(): invalid argument")
        return null
    }

    /*! Removes and destroys a column at the given \a index. */
    function removeColumn(index) {
        if (index < 0 || index >= columnCount) {
            console.warn("TableView::removeColumn(): invalid argument")
            return
        }
        var column = columnModel.get(index).columnItem
        columnModel.remove(index, 1)
        column.destroy()
    }

    /*! Moves a column \a from index \a to another. */
    function moveColumn(from, to) {
        if (from < 0 || from >= columnCount || to < 0 || to >= columnCount) {
            console.warn("TableView::moveColumn(): invalid argument")
            return
        }
        columnModel.move(from, to, 1)
    }

    /*! Returns the column at the given \a index
        or \c null if the \a index is invalid. */
    function getColumn(index) {
        if (index < 0 || index >= columnCount)
            return null
        return columnModel.get(index).columnItem
    }

    Component.onCompleted: {
        for (var i = 0; i < __columns.length; ++i) {
            var column = __columns[i]
            if (column.Accessible.role === Accessible.ColumnHeader)
                addColumn(column)
        }
    }

    style: Qt.createComponent(Settings.style + "/TableViewStyle.qml", root)


    Accessible.role: Accessible.Table

    implicitWidth: 200
    implicitHeight: 150

    frameVisible: true
    __scrollBarTopMargin: Qt.platform.os === "osx" ? headerrow.height : 0
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
        visible: columnCount > 0
        interactive: false

        SystemPalette {
            id: palette
            colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
        }

        Rectangle {
            id: colorRect
            parent: viewport
            anchors.fill: parent
            color: __style ? __style.backgroundColor : palette.base
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
            Timer { running: mousearea.autoincrement && __verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: __incrementCurrentIndex()}
            Timer { running: mousearea.autodecrement && __verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: __decrementCurrentIndex()}

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

                if (pressed) {
                    var newIndex = listView.indexAt(0, mouseY + listView.contentY)
                    if (newIndex >= 0)
                        listView.currentIndex = newIndex;
                }
            }

            onClicked: {
                var clickIndex = listView.indexAt(0, mouseY + listView.contentY)
                if (clickIndex > -1) {
                    if (root.__activateItemOnSingleClick)
                        root.activated(clickIndex)
                    root.clicked(clickIndex)
                }
                mouse.accepted = false
            }

            onPressed: {
                var newIndex = listView.indexAt(0, mouseY + listView.contentY)
                listView.forceActiveFocus()
                if (newIndex > -1) {
                    listView.currentIndex = newIndex
                }
            }

            onDoubleClicked: {
                var clickIndex = listView.indexAt(0, mouseY + listView.contentY)
                if (clickIndex > -1) {
                    if (!root.__activateItemOnSingleClick)
                        root.activated(clickIndex)
                    root.doubleClicked(clickIndex)
                }
            }

            // Note:  with boolean preventStealing we are keeping the flickable from
            // eating our mouse press events
            preventStealing: true

        }

        // Fills extra rows with alternate color
        Column {
            id: rowfiller
            property int rowHeight: count ? listView.contentHeight/count : height
            property int paddedRowCount: height/rowHeight
            property int count: listView.count
            y: listView.contentHeight
            width: parent.width
            visible: listView.contentHeight > 0 && alternatingRowColors
            height: viewport.height - listView.contentHeight
            Repeater {
                model: visible ? parent.paddedRowCount : 0
                Loader {
                    width: rowfiller.width
                    height: rowfiller.rowHeight
                    sourceComponent: root.rowDelegate
                    property QtObject styleData: QtObject {
                        readonly property bool alternate: (index + rowCount) % 2 === 1
                        readonly property bool selected: false
                        readonly property bool hasActiveFocus: root.activeFocus
                    }
                    readonly property var model: listView.model
                    readonly property var modelData: null
                }
            }
        }

        ListModel {
            id: columnModel
        }

        highlightFollowsCurrentItem: true
        model: root.model

        Keys.onUpPressed: {
            event.accepted = false
            root.__decrementCurrentIndex()
        }

        Keys.onDownPressed: {
            event.accepted = false
            root.__incrementCurrentIndex()
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_PageUp) {
                verticalScrollBar.value = __verticalScrollBar.value - listView.height
            } else if (event.key === Qt.Key_PageDown)
                verticalScrollBar.value = __verticalScrollBar.value + listView.height
        }

        Keys.onReturnPressed: {
            event.accepted = false
            if (currentRow > -1)
                root.activated(currentRow);
        }

        delegate: Item {
            id: rowitem
            width: itemrow.width
            height: rowstyle.height

            readonly property int rowIndex: model.index
            readonly property bool alternate: alternatingRowColors && rowIndex % 2 == 1
            readonly property var itemModelData: typeof modelData == "undefined" ? null : modelData
            readonly property var itemModel: model
            readonly property bool itemSelected: ListView.isCurrentItem
            readonly property color itemTextColor: itemSelected ? __style.highlightedTextColor : __style.textColor

            Loader {
                id: rowstyle
                // row delegate
                sourceComponent: root.rowDelegate
                // Row fills the view width regardless of item size
                // But scrollbar should not adjust to it
                height: item ? item.height : 16
                width: parent.width + __horizontalScrollBar.width
                x: listView.contentX

                // these properties are exposed to the row delegate
                // Note: these properties should be mirrored in the row filler as well
                property QtObject styleData: QtObject {
                    readonly property int row: rowitem.rowIndex
                    readonly property bool alternate: rowitem.alternate
                    readonly property bool selected: rowitem.itemSelected
                    readonly property bool hasActiveFocus: root.activeFocus
                }
                readonly property var model: listView.model
                readonly property var modelData: rowitem.itemModelData
            }
            Row {
                id: itemrow
                height: parent.height
                Repeater {
                    id: repeater
                    model: columnModel

                    Loader {
                        id: itemDelegateLoader
                        width:  __column.width
                        height: parent ? parent.height : 0
                        visible: __column.visible
                        sourceComponent: __column.delegate ? __column.delegate : itemDelegate

                        // these properties are exposed to the item delegate
                        readonly property var model: listView.model
                        readonly property var modelData: itemModelData

                        property QtObject styleData: QtObject {
                            readonly property var value: __hasModelRole ? itemModel[role] // Qml ListModel and QAbstractItemModel
                                                                            : __hasModelDataRole ? modelData[role] // QObjectList / QObject
                                                                                                 : modelData != undefined ? modelData : "" // Models without role
                            readonly property int row: rowitem.rowIndex
                            readonly property int column: index
                            readonly property int elideMode: __column.elideMode
                            readonly property int textAlignment: __column.horizontalAlignment
                            readonly property bool selected: rowitem.itemSelected
                            readonly property color textColor: rowitem.itemTextColor
                            readonly property string role: __column.role
                        }

                        readonly property TableViewColumn __column: columnItem
                        readonly property bool __hasModelRole: styleData.role && itemModel.hasOwnProperty(styleData.role)
                        readonly property bool __hasModelDataRole: styleData.role && modelData && modelData.hasOwnProperty(styleData.role)
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
            anchors.rightMargin: (frameVisible ? __scroller.rightMargin : 0) +
                                 (__scroller.outerFrame && __scrollBarTopMargin ? 0 : __verticalScrollBar.width
                                                          + __scroller.scrollBarSpacing + root.__style.padding.right)

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

                    model: columnModel

                    delegate: Item {
                        z:-index
                        width: columnCount == 1 ? viewport.width + __verticalScrollBar.width : modelData.width
                        visible: modelData.visible
                        height: headerVisible ? headerStyle.height : 0

                        Loader {
                            id: headerStyle
                            sourceComponent: root.headerDelegate
                            anchors.left: parent.left
                            anchors.right: parent.right
                            property QtObject styleData: QtObject {
                                readonly property string value: modelData.title
                                readonly property bool pressed: headerClickArea.pressed
                                readonly property bool containsMouse: headerClickArea.containsMouse
                                readonly property int column: index
                            }
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
                                if (sortIndicatorColumn == index)
                                    sortIndicatorOrder = sortIndicatorOrder == Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                                sortIndicatorColumn = index
                            }
                            // Here we handle moving header sections
                            // NOTE: the direction is different from the master branch
                            // so this indicates that I am using an invalid assumption on item ordering
                            onPositionChanged: {
                                if (pressed && columnCount > 1) { // only do this while dragging
                                    for (var h = columnCount-1 ; h >= 0 ; --h) {
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
                                    columnModel.move(index, repeater.targetIndex, 1)
                                    if (sortIndicatorColumn == index)
                                        sortIndicatorColumn = repeater.targetIndex
                                }
                                repeater.targetIndex = -1
                            }
                            drag.maximumX: 1000
                            drag.minimumX: -1000
                            drag.target: columnCount > 1 ? draghandle : null
                        }

                        Loader {
                            id: draghandle
                            property QtObject styleData: QtObject{
                                readonly property string value: modelData.title
                                readonly property bool pressed: headerClickArea.pressed
                                readonly property bool containsMouse: headerClickArea.containsMouse
                                readonly property int column: index
                            }

                            parent: tableHeader
                            width: modelData.width
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
                            enabled: columnCount > 1
                            onPositionChanged:  {
                                var newHeaderWidth = modelData.width + (mouseX - offset)
                                modelData.width = Math.max(minimumSize, newHeaderWidth)
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
                                    modelData.width = minWidth
                            }
                            onPressedChanged: if (pressed) offset=mouseX
                            cursorShape: enabled ? Qt.SplitHCursor : Qt.ArrowCursor
                        }
                    }
                }
            }
            Loader {
                id: loader
                property QtObject styleData: QtObject{
                    readonly property string value: ""
                    readonly property bool pressed: false
                    readonly property bool containsMouse: false
                    readonly property int column: -1
                }

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: headerrow.bottom
                anchors.rightMargin: -2
                sourceComponent: root.headerDelegate
                width: root.width - headerrow.width + 2
                visible: root.columnCount
                z:-1
            }
        }
    }
}
