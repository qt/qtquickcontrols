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

import QtTest 1.0
import QtQuick 2.1

TestCase {
    id: testCase
    name: "Tests_Common"
    visible: windowShown
    when: windowShown
    width: 400
    height: 400

    property var control

    function init_data() {
         return [
             { tag: "CircularGauge" },
             { tag: "DelayButton" },
             { tag: "Dial" },
             { tag: "Gauge" },
             { tag: "PieMenu", qml: "import QtQuick.Controls 1.1; import QtQuick.Extras 1.4;"
                + "PieMenu { visible: true; MenuItem { text: 'foo' } }"},
             { tag: "StatusIndicator" },
             { tag: "ToggleButton" },
             { tag: "Tumbler", qml: "import QtQuick.Extras 1.4; Tumbler { TumblerColumn { model: 10 } }" }
         ];
    }

    function cleanup() {
        control.destroy();
    }

    function test_resize(data) {
        var qml = data.qml ? data.qml : "import QtQuick.Extras 1.4; " + data.tag + " { }";
        control = Qt.createQmlObject(qml, testCase, "");

        var resizeAnimation = Qt.createQmlObject("import QtQuick 2.2; NumberAnimation {}", testCase, "");
        resizeAnimation.target = control;
        resizeAnimation.properties = "width,height";
        resizeAnimation.duration = 100;
        resizeAnimation.to = 0;
        resizeAnimation.start();
        // Shouldn't get any warnings.
        tryCompare(resizeAnimation, "running", false);
        resizeAnimation.destroy();
    }
}
