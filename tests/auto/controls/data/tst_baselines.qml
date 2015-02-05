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

import QtQuick 2.2
import QtTest 1.0
import QtQuick.Layouts 1.1

Item {
    id: container
    width: 200
    height: 200
    TestCase {
        id: testCase
        name: "Tests_Baselines"
        when: windowShown
        width: 200
        height: 200

        function test_baselineOffset_data()
        {
            return [
                { tag: "Text",   controlSpec: "Text { text: \"LLLLLLLLLLLLLLL\"}"},
                { tag: "Button", controlSpec: "Button { text: \"LLLLLLLLLLLLLLL\"}"},
                //{ tag: "SpinBox", controlSpec: "SpinBox { implicitWidth: 80; prefix:\"LLLLLLLLLLLLLL\"; value: 2}"},
                //{ tag: "CheckBox", controlSpec: "CheckBox { text: \"LLLLLLLLLLLLLL\" }"},
            ];
        }

        function test_baselineOffset(data)
        {
            var item = Qt.createQmlObject('import QtQuick 2.1;import QtQuick.Controls 1.1;' + data.controlSpec,
                                          container, '')
            waitForRendering(item)
            var img = grabImage(item);

            // the image object returned by grabImage does not have width and height properties,
            // but its dimensions should be the same as the item it was grabbed from
            var imgWidth = item.width
            var imgHeight = item.height

            var lineIntensities = []
            var lineSum = 0;
            for (var y = 0; y < imgHeight; ++y) {
                var lineIntensity = 0
                for (var x = 0; x < imgWidth; ++x)
                    lineIntensity += img.red(x,y) + img.green(x,y) + img.blue(x,y)

                lineIntensities.push(lineIntensity)
                lineSum += lineIntensity
            }
            var lineAverage = lineSum / imgHeight;
            // now that we have the whole controls _average_ intensity, we assume that the lineIntensity
            // with the biggest difference in intensity from the lineAverage is where the baseline is.
            var visualBaselineOffset = -1
            var maxDifferenceFromAverage = 0;
            for (var y = 0; y < lineIntensities.length; ++y) {
                var differenceFromAverage = Math.abs(lineAverage - lineIntensities[y])
                if (differenceFromAverage > maxDifferenceFromAverage) {
                    maxDifferenceFromAverage = differenceFromAverage
                    visualBaselineOffset = y;
                }
            }

            // Allow that the visual baseline is one off
            // This is mainly because baselines of text are actually one pixel *below* the text baseline
            // In addition it is an acceptable error
            var threshold = (Qt.platform.os === "osx" ? 2 : 1)      // its only 2 on osx 10.7, but we cannot determine the os version from here.
            fuzzyCompare(visualBaselineOffset, item.baselineOffset, threshold)

            item.destroy();
        }

    }
}
