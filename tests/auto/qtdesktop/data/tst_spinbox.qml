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

Item {
    id: container
    width: 300; height: 300

    TestCase {
        id: testcase
        name: "Tests_SpinBox"
        when: windowShown

        property int arrowMargin: 4 // the mouse areas for the up/down arrows have margins
        property point mainCoord: "0,0"
        property point upCoord: "0,0"
        property point downCoord: "0,0"

        function test_increment_key() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {maximumValue: 50}', container, '')
            spinbox.forceActiveFocus()

            compare(spinbox.maximumValue, 50)
            spinbox.setValue(spinbox.maximumValue - 3)
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.maximumValue - 2)
            keyPress(Qt.Key_Up)
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.maximumValue)
            keyPress(Qt.Key_Up)
            compare(spinbox.value, spinbox.maximumValue)
        }

        function test_decrement_key() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {minimumValue: 10}', container, '')
            spinbox.forceActiveFocus()

            compare(spinbox.minimumValue, 10)
            spinbox.setValue(spinbox.minimumValue + 3)
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.minimumValue + 2)
            keyPress(Qt.Key_Down)
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.minimumValue)
            keyPress(Qt.Key_Down)
            compare(spinbox.value, spinbox.minimumValue)
        }

        function test_increment_mouse() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {maximumValue: 50}', container, '')
            spinbox.forceActiveFocus()
            setCoordinates(spinbox)

            spinbox.setValue(spinbox.maximumValue - 3)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.maximumValue - 2)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.maximumValue)
            mouseClick(spinbox, upCoord.x, upCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.maximumValue)
        }

        function test_decrement_mouse() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {minimumValue: 10}', container, '')
            spinbox.forceActiveFocus()
            setCoordinates(spinbox)

            spinbox.setValue(spinbox.minimumValue + 3)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.minimumValue + 2)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.minimumValue)
            mouseClick(spinbox, downCoord.x, downCoord.y, Qt.LeftButton)
            compare(spinbox.value, spinbox.minimumValue)
        }

        function test_move_mouse() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {}', container, '')
            spinbox.forceActiveFocus()
            setCoordinates(spinbox)

            mouseMove(spinbox, mainCoord.x, mainCoord.y)
            compare(spinbox.containsMouse, true)
            compare(spinbox.upHovered, false)
            compare(spinbox.downHovered, false)

            mouseMove(spinbox.parent, upCoord.x, upCoord.y)
            compare(spinbox.upHovered, true)
            compare(spinbox.downHovered, false)

            mouseMove(spinbox, downCoord.x, downCoord.y)
            compare(spinbox.upHovered, false)
            compare(spinbox.downHovered, true)

            mouseMove(spinbox, mainCoord.x - 2, mainCoord.y - 2)
            compare(spinbox.containsMouse, false)
            compare(spinbox.upHovered, false)
            compare(spinbox.downHovered, false)
        }

        function test_maxvalue() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {}', container, '')
            spinbox.setValue(spinbox.maximumValue + 1)
            compare(spinbox.value, spinbox.maximumValue)
        }

        function test_minvalue() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {}', container, '')
            spinbox.setValue(spinbox.minimumValue - 1)
            compare(spinbox.value, spinbox.minimumValue)
        }

        function test_invalidvalue() {
            var spinbox = Qt.createQmlObject('import QtDesktop 1.0; SpinBox {}', container, '')
            spinbox.setValue("hello")
            compare(spinbox.value.toString().toLowerCase(), "nan")
        }

        function setCoordinates(item)
        {
            mainCoord.x = item.x + 1
            mainCoord.y = item.y + 1
            upCoord.x = item.x + item.width - arrowMargin
            upCoord.y = item.y + arrowMargin
            downCoord.x = upCoord.x
            downCoord.y = item.y + item.height - arrowMargin
        }
    }
}

