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
import "TestUtils.js" as TestUtils

TestCase {
    id: testcase
    name: "Tests_CircularGauge"
    when: windowShown
    width: 400
    height: 400

    function test_instance() {
        var gauge = Qt.createQmlObject('import QtQuick.Extras 1.3; CircularGauge { }', testcase, '');
        verify (gauge, "CircularGauge: failed to create an instance")
        verify(gauge.__style)
        gauge.destroy()
    }

    property Component tickmark: Rectangle {
        objectName: "tickmark" + styleData.index
        implicitWidth: 2
        implicitHeight: 6
        color: "#c8c8c8"
    }

    property Component minorTickmark: Rectangle {
        objectName: "minorTickmark" + styleData.index
        implicitWidth: 1
        implicitHeight: 3
        color: "#c8c8c8"
    }

    property Component tickmarkLabel: Text {
        objectName: "tickmarkLabel" + styleData.index
        text: styleData.value
        color: "#c8c8c8"
    }

    function test_tickmarksVisible() {
        var gauge = Qt.createQmlObject("import QtQuick.Extras 1.3; CircularGauge { }", testcase, "");
        verify(gauge, "CircularGauge: failed to create an instance");

        gauge.__style.tickmark = tickmark;
        gauge.__style.minorTickmark = minorTickmark;
        gauge.__style.tickmarkLabel = tickmarkLabel;
        verify(TestUtils.findChild(gauge, "tickmark0"));
        verify(TestUtils.findChild(gauge, "minorTickmark0"));
        verify(TestUtils.findChild(gauge, "tickmarkLabel0"));

        gauge.tickmarksVisible = false;
        verify(!TestUtils.findChild(gauge, "tickmark0"));
        verify(!TestUtils.findChild(gauge, "minorTickmark0"));
        verify(!TestUtils.findChild(gauge, "tickmarkLabel0"));

        gauge.destroy();
    }
}
