/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Window 2.1

/*!
   \qmltype TableView
   \inqmlmodule QtQuick.Controls
   \since 5.1
   \ingroup views
   \brief Provides a list view with scroll bars, styling and header sections.

   \image tableview.png

   A TableView is similar to \l ListView, and adds scroll bars, selection, and
   resizable header sections. As with \l ListView, data for each row is provided through a \l model:

   \code
   ListModel {
       id: libraryModel
       ListElement {
           title: "A Masterpiece"
           author: "Gabriel"
       }
       ListElement {
           title: "Brilliance"
           author: "Jens"
       }
       ListElement {
           title: "Outstanding"
           author: "Frederik"
       }
   }
   \endcode

   You provide title and size of a column header
   by adding a \l TableViewColumn as demonstrated below.

   \code
   TableView {
       TableViewColumn {
           role: "title"
           title: "Title"
           width: 100
       }
       TableViewColumn {
           role: "author"
           title: "Author"
           width: 200
       }
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

    You can create a custom appearance for a TableView by
    assigning a \l {QtQuick.Controls.Styles::TableViewStyle}{TableViewStyle}.
*/

BasicTableView {
    id: root

    /*! \qmlproperty model TableView::model
    This property holds the model providing data for the table view.

    The model provides the set of data that is used to create the items in the view.
    Models can be created directly in QML using ListModel, XmlListModel or VisualItemModel,
    or provided by C++ model classes. \sa ListView::model

    Example model:

    \code
    model: ListModel {
        ListElement {
            column1: "value 1"
            column2: "value 2"
        }
        ListElement {
            column1: "value 3"
            column2: "value 4"
        }
    }
    \endcode
    \sa {qml-data-models}{Data Models}
    */
    property var model

    /*! \qmlproperty int TableView::rowCount
    The current number of rows */
    readonly property int rowCount: __listView.count

    /*! \qmlproperty int TableView::currentRow
    The current row index of the view.
    The default value is \c -1 to indicate that no row is selected.
    */
    property alias currentRow: root.__currentRow

    /*! \qmlsignal TableView::activated(int row)

        Emitted when the user activates an item by mouse or keyboard interaction.
        Mouse activation is triggered by single- or double-clicking, depending on the platform.

        \a row int provides access to the activated row index.

        \note This signal is only emitted for mouse interaction that is not blocked in the row or item delegate.

        The corresponding handler is \c onActivated.
    */
    signal activated(int row)

    /*! \qmlsignal TableView::clicked(int row)

        Emitted when the user clicks a valid row by single clicking

        \a row int provides access to the clicked row index.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onClicked.
    */
    signal clicked(int row)

    /*! \qmlsignal TableView::doubleClicked(int row)

        Emitted when the user double clicks a valid row.

        \a row int provides access to the clicked row index.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onDoubleClicked.
    */
    signal doubleClicked(int row)

    /*! \qmlsignal TableView::pressAndHold(int row)
        \since QtQuick.Controls 1.3

        Emitted when the user presses and holds a valid row.

        \a row int provides access to the pressed row index.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onPressAndHold.
    */
    signal pressAndHold(int row)

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
        __listView.positionViewAtIndex(row, mode)
    }

    /*!
        \qmlmethod int TableView::rowAt( int x, int y )

        Returns the index of the visible row at the point \a x, \a y in content
        coordinates. If there is no visible row at the point specified, \c -1 is returned.

        \note This method should only be called after the component has completed.
    */
    function rowAt(x, y) {
        var obj = root.mapToItem(__listView.contentItem, x, y)
        return __listView.indexAt(obj.x, obj.y)
    }

    /*! \qmlproperty Selection TableView::selection
        \since QtQuick.Controls 1.1

        This property contains the current row-selection of the \l TableView.
        The selection allows you to select, deselect or iterate over selected rows.

        \list
        \li function \b clear() - deselects all rows
        \li function \b selectAll() - selects all rows
        \li function \b select(from, to) - select a range
        \li functton \b deselect(from, to) - de-selects a range
        \li function \b forEach(callback) - iterates over all selected rows
        \li function \b contains(index) - checks whether the selection includes the given index
        \li signal \b selectionChanged() - the current row selection changed
        \li readonly property int \b count - the number of selected rows
        \endlist

        \b Example:
        \code
            tableview.selection.select(0)       // select row index 0

            tableview.selection.select(1, 3)    // select row indexes 1, 2 and 3

            tableview.selection.deselect(0, 1)  // deselects row index 0 and 1

            tableview.selection.deselect(2)     // deselects row index 2
        \endcode

        \b Example: To iterate over selected indexes, you can pass a callback function.
                    \a rowIndex is passed as as an argument to the callback function.
        \code
            tableview.selection.forEach( function(rowIndex) {console.log(rowIndex)} )
        \endcode
    */
    readonly property alias selection: selectionObject

    onModelChanged: selection.clear()

    style: Settings.styleComponent(Settings.style, "TableViewStyle.qml", root)

    Accessible.role: Accessible.Table

    __viewTypeName: "TableView"
    __model: model

    __itemDelegateLoader: TableViewItemDelegateLoader {
        __style: root.__style
        __itemDelegate: root.itemDelegate
        __mouseArea: mousearea
    }

    __mouseArea: MouseArea {
        id: mousearea

        parent: __listView
        width: __listView.width
        height: __listView.height
        z: -1
        propagateComposedEvents: true
        focus: true

        property bool autoincrement: false
        property bool autodecrement: false
        property int previousRow: 0
        property int clickedRow: -1
        property int dragRow: -1
        property int firstKeyRow: -1
        property int pressedRow: -1
        property int pressedColumn: -1

        TableViewSelection {
            id: selectionObject
        }

        function selected(rowIndex) {
            if (dragRow > -1 && (rowIndex >= clickedRow && rowIndex <= dragRow
                                 || rowIndex <= clickedRow && rowIndex >= dragRow))
                return selection.contains(clickedRow)

            return selection.count && selection.contains(rowIndex)
        }

        onReleased: {
            pressedRow = -1
            pressedColumn = -1
            autoincrement = false
            autodecrement = false
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                if (Settings.hasTouchScreen) {
                    __listView.currentIndex = clickIndex
                    mouseSelect(clickIndex, mouse.modifiers)
                }
                previousRow = clickIndex
            }

            if (mousearea.dragRow >= 0) {
                selection.__select(selection.contains(mousearea.clickedRow), mousearea.clickedRow, mousearea.dragRow)
                mousearea.dragRow = -1
            }
        }

        function decrementCurrentIndex() {
            __listView.decrementCurrentIndexBlocking();

            var newIndex = __listView.indexAt(0, __listView.contentY)
            if (newIndex !== -1) {
                if (selectionMode > SelectionMode.SingleSelection)
                    mousearea.dragRow = newIndex
                else if (selectionMode === SelectionMode.SingleSelection)
                    selection.__selectOne(newIndex)
            }
        }

        function incrementCurrentIndex() {
            __listView.incrementCurrentIndexBlocking();

            var newIndex = Math.max(0, __listView.indexAt(0, __listView.height + __listView.contentY))
            if (newIndex !== -1) {
                if (selectionMode > SelectionMode.SingleSelection)
                    mousearea.dragRow = newIndex
                else if (selectionMode === SelectionMode.SingleSelection)
                    selection.__selectOne(newIndex)
            }
        }

        // Handle vertical scrolling whem dragging mouse outside boundraries
        Timer {
            running: mousearea.autoincrement && __verticalScrollBar.visible
            repeat: true
            interval: 20
            onTriggered: mousearea.incrementCurrentIndex()
        }

        Timer {
            running: mousearea.autodecrement && __verticalScrollBar.visible
            repeat: true
            interval: 20
            onTriggered: mousearea.decrementCurrentIndex()
        }

        onPositionChanged: {
            if (mouseY > __listView.height && pressed) {
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

            if (pressed && containsMouse) {
                pressedRow = Math.max(0, __listView.indexAt(0, mouseY + __listView.contentY))
                pressedColumn = __listView.columnAt(mouseX)
                if (!Settings.hasTouchScreen) {
                    if (pressedRow >= 0 && pressedRow !== currentRow) {
                        __listView.currentIndex = pressedRow;
                        if (selectionMode === SelectionMode.SingleSelection) {
                            selection.__selectOne(pressedRow)
                        } else if (selectionMode > 1) {
                            dragRow = pressedRow
                        }
                    }
                }
            }
        }

        onClicked: {
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                if (root.__activateItemOnSingleClick)
                    root.activated(clickIndex)
                root.clicked(clickIndex)
            }
        }

        onPressed: {
            pressedRow = __listView.indexAt(0, mouseY + __listView.contentY)
            pressedColumn = __listView.columnAt(mouseX)
            __listView.forceActiveFocus()
            if (pressedRow > -1 && !Settings.hasTouchScreen) {
                __listView.currentIndex = pressedRow
                mouseSelect(pressedRow, mouse.modifiers)
                mousearea.clickedRow = pressedRow
            }
        }

        onExited: {
            mousearea.pressedRow = -1
            mousearea.pressedColumn = -1
        }

        onCanceled: {
            mousearea.pressedRow = -1
            mousearea.pressedColumn = -1
        }

        function mouseSelect(index, modifiers) {
            if (selectionMode) {
                if (modifiers & Qt.ShiftModifier && (selectionMode === SelectionMode.ExtendedSelection)) {
                    selection.select(previousRow, index)
                } else if (selectionMode === SelectionMode.MultiSelection ||
                           (selectionMode === SelectionMode.ExtendedSelection && modifiers & Qt.ControlModifier)) {
                    selection.__select(!selection.contains(index) , index)
                } else {
                    selection.__selectOne(index)
                }
            }
        }

        onDoubleClicked: {
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                if (!root.__activateItemOnSingleClick)
                    root.activated(clickIndex)
                root.doubleClicked(clickIndex)
            }
        }

        onPressAndHold: {
            var pressIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (pressIndex > -1)
                root.pressAndHold(pressIndex)
        }

        // Note:  with boolean preventStealing we are keeping the flickable from
        // eating our mouse press events
        preventStealing: !Settings.hasTouchScreen

        function keySelect(shiftPressed, row) {
            if (row < 0 || row > rowCount - 1)
                return
            if (shiftPressed && (selectionMode >= SelectionMode.ExtendedSelection)) {
                selection.__ranges = new Array()
                selection.select(mousearea.firstKeyRow, row)
            } else {
                selection.__selectOne(row)
            }
        }

        Keys.forwardTo: [root]

        Keys.onUpPressed: {
            event.accepted = __listView.decrementCurrentIndexBlocking()
            if (selectionMode)
                keySelect(event.modifiers & Qt.ShiftModifier, currentRow)
        }

        Keys.onDownPressed: {
            event.accepted = __listView.incrementCurrentIndexBlocking()
            if (selectionMode)
                keySelect(event.modifiers & Qt.ShiftModifier, currentRow)
        }

        Keys.onPressed: {
            __listView.scrollIfNeeded(event.key)

            if (event.key === Qt.Key_Shift) {
                firstKeyRow = currentRow
            }

            if (event.key === Qt.Key_A && event.modifiers & Qt.ControlModifier) {
                if (selectionMode > 1)
                    selection.selectAll()
            }
        }

        Keys.onReleased: {
            if (event.key === Qt.Key_Shift)
                firstKeyRow = -1
        }

        Keys.onReturnPressed: {
            if (currentRow > -1)
                root.activated(currentRow);
            else
                event.accepted = false
        }
    }
}
