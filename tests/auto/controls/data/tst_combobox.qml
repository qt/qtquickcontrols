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
    name: "Tests_ComboBox"
    when:windowShown
    width:400
    height:400

    property var model
    function init() {
        model = Qt.createQmlObject("import QtQuick 2.1; ListModel {}", testCase, '')
        model.append({ text: "Banana", color: "Yellow" })
        model.append({ text: "Apple", color: "Green" })
        model.append({ text: "Coconut", color: "Brown" })
    }

    function test_keyupdown() {
        var comboBox = Qt.createQmlObject('import QtQuick.Controls 1.0 ; ComboBox { model: 4 }', testCase, '');

        compare(comboBox.currentIndex, 0)

        comboBox.forceActiveFocus()

        keyPress(Qt.Key_Down)
        compare(comboBox.currentIndex, 1)
        keyPress(Qt.Key_Down)
        compare(comboBox.currentIndex, 2)
        keyPress(Qt.Key_Up)
        compare(comboBox.currentIndex, 1)
    }

    function test_textrole() {
        var comboBox = Qt.createQmlObject('import QtQuick.Controls 1.0 ; ComboBox {}', testCase, '');
        comboBox.textRole = "text"
        comboBox.model = model
        compare(comboBox.currentIndex, 0)
        compare(comboBox.currentText, "Banana")
        comboBox.textRole = "color"
        compare(comboBox.currentText, "Yellow")
    }

    function test_arraymodel() {
        var arrayModel = [
            'Banana',
            'Apple',
            'Coconut'
        ];

        var comboBox = Qt.createQmlObject('import QtQuick.Controls 1.0 ; ComboBox {}', testCase, '');
        comboBox.model = arrayModel
        compare(comboBox.currentIndex, 0)
        compare(comboBox.currentText, "Banana")
    }

    function test_arraymodelwithtextrole() {
        var arrayModel = [
            {text: 'Banana', color: 'Yellow'},
            {text: 'Apple', color: 'Green'},
            {text: 'Coconut', color: 'Brown'}
        ];

        var comboBox = Qt.createQmlObject('import QtQuick.Controls 1.0 ; ComboBox {}', testCase, '');
        comboBox.textRole = "text"
        comboBox.model = arrayModel
        compare(comboBox.currentIndex, 0)
        compare(comboBox.currentText, "Banana")
        comboBox.textRole = "color"
        compare(comboBox.currentText, "Yellow")
    }
}
