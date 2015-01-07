/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
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

import QtQuick 2.4
import QtTest 1.0
import QtQuick.Controls 1.4
import QtQuickControlsTests 1.0

Item {
    id: container
    width: 400
    height: 400

    TestCase {
        id: testCase
        name: "Tests_TreeView"
        when:windowShown
        width:400
        height:400
        objectName: "testCase"

        SignalSpy {
            id: spy
        }

        Component {
            id: newColumn
            TableViewColumn {
                role: "name"
                title: "Name"
            }
        }

        property var instance_selectionModel: 'import QtQml.Models 2.2; ItemSelectionModel {}'
        property var semiIndent: 20/2 // PM_TreeViewIndentation 20 in commonStyle

        function cleanup()
        {
            // Make sure to delete all children even when the test has failed.
            for (var child in container.children) {
                if (container.children[child].objectName !== "testCase")
                    container.children[child].destroy()
            }
        }

        function test_basic_setup()
        {
            var test_instanceStr =
                    'import QtQuick 2.4;             \
                     import QtQuick.Controls 1.4;    \
                     import QtQuickControlsTests 1.0;\
                     TreeView {                      \
                         model: TreeModel {}         \
                         TableViewColumn {           \
                             role: "display";        \
                             title: "Default";       \
                         }                           \
                     }'

            var tree = Qt.createQmlObject(test_instanceStr, container, '')
            verify(!tree.currentIndex.valid)
            compare(tree.columnCount, 1)
            tree.addColumn(newColumn)
            compare(tree.columnCount, 2)
            tree.destroy()
        }

        function test_clicked_signals()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            tree.forceActiveFocus()

            verify(!tree.currentIndex.valid)
            spy.clear()
            spy.target = tree
            spy.signalName = "clicked"
            compare(spy.count, 0)
            mouseClick(tree, semiIndent + 50, 120, Qt.LeftButton)
            compare(spy.count, 1)
            var clickedItem = spy.signalArguments[0][0]
            verify(clickedItem.valid)
            compare(clickedItem.row, 1)
            compare(tree.currentIndex.row, 1)
            compare(clickedItem.internalId, tree.currentIndex.internalId)

            // TO FIX
//            spy.clear()
//            spy.target = tree
//            spy.signalName = "doubleClicked"
//            compare(spy.count, 0)
//            mouseDoubleClick(tree, semiIndent + 50, 120, Qt.LeftButton)
//            compare(spy.count, 1)
//            verify(spy.signalArguments[1][0].valid)
//            compare(spy.signalArguments[1][0].row, 2)
//            compare(tree.currentIndex.row, 2)

//            spy.clear()
//            spy.target = tree
//            spy.signalName = "activated"
//            compare(spy.count, 0)
//            if (!tree.__activateItemOnSingleClick)
//                mouseDoubleClick(tree, semiIndent + 50 , 120, Qt.LeftButton)
//            else
//                mouseClick(tree, semiIndent + 50, 120, Qt.LeftButton)
//            compare(spy.count, 1)
//            verify(spy.signalArguments[0][0].valid)
//            compare(spy.signalArguments[0][0].row, 1)
//            compare(tree.currentIndex.row, 1)
//            tree.destroy()
        }

        function test_headerHidden()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            tree.headerVisible = false
            tree.forceActiveFocus()

            verify(!tree.currentIndex.valid)
            spy.clear()
            spy.target = tree
            spy.signalName = "clicked"
            compare(spy.count, 0)
            mouseClick(tree, semiIndent + 50, 20, Qt.LeftButton)
            compare(spy.count, 1)
            verify(spy.signalArguments[0][0].valid)
            compare(spy.signalArguments[0][0].row, 0)
            compare(tree.currentIndex.row, 0)
            tree.destroy()
        }

        function test_expand_collapse()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)
            tree.forceActiveFocus()

            spy.clear()
            spy.target = tree
            spy.signalName = "expanded"

            // expanded on click
            compare(spy.count, 0)
            mouseClick(tree, semiIndent, 70, Qt.LeftButton)
            compare(spy.count, 1)
            var expandedIndex = spy.signalArguments[0][0]
            verify(expandedIndex.valid)
            compare(expandedIndex.row, 0)
            compare(tree.isExpanded(expandedIndex), true)

            // expand first child on click
            mouseClick(tree, semiIndent * 3, 120, Qt.LeftButton)
            compare(spy.count, 2)
            var childIndex = spy.signalArguments[1][0]
            verify(childIndex.valid)
            compare(childIndex.row, 0)
            compare(tree.isExpanded(childIndex), true)
            compare(childIndex.parent.internalId, expandedIndex.internalId)

            spy.clear()
            spy.signalName = "collapsed"

            // collapsed on click top item
            compare(spy.count, 0)
            mouseClick(tree, semiIndent, 70, Qt.LeftButton)
            compare(spy.count, 1)
            var collapsedIndex = spy.signalArguments[0][0]
            verify(collapsedIndex.valid)
            compare(collapsedIndex.row, 0)
            compare(tree.isExpanded(collapsedIndex), false)
            compare(expandedIndex.internalId, collapsedIndex.internalId)

            // check hidden child is still expanded
            compare(tree.isExpanded(childIndex), true)

            // collapse child with function
            tree.collapse(childIndex)
            compare(tree.isExpanded(childIndex), false)
            compare(spy.count, 2)
            compare(spy.signalArguments[1][0].row, 0)

            spy.clear()
            spy.signalName = "expanded"
            compare(spy.count, 0)

            // expand child with function
            tree.expand(expandedIndex)
            compare(tree.isExpanded(expandedIndex), true)
            compare(spy.count, 1)
            compare(spy.signalArguments[0][0].row, 0)

            tree.destroy()
        }

        function test_pressAndHold()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            tree.forceActiveFocus()

            var styleIndent = !!tree.style.indentation ? tree.style.indentation/2 : 6
            verify(!tree.currentIndex.valid)
            spy.clear()
            spy.target = tree
            spy.signalName = "pressAndHold"
            compare(spy.count, 0)
            mousePress(tree, styleIndent + 50, 70, Qt.LeftButton)
            mouseRelease(tree, styleIndent + 50, 70, Qt.LeftButton, Qt.NoModifier, 1000)
            compare(spy.count, 1)
            verify(spy.signalArguments[0][0].valid)
            compare(spy.signalArguments[0][0].row, 0)
            compare(tree.currentIndex.row, 0)
            tree.destroy()
        }

        function test_keys_navigation()
        {
            var component = Qt.createComponent("treeview/treeview_2.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            tree.forceActiveFocus()

            // select second item with no children
            verify(!tree.currentIndex.valid)
            mouseClick(tree, semiIndent + 50, 120, Qt.LeftButton)
            var secondTopItem = tree.currentIndex
            verify(secondTopItem.valid)
            verify(!secondTopItem.parent.valid)
            compare(secondTopItem.row, 1)

            // Press right (selected item is non expandable)
            compare(tree.collapsedCount, 0)
            compare(tree.expandedCount, 0)
            keyClick(Qt.Key_Right)
            compare(tree.collapsedCount, 0)
            compare(tree.expandedCount, 0)
            compare(tree.currentIndex, secondTopItem)

            // Going down
            keyClick(Qt.Key_Down)
            var thirdTopItem = tree.currentIndex
            compare(thirdTopItem.row, 2)
            verify(!thirdTopItem.parent.valid)

            // Press right - expand - go down - go up - collapse
            keyClick(Qt.Key_Right)
            compare(tree.collapsedCount, 0)
            compare(tree.expandedCount, 1)
            compare(tree.isExpanded(thirdTopItem), true)
            keyClick(Qt.Key_Down)
            var firstChild_thirdTopItem = tree.currentIndex
            compare(firstChild_thirdTopItem.row, 0)
            verify(firstChild_thirdTopItem.parent.valid)
            compare(firstChild_thirdTopItem.parent.row, 2)
            compare(firstChild_thirdTopItem.parent.internalId, thirdTopItem.internalId)
            keyClick(Qt.Key_Up)
            verify(!tree.currentIndex.parent.valid)
            compare(tree.currentIndex.internalId, thirdTopItem.internalId)
            compare(tree.currentIndex.row, 2)
            compare(tree.isExpanded(tree.currentIndex), true)
            keyClick(Qt.Key_Left)
            compare(tree.isExpanded(tree.currentIndex), false)
            compare(tree.collapsedCount, 1)
            compare(tree.expandedCount, 1)
            tree.destroy()
        }

        function test_selection_singleSelection()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            var selectionModel = Qt.createQmlObject(testCase.instance_selectionModel, container, '')
            selectionModel.model = tree.model

            // Collect some model index
            mouseClick(tree, semiIndent + 50, 20 + 50, Qt.LeftButton)
            var firstItem = tree.currentIndex
            verify(firstItem.valid)
            compare(firstItem.row, 0)
            mouseClick(tree, semiIndent + 50, 20 + 2*50, Qt.LeftButton)
            var secondItem = tree.currentIndex
            verify(secondItem.valid)
            compare(secondItem.row, 1)
            mouseClick(tree, semiIndent + 50, 20 + 3*50, Qt.LeftButton)
            var thirdItem = tree.currentIndex
            verify(thirdItem.valid)
            compare(thirdItem.row, 2)
            mouseClick(tree, semiIndent + 50, 20 + 4*50, Qt.LeftButton)
            var fourthItem = tree.currentIndex
            verify(fourthItem.valid)
            compare(fourthItem.row, 3)
            mouseClick(tree, semiIndent + 50, 20 + 5*50, Qt.LeftButton)
            var fifthItem = tree.currentIndex
            verify(fifthItem.valid)
            compare(fifthItem.row, 4)
            mouseClick(tree, semiIndent + 50, 20 + 6*50, Qt.LeftButton)
            var sixthItem = tree.currentIndex
            verify(sixthItem.valid)
            compare(sixthItem.row, 5)

            compare(tree.selection, null)
            tree.selection = selectionModel
            compare(tree.selection, selectionModel)
            tree.selection.clear()
            compare(tree.selection.hasSelection, false)

            //// Single selectionModel
            compare(tree.selectionMode, SelectionMode.SingleSelection)
            verify(!tree.selection.currentIndex.valid)

            mouseClick(tree, semiIndent + 50, 20 + 2*50, Qt.LeftButton)
            verify(tree.selection.currentIndex.valid)

            compare(secondItem.internalId, tree.currentIndex.internalId)
            compare(secondItem.internalId, tree.selection.currentIndex.internalId)
            expectFailContinue('', 'BUG isSelected is always false when SingleSelection')
            compare(tree.selection.isSelected(secondItem), true)
            expectFailContinue('', 'BUG hasSelection is always false when SingleSelection')
            compare(tree.selection.hasSelection, true)
            var list = tree.selection.selectedIndexes()
            expectFailContinue('', 'BUG empty selectedIndex when SingleSelection')
            compare(list.length, 1)
            if (list.length === 1) {
                compare(list.at(0).internalId, secondItem.internalId)
                compare(tree.selection.isSelected(secondItem), true)
            }

            keyClick(Qt.Key_Down, Qt.ShiftModifier)
            compare(thirdItem.internalId, tree.currentIndex.internalId)
            compare(thirdItem.internalId, tree.selection.currentIndex.internalId)

            keyClick(Qt.Key_Down, Qt.ControlModifier)

            compare(fourthItem.internalId, tree.currentIndex.internalId)
            expectFailContinue('', 'BUG selected state not updated with Command/Control when SingleSelection')
            compare(fourthItem.internalId, tree.selection.currentIndex.internalId)
            expectFailContinue('', 'BUG selected state not updated with Command/Control when SingleSelection')
            compare(tree.selection.isSelected(fourthItem), true)

            tree.destroy()
        }

        function test_selection_noSelection()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            var selectionModel = Qt.createQmlObject(testCase.instance_selectionModel, container, '')
            selectionModel.model = tree.model

            // Collect some model index
            mouseClick(tree, semiIndent + 50, 20 + 50, Qt.LeftButton)
            var firstItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 2*50, Qt.LeftButton)
            var secondItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 3*50, Qt.LeftButton)
            var thirdItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 4*50, Qt.LeftButton)
            var fourthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 5*50, Qt.LeftButton)
            var fifthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 6*50, Qt.LeftButton)
            var sixthItem = tree.currentIndex

            compare(tree.selection, null)
            tree.selection = selectionModel
            compare(tree.selection, selectionModel)
            tree.selection.clear()
            compare(tree.selection.hasSelection, false)

            //// No selection
            tree.selectionMode = SelectionMode.NoSelection
            compare(tree.selectionMode, SelectionMode.NoSelection)

            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)

            compare(secondItem.internalId, tree.currentIndex.internalId)
            verify(!tree.selection.currentIndex.valid)
            compare(tree.selection.hasSelection, false)
            compare(tree.selection.isSelected(secondItem), false)

            keyClick(Qt.Key_Down, Qt.ShiftModifier)
            verify(!tree.selection.currentIndex.valid)
            compare(tree.selection.hasSelection, false)
            compare(tree.selection.isSelected(thirdItem), false)

            keyClick(Qt.Key_Down, Qt.ControlModifier)
            verify(!tree.selection.currentIndex.valid)
            compare(tree.selection.hasSelection, false)
            expectFailContinue('', 'BUG selected state not updated with Command/Controls when SingleSelection')
            compare(tree.selection.isSelected(fourthItem), true)

            tree.destroy()
        }

        function test_selection_multiSelection()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            var selectionModel = Qt.createQmlObject(testCase.instance_selectionModel, container, '')
            selectionModel.model = tree.model

            // Collect some model index
            mouseClick(tree, semiIndent + 50, 20 + 50, Qt.LeftButton)
            var firstItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 2*50, Qt.LeftButton)
            var secondItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 3*50, Qt.LeftButton)
            var thirdItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 4*50, Qt.LeftButton)
            var fourthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 5*50, Qt.LeftButton)
            var fifthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 6*50, Qt.LeftButton)
            var sixthItem = tree.currentIndex

            compare(tree.selection, null)
            tree.selection = selectionModel
            compare(tree.selection, selectionModel)
            tree.selection.clear()
            compare(tree.selection.hasSelection, false)

            ////// Multi selection
            tree.selectionMode = SelectionMode.MultiSelection
            compare(tree.selectionMode, SelectionMode.MultiSelection)

            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)

            compare(secondItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            var listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 1)
            compare(listIndexes.at(0).internalId, secondItem.internalId)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when MultiSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid)
                compare(tree.selection.currentIndex.internalId, secondItem.internalId)

            mouseClick(tree, semiIndent + 50, 70+150, Qt.LeftButton)
            compare(fourthItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(fourthItem), true)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 2)
            compare(listIndexes.at(0).internalId, secondItem.internalId)
            compare(listIndexes.at(1).internalId, fourthItem.internalId)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when MultiSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid)
                compare(tree.selection.currentIndex.internalId, fourthItem.internalId)

            keyPress(Qt.Key_Shift)
            mouseClick(tree, semiIndent + 50, 70+250, Qt.LeftButton)
            keyRelease(Qt.Key_Shift)
            compare(sixthItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(fourthItem), true)
            compare(tree.selection.isSelected(fifthItem), false)
            compare(tree.selection.isSelected(sixthItem), true)

            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 3)
            compare(listIndexes.at(0).internalId, secondItem.internalId)
            compare(listIndexes.at(1).internalId, fourthItem.internalId)
            compare(listIndexes.at(2).internalId, sixthItem.internalId)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when MultiSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid)
                compare(tree.selection.currentIndex.internalId, sixthItem.internalId)


            mouseClick(tree, semiIndent + 50, 70+150, Qt.LeftButton)
            compare(fourthItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(fourthItem), false)
            compare(tree.selection.isSelected(sixthItem), true)

            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 2)
            compare(listIndexes.at(0).internalId, secondItem.internalId)
            compare(listIndexes.at(1).internalId, sixthItem.internalId)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when MultiSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid) // TO VERIFY
                verify(!tree.selection.currentIndex.valid)

            mouseClick(tree, semiIndent + 50, 70+150, Qt.LeftButton)
            compare(fourthItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(fourthItem), true)
            compare(tree.selection.isSelected(sixthItem), true)

            keyPress(Qt.Key_Shift)
            keyClick(Qt.Key_Down)
            keyClick(Qt.Key_Down)
            keyClick(Qt.Key_Down)
            keyRelease(Qt.Key_Shift)
            compare(tree.selection.isSelected(fourthItem), true)
            compare(tree.selection.isSelected(fifthItem), true)
            compare(tree.selection.isSelected(sixthItem), false)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 4)

            tree.destroy()
        }

        function test_selection_extendedSelection()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            var selectionModel = Qt.createQmlObject(testCase.instance_selectionModel, container, '')
            selectionModel.model = tree.model

            // Collect some model index
            mouseClick(tree, semiIndent + 50, 20 + 50, Qt.LeftButton)
            var firstItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 2*50, Qt.LeftButton)
            var secondItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 3*50, Qt.LeftButton)
            var thirdItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 4*50, Qt.LeftButton)
            var fourthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 5*50, Qt.LeftButton)
            var fifthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 6*50, Qt.LeftButton)
            var sixthItem = tree.currentIndex

            compare(tree.selection, null)
            tree.selection = selectionModel
            compare(tree.selection, selectionModel)
            tree.selection.clear()
            compare(tree.selection.hasSelection, false)

            ////// Extended selection
            tree.selectionMode = SelectionMode.ExtendedSelection
            compare(tree.selectionMode, SelectionMode.ExtendedSelection)

            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)

            compare(secondItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            var listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 1)
            compare(listIndexes.at(0).internalId, secondItem.internalId)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when ExtendedSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid)
                compare(tree.selection.currentIndex.internalId, secondItem.internalId)

            // Re-click does not deselect
            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            // Ctrl/Cmd click deselect
            mouseClick(tree, semiIndent + 50, 70+52, Qt.LeftButton, Qt.ControlModifier)
            compare(tree.selection.hasSelection, false)
            compare(tree.selection.isSelected(secondItem), false)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 0)

            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)
            keyPress(Qt.Key_Down, Qt.ShiftModifier)
            keyPress(Qt.Key_Down, Qt.ShiftModifier)
            keyClick(Qt.Key_Down, Qt.ShiftModifier)

            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 4)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(thirdItem), true)
            compare(tree.selection.isSelected(fourthItem), true)
            compare(tree.selection.isSelected(fifthItem), true)

            mouseClick(tree, semiIndent + 50, 70+300, Qt.LeftButton, Qt.ShiftModifier)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 6)

            mouseClick(tree, semiIndent + 50, 70+150, Qt.LeftButton, Qt.ControlModifier)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 5)
            compare(tree.selection.isSelected(fourthItem), false)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(thirdItem), true)
            compare(tree.selection.isSelected(sixthItem), true)
            compare(tree.selection.isSelected(fifthItem), true)

            tree.destroy()
        }

        function test_selection_contiguousSelection()
        {
            var component = Qt.createComponent("treeview/treeview_1.qml")
            compare(component.status, Component.Ready)
            var tree = component.createObject(container);
            verify(tree !== null, "tree created is null")
            waitForRendering(tree)

            var selectionModel = Qt.createQmlObject(testCase.instance_selectionModel, container, '')
            selectionModel.model = tree.model

            // Collect some model index
            mouseClick(tree, semiIndent + 50, 20 + 50, Qt.LeftButton)
            var firstItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 2*50, Qt.LeftButton)
            var secondItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 3*50, Qt.LeftButton)
            var thirdItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 4*50, Qt.LeftButton)
            var fourthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 5*50, Qt.LeftButton)
            var fifthItem = tree.currentIndex
            mouseClick(tree, semiIndent + 50, 20 + 6*50, Qt.LeftButton)
            var sixthItem = tree.currentIndex

            compare(tree.selection, null)
            tree.selection = selectionModel
            compare(tree.selection, selectionModel)
            tree.selection.clear()
            compare(tree.selection.hasSelection, false)

            ////// Contiguous selection
            tree.selectionMode = SelectionMode.ContiguousSelection
            compare(tree.selectionMode, SelectionMode.ContiguousSelection)

            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)

            compare(secondItem.internalId, tree.currentIndex.internalId)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            var listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 1)
            compare(listIndexes.at(0).internalId, secondItem.internalId)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when ContiguousSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid)
                compare(tree.selection.currentIndex.internalId, secondItem.internalId)

            // Re-click does not deselect
            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            // Ctrl/Cmd click deselect
            mouseClick(tree, semiIndent + 50, 70+52, Qt.LeftButton, Qt.ControlModifier)
            compare(tree.selection.hasSelection, false)
            compare(tree.selection.isSelected(secondItem), false)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 0)

            mouseClick(tree, semiIndent + 50, 70+50, Qt.LeftButton)
            keyPress(Qt.Key_Down, Qt.ShiftModifier)
            keyPress(Qt.Key_Down, Qt.ShiftModifier)
            keyClick(Qt.Key_Down, Qt.ShiftModifier)

            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 4)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(thirdItem), true)
            compare(tree.selection.isSelected(fourthItem), true)
            compare(tree.selection.isSelected(fifthItem), true)
            expectFailContinue('', 'BUG selection.currentIndex is invalid when ContiguousSelection')
            verify(tree.selection.currentIndex.valid)
            if (tree.selection.currentIndex.valid)
                compare(tree.selection.currentIndex.internalId, fifthItem.internalId)

            mouseClick(tree, semiIndent + 50, 70+300, Qt.LeftButton, Qt.ShiftModifier)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 6)

            mouseClick(tree, semiIndent + 50, 70+150, Qt.LeftButton, Qt.ShiftModifier)

            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 3)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(secondItem), true)
            compare(tree.selection.isSelected(thirdItem), true)
            compare(tree.selection.isSelected(fourthItem), true)
            compare(tree.selection.isSelected(fifthItem), false)
            compare(tree.selection.isSelected(sixthItem), false)

            mouseClick(tree, semiIndent + 50, 70+100, Qt.LeftButton)
            listIndexes = tree.selection.selectedIndexes()
            compare(listIndexes.length, 1)
            compare(tree.selection.hasSelection, true)
            compare(tree.selection.isSelected(thirdItem), true)

            tree.destroy()
        }
    }
}
