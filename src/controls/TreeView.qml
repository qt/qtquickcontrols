/****************************************************************************
**
** Copyright (C) 2015 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.2
import QtQml.Models 2.2

/*!
   \qmltype TreeView
   \inqmlmodule QtQuick.Controls
   \since 5.5
   \ingroup views
   \brief Provides a tree view with scroll bars, styling and header sections.

   \image treeview.png

   A TreeView implements a tree representation of items from a model.

   Data for each row in the TreeView
   is provided by the model. TreeView accepts models derived from the QAbstractItemModel class.

   You provide title and size of a column header
   by adding a \l TableViewColumn as demonstrated below.

   \code
   TreeView {
       TableViewColumn {
           title: "Name"
           role: "fileName"
           width: 300
       }
       TableViewColumn {
           title: "Permissions"
           role: "filePermissions"
           width: 100
       }
       model: fileSystemModel
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

   You can create a custom appearance for a TreeView by
   assigning a \l {QtQuick.Controls.Styles::TreeViewStyle}{TreeViewStyle}.
*/

BasicTableView {
    id: root

    /*!
        \qmlproperty QAbstractItemModel TreeView::model
        This property holds the model providing data for the tree view.

        The model provides the set of data that is displayed by the view.
        The TreeView accept models derived from the QAbstractItemModel class.
    */
    property var model: null

    /*!
        \qmlproperty QModelIndex TreeView::currentIndex
        The model index of the current row in the tree view.
    */
    readonly property var currentIndex: modelAdaptor.mapRowToModelIndex(__currentRow)

    /*!
        \qmlproperty ItemSelectionModel TreeView::selection

        By default the selection model is \c null and only single selection is supported.

        To use a different selection mode as described in \l {BasicTableView::selectionMode}{selectionMode},
        an ItemSelectionModel must by set to the selection.

        For example:

        \code
        TreeView {
           model: myModel
           selection: ItemSelectionModel {
                model: myModel
           }
           TableViewColumn {
               role: "name"
               title: "Name
           }
        }
        \endcode

        \sa {BasicTableView::selectionMode}{selectionMode}

    */
    property ItemSelectionModel selection: null

    /*!
        \qmlsignal TreeView::activated(QModelIndex index)

        Emitted when the user activates a row in the tree by mouse or keyboard interaction.
        Mouse activation is triggered by single- or double-clicking, depending on the platform.

        \a index is the model index of the activated row in the tree.

        \note This signal is only emitted for mouse interaction that is not blocked in the row or item delegate.

        The corresponding handler is \c onActivated.
    */
    signal activated(var index)

    /*!
        \qmlsignal TreeView::clicked(QModelIndex index)

        Emitted when the user clicks a valid row in the tree by single clicking

        \a index is the model index of the clicked row in the tree.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onClicked.
    */
    signal clicked(var index)

    /*!
        \qmlsignal TreeView::doubleClicked(QModelIndex index)

        Emitted when the user presses and holds a valid row in the tree.

        \a index is the model index of the double clicked row in the tree.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onPressAndHold.
    */
    signal doubleClicked(var index)

    /*!
        \qmlsignal TreeView::pressAndHold(QModelIndex index)

        Emitted when the user presses and holds a valid row in the tree.

        \a index is the model index of the pressed row in the tree.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onPressAndHold.
    */
    signal pressAndHold(var index)

    /*!
        \qmlsignal TreeView::expanded(QModelIndex index)

        Emitted when a valid row in the tree is expanded, displaying its children.

        \a index is the model index of the expanded row in the tree.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onExpanded.
    */
    signal expanded(var index)

    /*!
        \qmlsignal TreeView::collapsed(QModelIndex index)

        Emitted when a valid row in the tree is collapsed, hiding its children.

        \a index is the model index of the collapsed row in the tree.

        \note This signal is only emitted if the row or item delegate does not accept mouse events.

        The corresponding handler is \c onCollapsed.
    */
    signal collapsed(var index)

    /*!
        \qmlmethod bool TreeView::isExpanded(QModelIndex index)

        Returns true if the model item index is expanded; otherwise returns false.

        \sa {expanded}, {expand}
    */
    function isExpanded(index) {
        return modelAdaptor.isExpanded(index)
    }

    /*!
        \qmlmethod void TreeView::collapse(QModelIndex index)

        Collapses the model item specified by the index.

        \sa {collapsed}, {isExpanded}
    */
    function collapse(index) {
        modelAdaptor.collapse(index)
    }

    /*!
        \qmlmethod void TreeView::expand(QModelIndex index)

        Expands the model item specified by the index.

        \sa {expanded}, {isExpanded}
    */
    function expand(index) {
        modelAdaptor.expand(index)
    }

    style: Qt.createComponent(Settings.style + "/TreeViewStyle.qml", root)

    // Internal stuff. Do not look

    __viewTypeName: "TreeView"

    __model: TreeModelAdaptor {
        id: modelAdaptor
        model: root.model

        onExpanded: root.expanded(index)
        onCollapsed: root.collapsed(index)
    }

    onSelectionModeChanged: if (!!selection) selection.clear()

    __mouseArea: MouseArea {
        id: mouseArea

        parent: __listView
        width: __listView.width
        height: __listView.height
        z: -1
        propagateComposedEvents: true
        focus: true
        // Note:  with boolean preventStealing we are keeping
        // the flickable from eating our mouse press events
        preventStealing: !Settings.hasTouchScreen

        property int clickedRow: -1
        property int pressedRow: -1
        property int pressedColumn: -1
        readonly property alias currentRow: root.__currentRow

        // Handle vertical scrolling whem dragging mouse outside boundaries
        property int autoScroll: 0 // 0 -> do nothing; 1 -> increment; 2 -> decrement
        property bool shiftPressed: false // forward shift key state to the autoscroll timer

        Timer {
            running: mouseArea.autoScroll !== 0 && __verticalScrollBar.visible
            interval: 20
            repeat: true
            onTriggered: {
                var oldPressedRow = mouseArea.pressedRow
                var row
                if (mouseArea.autoScroll === 1) {
                    __listView.incrementCurrentIndexBlocking();
                    row = __listView.indexAt(0, __listView.height + __listView.contentY)
                    if (row === -1)
                        row = __listView.count - 1
                } else {
                    __listView.decrementCurrentIndexBlocking();
                    row = __listView.indexAt(0, __listView.contentY)
                }

                if (row !== oldPressedRow) {
                    mouseArea.pressedRow = row
                    var modifiers = mouseArea.shiftPressed ? Qt.ShiftModifier : Qt.NoModifier
                    mouseArea.mouseSelect(row, modifiers, true /* drag */)
                }
            }
        }

        function mouseSelect(row, modifiers, drag) {
            if (!selection) {
                maybeWarnAboutSelectionMode()
                return
            }

            if (selectionMode) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(row)
                if (selectionMode === SelectionMode.SingleSelection) {
                    selection.setCurrentIndex(modelIndex, ItemSelectionModel.NoUpdate)
                } else {
                    var itemSelection = clickedRow === row ? modelIndex
                                        : modelAdaptor.selectionForRowRange(clickedRow, row)
                    if (selectionMode === SelectionMode.MultiSelection
                        || modifiers & Qt.ControlModifier) {
                        if (drag)
                            selection.select(itemSelection, ItemSelectionModel.ToggleCurrent)
                        else
                            selection.select(modelIndex, ItemSelectionModel.Toggle)
                    } else if (modifiers & Qt.ShiftModifier) {
                        selection.select(itemSelection, ItemSelectionModel.SelectCurrent)
                    } else {
                        clickedRow = row // Needed only when drag is true
                        selection.select(modelIndex, ItemSelectionModel.ClearAndSelect)
                    }
                }
            }
        }

        function keySelect(keyModifiers) {
            if (selectionMode) {
                if (!keyModifiers)
                    clickedRow = currentRow
                if (!(keyModifiers & Qt.ControlModifier))
                    mouseSelect(currentRow, keyModifiers, keyModifiers & Qt.ShiftModifier)
            }
        }

        function selected(row) {
            if (selectionMode === SelectionMode.NoSelection)
                return false

            var modelIndex = null
            if (!!selection) {
                modelIndex = modelAdaptor.mapRowToModelIndex(row)
                if (modelIndex.valid) {
                    if (selectionMode === SelectionMode.SingleSelection)
                        return selection.currentIndex === modelIndex
                    return selection.hasSelection && selection.isSelected(modelIndex)
                }
            }

            return row === currentRow
                   && (selectionMode === SelectionMode.SingleSelection
                       || (selectionMode > SelectionMode.SingleSelection && !selection))
        }

        function branchDecorationContains(x, y) {
            var clickedItem = __listView.itemAt(0, y + __listView.contentY)
            if (!(clickedItem && clickedItem.rowItem))
                return false
            var branchDecoration = clickedItem.rowItem.branchDecoration
            if (!branchDecoration)
                return false
            var pos = mapToItem(branchDecoration, x, y)
            return branchDecoration.contains(Qt.point(pos.x, pos.y))
        }

        function maybeWarnAboutSelectionMode() {
            if (selectionMode > SelectionMode.SingleSelection)
                console.warn("TreeView: Non-single selection is not supported without an ItemSelectionModel.")
        }

        onPressed: {
            pressedRow = __listView.indexAt(0, mouseY + __listView.contentY)
            pressedColumn = __listView.columnAt(mouseX)
            __listView.forceActiveFocus()
            if (pressedRow > -1 && !Settings.hasTouchScreen
                && !branchDecorationContains(mouse.x, mouse.y)) {
                __listView.currentIndex = pressedRow
                if (clickedRow === -1)
                    clickedRow = pressedRow
                mouseSelect(pressedRow, mouse.modifiers, false)
                if (!mouse.modifiers)
                    clickedRow = pressedRow
            }
        }

        onReleased: {
            pressedRow = -1
            pressedColumn = -1
            autoScroll = 0
        }

        onPositionChanged: {
            // NOTE: Testing for pressed is not technically needed, at least
            // until we decide to support tooltips or some other hover feature
            if (mouseY > __listView.height && pressed) {
                if (autoScroll === 1) return;
                autoScroll = 1
            } else if (mouseY < 0 && pressed) {
                if (autoScroll === 2) return;
                autoScroll = 2
            } else  {
                autoScroll = 0
            }

            if (pressed && containsMouse) {
                var oldPressedRow = pressedRow
                pressedRow = __listView.indexAt(0, mouseY + __listView.contentY)
                pressedColumn = __listView.columnAt(mouseX)
                if (pressedRow > -1 && oldPressedRow !== pressedRow) {
                    __listView.currentIndex = pressedRow
                    mouseSelect(pressedRow, mouse.modifiers, true /* drag */)
                }
            }
        }

        onExited: {
            pressedRow = -1
            pressedColumn = -1
        }

        onCanceled: {
            pressedRow = -1
            pressedColumn = -1
            autoScroll = 0
        }

        onClicked: {
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(clickIndex)
                if (branchDecorationContains(mouse.x, mouse.y)) {
                    if (modelAdaptor.isExpanded(modelIndex))
                        modelAdaptor.collapse(modelIndex)
                    else
                        modelAdaptor.expand(modelIndex)
                } else if (root.__activateItemOnSingleClick) {
                    root.activated(modelIndex)
                }
                root.clicked(modelIndex)
            }
        }

        onDoubleClicked: {
            var clickIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (clickIndex > -1) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(clickIndex)
                if (!root.__activateItemOnSingleClick)
                    root.activated(modelIndex)
                root.doubleClicked(modelIndex)
            }
        }

        onPressAndHold: {
            var pressIndex = __listView.indexAt(0, mouseY + __listView.contentY)
            if (pressIndex > -1) {
                var modelIndex = modelAdaptor.mapRowToModelIndex(pressIndex)
                root.pressAndHold(modelIndex)
            }
        }

        Keys.forwardTo: [root]

        Keys.onUpPressed: {
            event.accepted = __listView.decrementCurrentIndexBlocking()
            keySelect(event.modifiers)
        }

        Keys.onDownPressed: {
            event.accepted = __listView.incrementCurrentIndexBlocking()
            keySelect(event.modifiers)
        }

        Keys.onRightPressed: {
            if (root.currentIndex.valid)
                root.expand(currentIndex)
            else
                event.accepted = false
        }

        Keys.onLeftPressed: {
            if (root.currentIndex.valid)
                root.collapse(currentIndex)
            else
                event.accepted = false
        }

        Keys.onReturnPressed: {
            if (root.currentIndex.valid)
                root.activated(currentIndex)
            else
                event.accepted = false
        }

        Keys.onPressed: {
            __listView.scrollIfNeeded(event.key)

            if (event.key === Qt.Key_A && event.modifiers & Qt.ControlModifier
                && !!selection && selectionMode > SelectionMode.SingleSelection) {
                var sel = modelAdaptor.selectionForRowRange(0, __listView.count - 1)
                selection.select(sel, ItemSelectionModel.SelectCurrent)
            } else if (event.key === Qt.Key_Shift) {
                shiftPressed = true
            }
        }

        Keys.onReleased: {
            if (event.key === Qt.Key_Shift)
                shiftPressed = false
        }
    }
}
