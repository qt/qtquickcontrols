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

TestCase {
    id: testCase
    name: "Tests_TabView"
    when:windowShown
    width:400
    height:400

    function test_createTabView() {
        var tabView = Qt.createQmlObject('import QtQuick.Controls 1.0; TabView {}', testCase, '');
        tabView.destroy()
    }

    function test_repeater() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { Repeater { model: 3; Tab { } } }', testCase, '');
        compare(tabView.count, 3)
        tabView.destroy()
    }

    Component {
        id: newTab
        Item {}
    }

    function test_changeIndex() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { Repeater { model: 3; Tab { Text { text: index } } } }', testCase, '');
        compare(tabView.count, 3)
        verify(tabView.tabAt(1).item == undefined)
        tabView.currentIndex = 1
        verify(tabView.tabAt(1).item !== undefined)
        verify(tabView.tabAt(2).item == undefined)
        tabView.currentIndex = 1
        verify(tabView.tabAt(2).item !== undefined)
        tabView.destroy()
    }


    function test_addRemoveTab() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { }', testCase, '');
        compare(tabView.count, 0)
        tabView.addTab("title 1", newTab)
        compare(tabView.count, 1)
        tabView.addTab("title 2", newTab)
        compare(tabView.count, 2)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 2")

        tabView.insertTab(1, "title 3")
        compare(tabView.count, 3)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 3")
        compare(tabView.tabAt(2).title, "title 2")

        tabView.insertTab(0, "title 4")
        compare(tabView.count, 4)
        compare(tabView.tabAt(0).title, "title 4")
        compare(tabView.tabAt(1).title, "title 1")
        compare(tabView.tabAt(2).title, "title 3")
        compare(tabView.tabAt(3).title, "title 2")

        tabView.removeTab(0)
        compare(tabView.count, 3)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 3")
        compare(tabView.tabAt(2).title, "title 2")

        tabView.removeTab(1)
        compare(tabView.count, 2)
        compare(tabView.tabAt(0).title, "title 1")
        compare(tabView.tabAt(1).title, "title 2")

        tabView.removeTab(1)
        compare(tabView.count, 1)
        compare(tabView.tabAt(0).title, "title 1")

        tabView.removeTab(0)
        compare(tabView.count, 0)
        tabView.destroy()
    }

    function test_dynamicTabs() {
        var tabView = Qt.createQmlObject('import QtQuick 2.1; import QtQuick.Controls 1.0; TabView { property Component tabComponent: Component { Tab { } } }', testCase, '');
        compare(tabView.count, 0)
        var tab1 = tabView.tabComponent.createObject(tabView)
        compare(tabView.count, 1)
        var tab2 = tabView.tabComponent.createObject(tabView)
        compare(tabView.count, 2)
        tab1.destroy()
        wait(0)
        compare(tabView.count, 1)
        tab2.destroy()
        wait(0)
        compare(tabView.count, 0)
    }
}

