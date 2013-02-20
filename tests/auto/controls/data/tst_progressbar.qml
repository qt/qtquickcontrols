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

TestCase {
    id: testCase
    name: "Tests_ProgressBar"
    when:windowShown
    width:400
    height:400

    function test_minimumvalue() {
        var progressBar = Qt.createQmlObject('import QtQuick.Controls 1.0; ProgressBar {}', testCase, '');

        progressBar.minimumValue = 5
        progressBar.maximumValue = 10
        progressBar.value = 2
        compare(progressBar.minimumValue, 5)
        compare(progressBar.value, 5)

        progressBar.minimumValue = 7
        compare(progressBar.value, 7)
    }

    function test_maximumvalue() {
        var progressBar = Qt.createQmlObject('import QtQuick.Controls 1.0; ProgressBar {}', testCase, '');

        progressBar.minimumValue = 5
        progressBar.maximumValue = 10
        progressBar.value = 15
        compare(progressBar.maximumValue, 10)
        compare(progressBar.value, 10)

        progressBar.maximumValue = 8
        compare(progressBar.value, 8)
    }

    function test_invalidMinMax() {
        var progressBar = Qt.createQmlObject('import QtQuick.Controls 1.0; ProgressBar {}', testCase, '');

        // minimumValue has priority over maximum if they are inconsistent

        progressBar.minimumValue = 10
        progressBar.maximumValue = 10
        compare(progressBar.value, progressBar.minimumValue)

        progressBar.value = 17
        compare(progressBar.value, progressBar.minimumValue)

        progressBar.maximumValue = 5
        compare(progressBar.value, progressBar.minimumValue)

        progressBar.value = 12
        compare(progressBar.value, progressBar.minimumValue)

        var progressBar2 = Qt.createQmlObject('import QtQuick.Controls 1.0; ProgressBar {minimumValue: 10; maximumValue: 4; value: 5}', testCase, '');
        compare(progressBar.value, progressBar.minimumValue)
    }
}
