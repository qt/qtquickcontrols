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

Item {
    id: container
    width: 500
    height: 500

    TestCase {
        id: testCase
        name: "Tests_Slider"
        when:windowShown
        width:400
        height:400

        function test_vertical() {
            var slider = Qt.createQmlObject('import QtQuick.Controls 1.0; Slider {}', testCase, '');
            verify(slider.height < slider.width)

            slider.orientation = Qt.Vertical;
            verify(slider.height > slider.width)
        }

        function test_minimumvalue() {
            var slider = Qt.createQmlObject('import QtQuick.Controls 1.0; Slider {}', testCase, '');

            slider.minimumValue = 5
            slider.maximumValue = 10
            slider.value = 2
            compare(slider.minimumValue, 5)
            compare(slider.value, 5)
        }

        function test_maximumvalue() {
            var slider = Qt.createQmlObject('import QtQuick.Controls 1.0; Slider {}', testCase, '');

            slider.minimumValue = 5
            slider.maximumValue = 10
            slider.value = 15
            compare(slider.maximumValue, 10)
            compare(slider.value, 10)
        }

        function test_rightLeftKeyPressed() {
            var slider = Qt.createQmlObject('import QtQuick.Controls 1.0; Slider {}', container, '');
            slider.forceActiveFocus()
            slider.maximumValue = 20
            slider.minimumValue = 0
            slider.value = 1
            slider.stepSize = 1
            var keyStep = 2 // (maximumValue - minimumValue)/10.0
            keyPress(Qt.Key_Right)
            keyPress(Qt.Key_Right)
            compare(slider.value, 1 + keyStep * 2)
            keyPress(Qt.Key_Left)
            compare(slider.value, 1 + keyStep)
        }

        function test_mouseWheel() {
            var slider = Qt.createQmlObject('import QtQuick.Controls 1.0; Slider {}', container, '');
            slider.forceActiveFocus()
            slider.value = 0
            slider.maximumValue = 300
            slider.minimumValue = 0
            slider.stepSize = 2
            slider.width = 300

            var defaultScrollSpeed = 20.0
            var mouseStep = 15.0
            var deltatUnit = 8.0

            var mouseRatio = deltatUnit * mouseStep / defaultScrollSpeed;
            var sliderDeltaRatio = 1; //(slider.maximumValue - slider.minimumValue)/slider.width
            var ratio = mouseRatio / sliderDeltaRatio

            mouseWheel(slider, 5, 5, 20 * ratio, 0)
            compare(slider.value, 20)

            slider.maximumValue = 30
            slider.minimumValue = 0
            slider.stepSize = 1
            slider.value = 10
            sliderDeltaRatio = 0.1 //(slider.maximumValue - slider.minimumValue)/slider.width
            ratio = mouseRatio / sliderDeltaRatio

            compare(slider.value, 10)

            var previousValue = slider.value
            mouseWheel(slider, 5, 5, 6 * ratio, 0)
            compare(slider.value, Math.round(previousValue + 6))

            mouseWheel(slider, 5, 5, -6 * ratio, 0)
            compare(slider.value, previousValue)

            // Reach maximum
            slider.value = 0
            mouseWheel(slider, 5, 5, 40 * ratio, 0)
            compare(slider.value, slider.maximumValue)

        }
    }
}
