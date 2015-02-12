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
import QtQuick.Extras 1.3
import QtQuick.Extras.Private 1.0

TestCase {
    id: testCase
    name: "Tests_StatusIndicator"
    visible: windowShown
    when: windowShown
    width: 400
    height: 400

    property var indicator

    function cleanup() {
        if (indicator)
            indicator.destroy();
    }

    function test_instance() {
        indicator = Qt.createQmlObject("import QtQuick.Extras 1.3; StatusIndicator { }", testCase, "");
        verify(indicator, "StatusIndicator: failed to create an instance")
        verify(indicator.__style);
    }

    function test_active_data() {
        if (StyleSettings.styleName === "Flat") {
            return [
                { tag: "active", active: true, expectedColor: { r: 18, g: 136, b: 203 } },
                { tag: "inactive", active: false, expectedColor: { r: 179, g: 179, b: 179 } }
            ];
        }

        return [
            { tag: "active", active: true, expectedColor: { r: 255, g: 99, b: 99 } },
            { tag: "inactive", active: false, expectedColor: { r: 52, g: 52, b: 52 } }
        ];
    }

    function test_active(data) {
        indicator = Qt.createQmlObject("import QtQuick.Extras 1.3; StatusIndicator { }", testCase, "");
        verify(indicator);
        compare(indicator.active, false);

        indicator.active = data.active;
        // Color is slightly different on some platforms/machines, like Windows.
        var lenience = StyleSettings.styleName === "Flat" ? 0 : 2;

        waitForRendering(indicator);
        var image = grabImage(indicator);
        fuzzyCompare(image.red(indicator.width / 2, indicator.height / 2), data.expectedColor.r, lenience);
        fuzzyCompare(image.green(indicator.width / 2, indicator.height / 2), data.expectedColor.g, lenience);
        fuzzyCompare(image.blue(indicator.width / 2, indicator.height / 2), data.expectedColor.b, lenience);
    }

    function test_color() {
        var flatStyle = StyleSettings.styleName === "Flat";

        indicator = Qt.createQmlObject("import QtQuick.Extras 1.3; StatusIndicator { }", testCase, "");
        verify(indicator);
        compare(indicator.color, flatStyle ? "#1288cb" : "#ff0000");

        // The base style uses a gradient for its color, so pure blue will not be pure blue.
        var expectedR = flatStyle ? 0 : 99;
        var expectedG = flatStyle ? 0 : 99;
        var expectedB = flatStyle ? 255 : 255;
        var lenience = flatStyle ? 0 : 2;

        indicator.active = true;
        indicator.color = "#0000ff";
        waitForRendering(indicator);
        var image = grabImage(indicator);
        fuzzyCompare(image.red(indicator.width / 2, indicator.height / 2), expectedR, lenience);
        fuzzyCompare(image.green(indicator.width / 2, indicator.height / 2), expectedG, lenience);
        fuzzyCompare(image.blue(indicator.width / 2, indicator.height / 2), expectedB, lenience);
    }

    function test_baseStyleHasOuterShadow() {
        if (StyleSettings.styleName !== "Base")
            return;

        indicator = Qt.createQmlObject("import QtQuick.Extras 1.3; StatusIndicator { }", testCase, "");
        verify(indicator);

        // There should be a "shadow" here...
        waitForRendering(indicator);
        var image = grabImage(indicator);
        verify(image.pixel(indicator.width / 2, 1) !== Qt.rgba(1, 1, 1, 1));
    }
}
