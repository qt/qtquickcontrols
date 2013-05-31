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

    function test_forwardClickToChild() {
        var component = Qt.createComponent("tableview/table_delegate.qml")
        compare(component.status, Component.Ready)
        var table =  component.createObject(container);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();
        compare(table.test, 0)
        mouseClick(table, 15 , 55, Qt.LeftButton)
        compare(table.test, 1)
        table.destroy()
    }

    function test_activated() {
        var component = Qt.createComponent("tableview/table_activated.qml")
        compare(component.status, Component.Ready)
        var table = component.createObject(container);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();
        compare(table.test, false)
        if (!table.__activateItemOnSingleClick)
            mouseDoubleClick(table, 15 , 15, Qt.LeftButton)
        else
            mouseClick(table, 15, 15, Qt.LeftButton)
        compare(table.test, true)
        table.destroy()
    }

    function test_activated_withItemDelegate() {
        var component = Qt.createComponent("tableview/table_delegate.qml")
        compare(component.status, Component.Ready)
        var table = component.createObject(container);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();
        compare(table.activatedTest, false)
        if (!table.__activateItemOnSingleClick)
            mouseDoubleClick(table, 15 , 50, Qt.LeftButton)
        else
            mouseClick(table, 15, 50, Qt.LeftButton)
        compare(table.activatedTest, true)
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
