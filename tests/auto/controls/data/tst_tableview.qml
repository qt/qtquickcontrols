/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
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
import QtTest 1.0
import QtQuick.Controls 1.0
import QtQuickControlsTests 1.0

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

    function test_usingqmlmodel(data) {

        var component = Qt.createComponent(data.a)
        compare(component.status, Component.Ready)
        var table =  component.createObject(testCase);
        verify(table !== null, "table created is null")
        table.forceActiveFocus();

        verify(table.currentItem !== undefined, "No current item found")
        var label = findAChild(table.currentItem, "label")
        verify(label !== undefined)
        compare(label.text, data.expected.toString());
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

        verify(table.currentItem !== undefined, "No current item found")
        var label = findAChild(table.currentItem, "label")
        verify(label !== undefined)
        compare(label.text, valuefrommodel.toString());
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
        var valuefrommodel = table.model.dataAt(table.currentIndex)
        verify(valuefrommodel !== undefined, "The model has no defined value")

        verify(table.currentItem !== undefined, "No current item found")
        var label = findAChild(table.currentItem, "label")
        verify(label !== undefined)
        compare(label.text, valuefrommodel.toString())
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

        verify(table.currentItem !== undefined, "No current item found")
        var label = findAChild(table.currentItem, "label")
        verify(label !== undefined)
        compare(label.text, data.expected.toString());
    }

    // In TableView, drawn text = table.currentItem.children[1].children[1].itemAt(0).children[0].children[0].text

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
