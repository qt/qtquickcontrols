/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import QtQuick 1.1
import "custom" as Components

// jens: ContainsMouse breaks drag functionality

Item {
    id: dial

    width: 100
    height: 100

    property alias maximumValue: range.maximumValue
    property alias minimumValue: range.minimumValue
    property alias containsMouse: mouseArea.containsMouse
    property alias value: range.value
    property alias stepSize: range.stepSize

    property bool wrapping: false
    property bool tickmarksEnabled: false
    property bool activeFocusOnPress: false

    RangeModel {
        id: range
        minimumValue: 0.0
        maximumValue: 1.0
        stepSize: 0.0
        value: 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill:parent
        property bool inDrag
        hoverEnabled:true

        onPositionChanged: {
            if (pressed) {
                value = valueFromPoint(mouseX, mouseY)
                inDrag = true
            }
        }
        onPressed: {
            value = valueFromPoint(mouseX, mouseY)
             if (activeFocusOnPress) dial.focus = true
        }

        onReleased:inDrag = false;
        function bound(val) { return Math.max(minimumValue, Math.min(maximumValue, val)); }

        function valueFromPoint(x, y)
        {
            var yy = height/2.0 - y;
            var xx = x - width/2.0;
            var a = (xx || yy) ? Math.atan2(yy, xx) : 0;

            if (a < Math.PI/ -2)
                a = a + Math.PI * 2;

            var dist = 0;
            var minv = minimumValue*100, maxv = maximumValue*100;

            if (minimumValue < 0) {
                dist = -minimumValue;
                minv = 0;
                maxv = maximumValue + dist;
            }

            var r = maxv - minv;
            var v;
            if (wrapping)
                v =  (0.5 + minv + r * (Math.PI * 3 / 2 - a) / (2 * Math.PI));
            else
                v =  (0.5 + minv + r* (Math.PI * 4 / 3 - a) / (Math.PI * 10 / 6));

            if (dist > 0)
                v -= dist;
            return maximumValue - bound(v/100)
        }
    }
    StyleItem {
        anchors.fill: parent
        elementType: "dial"
        hasFocus: dial.focus
        sunken: mouseArea.pressed
        maximum: range.maximumValue * 100
        minimum: range.minimumValue * 100
        value: visualPos * 100
        enabled: dial.enabled
        step: range.stepSize * 100
        activeControl: tickmarksEnabled ? "tick" : ""
        property double visualPos : range.value

        Behavior on visualPos {
            enabled: !mouseArea.inDrag
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutSine
            }
        }
    }
    WheelArea {
        id: wheelarea
        anchors.fill: parent
        horizontalMinimumValue: dial.minimumValue
        horizontalMaximumValue: dial.maximumValue
        verticalMinimumValue: dial.minimumValue
        verticalMaximumValue: dial.maximumValue
        property double step: (dial.maximumValue - dial.minimumValue)/100

        onVerticalWheelMoved: {
            value += verticalDelta/4*step
        }

        onHorizontalWheelMoved: {
            value += horizontalDelta/4*step
        }
    }
}
