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
import QtTest 1.0
import QtQuick.Controls 1.0
import QtQuickControlsTests 1.0

Item {
    id: container
    width: 400
    height: 400

TestCase {
    id: testCase
    name: "Tests_TableView"
    when:windowShown
    width:400
    height:400

    Component {
        id: newColumn
        TableViewColumn { }
    }

    function test_usingqmlmodel_data() {
        return [
                    {tag: "listmodel", a: "tableview/table5_listmodel.qml", expected: "A"},
                    {tag: "countmodel", a: "tableview/table6_countmodel.qml", expected: 0},
                    {tag: "arraymodel", a: "tableview/table7_arraymodel.qml", expected: "A"},
                    {tag: "itemmodel", a: "tableview/table8_itemmodel.qml", expected: 10},
                ]
    }

    function test_basic_setup() {
        var test_instanceStr =
           'import QtQuick 2.1;             \
            import QtQuick.Controls 1.0;    \
            TableView {                     \
                TableViewColumn {           \
                }                           \
                model: 10                   \
            }'

        var table = Qt.createQmlObject(test_instanceStr, testCase, '')
        compare(table.currentRow, -1)
        verify(table.rowCount === 10)
        verify (table.__currentRowItem === null)
        table.currentRow = 0
        verify(table.__currentRowItem !== null)
        verify (table.currentRow === 0)
        table.currentRow = 3
        verify(table.__currentRowItem !== null)
        verify (table.currentRow === 3)
        table.destroy()
    }

    function test_usingqmlmodel(data) {

        var component = Qt.createComponent(data.a)
        compare(component.status, Component.Ready)
        var table =  component.createObject(testCase);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();

        verify(table.__currentRowItem !== undefined, "No current item found")
        var label = findAChild(table.__currentRowItem, "label")
        verify(label !== undefined)
        compare(label.text, data.expected.toString());
        table.destroy();
    }

    function test_usingcppqobjectmodel() {

        var component = Qt.createComponent("tableview/table1_qobjectmodel.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(testCase);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();

        // read data from the model directly
        var valuefrommodel = table.model.value;
        verify(valuefrommodel !== undefined, "The model has no defined value")

        verify(table.__currentRowItem !== undefined, "No current item found")
        var label = findAChild(table.__currentRowItem, "label")
        verify(label !== undefined)
        compare(label.text, valuefrommodel.toString());
        table.destroy();
    }

    function test_usingcppqabstractitemmodel() {

        var component = Qt.createComponent("tableview/table2_qabstractitemmodel.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(testCase);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();

        // to go to next row (this model has 10 rows)
        table.__incrementCurrentIndex()

        // read data from the model directly
        var valuefrommodel = table.model.dataAt(table.currentRow)
        verify(valuefrommodel !== undefined, "The model has no defined value")

        verify(table.__currentRowItem !== undefined, "No current item found")
        var label = findAChild(table.__currentRowItem, "label")
        verify(label !== undefined)
        compare(label.text, valuefrommodel.toString())
        table.destroy();
    }

    function test_usingcpplistmodel_data() {
        return [
                    {tag: "qobjectlistmodel", a: "tableview/table3_qobjectlist.qml", expected: 1},
                    {tag: "qstringlistmodel", a: "tableview/table4_qstringlist.qml", expected: "B"},
                ]
    }

    function test_usingcpplistmodel(data) {

        var component = Qt.createComponent(data.a)
        compare(component.status, Component.Ready)
        var table =  component.createObject(testCase);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();

        // to go to next row (this model has 3 rows, read the second row)
        table.__incrementCurrentIndex()

        verify(table.__currentRowItem !== undefined, "No current item found")
        var label = findAChild(table.__currentRowItem, "label")
        verify(label !== undefined)
        compare(label.text, data.expected.toString());
        table.destroy();
    }

    function test_buttonDelegate() {
        var component = Qt.createComponent("tableview/table_buttondelegate.qml")
        compare(component.status, Component.Ready)
        var table = component.createObject(container)
        verify(table !== null, "table created is null")
        compare(table.currentRow, -1)
        waitForRendering(table)

        // wait for items to be created
        var timeout = 2000
        while (timeout >= 0 && table.rowAt(20, 50) === -1) {
            timeout -= 50
            wait(50)
        }

        mousePress(table, 50, 20, Qt.LeftButton)
        compare(table.currentRow, 0)
        compare(table.tableClickCount, 0)
        compare(table.buttonPressCount, 1)
        compare(table.buttonReleaseCount, 0)

        mouseRelease(table, 50, 20, Qt.LeftButton)
        compare(table.currentRow, 0)
        compare(table.tableClickCount, 0)
        compare(table.buttonPressCount, 1)
        compare(table.buttonReleaseCount, 1)

        mouseClick(table, 50, 60, Qt.LeftButton)
        compare(table.currentRow, 1)
        compare(table.tableClickCount, 0)
        compare(table.buttonPressCount, 2)
        compare(table.buttonReleaseCount, 2)

        table.destroy()
    }

    function test_QTBUG_31206() {
        var component = Qt.createComponent("tableview/table_delegate2.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(container);
        verify(table !== null, "table created is null")

        // wait for items to be created
        var timeout = 2000
        while (timeout >= 0 && table.rowAt(15, 55) === -1) {
            timeout -= 50
            wait(50)
        }

        compare(table.test, false)
        mouseClick(table, 15 , 10, Qt.LeftButton)
        compare(table.test, true)
        table.destroy()
    }

    function test_forwardMouseEventsToChildDelegate() {
        var component = Qt.createComponent("tableview/table_delegate3.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(container);
        table.forceActiveFocus();
        verify(table !== null, "table created is null")

        // wait for items to be created
        var timeout = 2000
        while (timeout >= 0 && table.rowAt(15, 55) === -1) {
            timeout -= 50
            wait(50)
        }

        compare(table._pressed, false)
        compare(table._clicked, false)
        compare(table._released, false)
        compare(table._doubleClicked, false)

        mousePress(table, 25 , 10, Qt.LeftButton)
        compare(table._pressed, true)
        table.clearTestData()

        mouseRelease(table, 25 , 10, Qt.LeftButton)
        compare(table._released, true)
        table.clearTestData()

        mouseClick(table, 25 , 10, Qt.LeftButton)
        compare(table._clicked, true)
        table.clearTestData()

        mouseDoubleClick(table, 25 , 10, Qt.LeftButton)
        compare(table._doubleClicked, true)
        table.clearTestData()

        table.destroy()
    }

    function test_rightClickOnMouseAreaOverTableView() {
        var component = Qt.createComponent("tableview/table_mousearea.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(container);
        table.forceActiveFocus();
        verify(table !== null, "table created is null")

        // wait for items to be created
        var timeout = 2000
        while (timeout >= 0 && table.rowAt(15, 55) === -1) {
            timeout -= 50
            wait(50)
        }

        compare(table._pressed, false)
        compare(table._clicked, false)
        compare(table._released, false)
        compare(table._doubleClicked, false)

        mousePress(table, 25, 10, Qt.RightButton)
        compare(table._pressed, true)
        table.clearTestData()

        mouseRelease(table, 25, 10, Qt.RightButton)
        compare(table._released, true)
        table.clearTestData()

        mouseClick(table, 25, 10, Qt.RightButton)
        compare(table._clicked, true)
        table.clearTestData()

        mouseDoubleClick(table, 25, 10, Qt.RightButton)
        compare(table._doubleClicked, true)
        table.clearTestData()

        table.destroy()
    }

    function test_activated() {
        var component = Qt.createComponent("tableview/table_activated.qml")
        compare(component.status, Component.Ready)
        var table = component.createObject(container);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();
        compare(table.test, -1)
        compare(table.testClick, table.currentRow)

        if (!table.__activateItemOnSingleClick)
            mouseDoubleClick(table, 15 , 45, Qt.LeftButton)
        else
            mouseClick(table, 15, 45, Qt.LeftButton)

        compare(table.testDoubleClick, table.currentRow)
        compare(table.test, table.currentRow)
        compare(table.testClick, table.currentRow)

        if (!table.__activateItemOnSingleClick)
            mouseDoubleClick(table, 15 , 15, Qt.LeftButton)
        else
            mouseClick(table, 15, 15, Qt.LeftButton)

        compare(table.testDoubleClick, table.currentRow)
        compare(table.testClick, table.currentRow)
        compare(table.test, table.currentRow)

        table.destroy()
    }

    function test_columnCount() {
        var component = Qt.createComponent("tableview/table_multicolumns.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(container);
        verify(table !== null, "table created is null")
        compare(table.columnCount, 3)
        table.destroy()
    }

    function test_rowCount() {
        var component = Qt.createComponent("tableview/table_multicolumns.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(container);
        verify(table !== null, "table created is null")
        compare(table.rowCount, 3)
        table.destroy()
    }

    function test_columnWidth() {
        var tableView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TableView { }', testCase, '');
        compare(tableView.columnCount, 0)
        var column = newColumn.createObject(testCase, {title: "title 1"});
        verify(column.__view === null)
        compare(column.width, 160)
        compare(column.title, "title 1")
        tableView.addColumn(column)
        compare(column.__view, tableView)
        compare(column.width, tableView.viewport.width)
        var tableView2 = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TableView { }', testCase, '');
        ignoreWarning("TableView::insertColumn(): you cannot add a column to multiple views")
        tableView2.addColumn(column) // should not work
        compare(column.__view, tableView) //same as before
        tableView2.destroy()
        tableView.destroy()
    }

    function test_dynamicColumns() {
        var component = Qt.createComponent("tableview/table_dynamiccolumns.qml")
        compare(component.status, Component.Ready)
        var table = component.createObject(container)

        // insertColumn(component), insertColumn(item),
        // addColumn(component), addColumn(item), and static TableViewColumn {}
        compare(table.columnCount, 5)
        compare(table.getColumn(0).title, "inserted component")
        compare(table.getColumn(1).title, "inserted item")
        table.destroy()
    }

    function test_addRemoveColumn() {
        var tableView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TableView { }', testCase, '');
        compare(tableView.columnCount, 0)
        tableView.addColumn(newColumn.createObject(testCase, {title: "title 1"}))
        compare(tableView.columnCount, 1)
        tableView.addColumn(newColumn.createObject(testCase, {title: "title 2"}))
        compare(tableView.columnCount, 2)
        compare(tableView.getColumn(0).title, "title 1")
        compare(tableView.getColumn(1).title, "title 2")

        tableView.insertColumn(1, newColumn.createObject(testCase, {title: "title 3"}))
        compare(tableView.columnCount, 3)
        compare(tableView.getColumn(0).title, "title 1")
        compare(tableView.getColumn(1).title, "title 3")
        compare(tableView.getColumn(2).title, "title 2")

        tableView.insertColumn(0, newColumn.createObject(testCase, {title: "title 4"}))
        compare(tableView.columnCount, 4)
        compare(tableView.getColumn(0).title, "title 4")
        compare(tableView.getColumn(1).title, "title 1")
        compare(tableView.getColumn(2).title, "title 3")
        compare(tableView.getColumn(3).title, "title 2")

        tableView.removeColumn(0)
        compare(tableView.columnCount, 3)
        compare(tableView.getColumn(0).title, "title 1")
        compare(tableView.getColumn(1).title, "title 3")
        compare(tableView.getColumn(2).title, "title 2")

        tableView.removeColumn(1)
        compare(tableView.columnCount, 2)
        compare(tableView.getColumn(0).title, "title 1")
        compare(tableView.getColumn(1).title, "title 2")

        tableView.removeColumn(1)
        compare(tableView.columnCount, 1)
        compare(tableView.getColumn(0).title, "title 1")

        tableView.removeColumn(0)
        compare(tableView.columnCount, 0)
        tableView.destroy()
    }

    function test_moveColumn_data() {
        return [
            {tag:"0->1 (0)", from: 0, to: 1},
            {tag:"0->1 (1)", from: 0, to: 1},
            {tag:"0->1 (2)", from: 0, to: 1},

            {tag:"0->2 (0)", from: 0, to: 2},
            {tag:"0->2 (1)", from: 0, to: 2},
            {tag:"0->2 (2)", from: 0, to: 2},

            {tag:"1->0 (0)", from: 1, to: 0},
            {tag:"1->0 (1)", from: 1, to: 0},
            {tag:"1->0 (2)", from: 1, to: 0},

            {tag:"1->2 (0)", from: 1, to: 2},
            {tag:"1->2 (1)", from: 1, to: 2},
            {tag:"1->2 (2)", from: 1, to: 2},

            {tag:"2->0 (0)", from: 2, to: 0},
            {tag:"2->0 (1)", from: 2, to: 0},
            {tag:"2->0 (2)", from: 2, to: 0},

            {tag:"2->1 (0)", from: 2, to: 1},
            {tag:"2->1 (1)", from: 2, to: 1},
            {tag:"2->1 (2)", from: 2, to: 1},

            {tag:"0->0", from: 0, to: 0},
                    {tag:"-1->0", from: -1, to: 0, warning: "TableView::moveColumn(): invalid argument"},
            {tag:"0->-1", from: 0, to: -1, warning: "TableView::moveColumn(): invalid argument"},
            {tag:"1->10", from: 1, to: 10, warning: "TableView::moveColumn(): invalid argument"},
            {tag:"10->2", from: 10, to: 2, warning: "TableView::moveColumn(): invalid argument"},
            {tag:"10->-1", from: 10, to: -1, warning: "TableView::moveColumn(): invalid argument"}
        ]
    }

    function test_moveColumn(data) {
        var tableView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TableView { }', testCase, '');
        compare(tableView.columnCount, 0)

        var titles = ["title 1", "title 2", "title 3"]

        var i = 0;
        for (i = 0; i < titles.length; ++i)
            tableView.addColumn(newColumn.createObject(testCase, {title: titles[i]}))

        compare(tableView.columnCount, titles.length)
        for (i = 0; i < tableView.columnCount; ++i)
            compare(tableView.getColumn(i).title, titles[i])

        if (data.warning !== undefined)
            ignoreWarning(data.warning)
        tableView.moveColumn(data.from, data.to)

        compare(tableView.columnCount, titles.length)

        if (data.from >= 0 && data.from < tableView.columnCount && data.to >= 0 && data.to < tableView.columnCount) {
            var title = titles[data.from]
            titles.splice(data.from, 1)
            titles.splice(data.to, 0, title)
        }

        compare(tableView.columnCount, titles.length)
        for (i = 0; i < tableView.columnCount; ++i)
            compare(tableView.getColumn(i).title, titles[i])

        tableView.destroy()
    }

    function test_positionViewAtRow() {
        var test_instanceStr =
           'import QtQuick 2.1;             \
            import QtQuick.Controls 1.0;    \
            TableView {                     \
                TableViewColumn {           \
                }                           \
                model: 1000;                \
                headerVisible: false;       \
            }'

        var table = Qt.createQmlObject(test_instanceStr, testCase, '')
        waitForRendering(table)

        var beginPos = table.mapFromItem(table.viewport, 0, 0)

        table.positionViewAtRow(0, ListView.Beginning)
        compare(table.rowAt(beginPos.x, beginPos.y), 0)

        table.positionViewAtRow(100, ListView.Beginning)
        compare(table.rowAt(beginPos.x, beginPos.y), 100)

        var endPos = table.mapFromItem(table.viewport, 0, table.viewport.height - 1)

        table.positionViewAtRow(900, ListView.End)
        compare(table.rowAt(endPos.x, endPos.y), 900)

        table.positionViewAtRow(999, ListView.End)
        compare(table.rowAt(endPos.x, endPos.y), 999)

        table.destroy()
    }

    // In TableView, drawn text = table.__currentRowItem.children[1].children[1].itemAt(0).children[0].children[0].text

    function findAChild(item, name)
    {
        if (item.count === undefined) {
            var i = 0
            while (item.children[i] !== undefined) {
                var child = item.children[i]
                if (child.objectName === name)
                    return child
                else {
                    var found = findAChild(child, name)
                    if (found !== undefined)
                        return found
                }
                i++
            }

        } else { // item with count => columns
            for (var j = 0; j < item.count ; j++) {
                var tempitem = item.itemAt(j)
                if (tempitem.objectName === name)
                    return tempitem
                var found = findAChild(tempitem, name)
                if (found !== undefined)
                    return found
            }
        }
        return undefined // no matching child found
    }
}
}
