/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
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
import QtDesktop 1.0
import "Styles/Settings.js" as Settings

// jens: ContainsMouse breaks drag functionality

/*!
    \qmltype Slider
    \inqmlmodule QtDesktop 1.0
    \brief Slider is doing bla...bla...
*/

Item {
    id: slider

    // Common API
    property int orientation: Qt.Horizontal
    property alias minimumValue: range.minimumValue
    property alias maximumValue: range.maximumValue
    property alias inverted: range.inverted
    property bool updateValueWhileDragging: true
    property alias pressed: mouseArea.pressed
    property alias stepSize: range.stepSize
    property alias hoverEnabled: mouseArea.hoverEnabled
    property alias value: range.value

    // Destop API
    property bool containsMouse: mouseArea.containsMouse
    property bool activeFocusOnPress: false
    property bool tickmarksEnabled: false
    property string tickPosition: "Below" // "Above", "Below", "BothSides"

    Accessible.role: Accessible.Slider
    Accessible.name: value

    // Reimplement this function to control how the value is shown in the
    // indicator.
    function formatValue(v) {
        return Math.round(v);
    }

    property var styleHints:[]
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/SliderStyle.qml")

    Keys.onRightPressed: value += (maximumValue - minimumValue)/10.0
    Keys.onLeftPressed: value -= (maximumValue - minimumValue)/10.0

    implicitWidth: loader.item ? loader.item.implicitWidth : 0
    implicitHeight: loader.item ? loader.item.implicitHeight : 0

    RangeModel {
        id: range
        minimumValue: 0.0
        maximumValue: 1.0
        value: 0
        stepSize: 0.0
        inverted: false

        positionAtMinimum: 0
        positionAtMaximum: slider.width
    }

    Loader {
        id: loader
        sourceComponent: style
        anchors.fill: parent
        property var control: slider
        function positionForValue(value) { return range.positionForValue(value) }
    }

    Item { id: fakeHandle }

    MouseArea {
        id: mouseArea

        hoverEnabled: true
        anchors.centerIn: parent

        width: parent.width
        height: parent.height

        drag.target: fakeHandle
        drag.axis: Drag.XAxis
        drag.minimumX: range.positionAtMinimum
        drag.maximumX: range.positionAtMaximum

        onPressed: {
            if (activeFocusOnPress)
                slider.focus = true;

            // Clamp the value
            var newX = Math.max(mouse.x, drag.minimumX);
            newX = Math.min(newX, drag.maximumX);

            // Debounce the press: a press event inside the handler will not
            // change its position, the user needs to drag it.

            // Note this really messes up things for scrollbar
            // if (Math.abs(newX - fakeHandle.x) > handleLoader.width / 2)
            range.position = newX;
        }

        onReleased: {
            // If we don't update while dragging, this is the only
            // moment that the range is updated.
            if (!slider.updateValueWhileDragging)
                range.position = fakeHandle.x;
        }
    }



    // Range position normally follow fakeHandle, except when
    // 'updateValueWhileDragging' is false. In this case it will only follow
    // if the user is not pressing the handle.
    Binding {
        when: updateValueWhileDragging || !mouseArea.pressed
        target: range
        property: "position"
        value: fakeHandle.x
    }

    // During the drag, we simply ignore position set from the range, this
    // means that setting a value while dragging will not "interrupt" the
    // dragging activity.
    Binding {
        when: !mouseArea.drag.active
        target: fakeHandle
        property: "x"
        value: range.position
    }


    WheelArea {
        id: wheelarea
        anchors.fill: parent
        horizontalMinimumValue: slider.minimumValue
        horizontalMaximumValue: slider.maximumValue
        verticalMinimumValue: slider.minimumValue
        verticalMaximumValue: slider.maximumValue
        property double step: (slider.maximumValue - slider.minimumValue)/100

        onVerticalWheelMoved: {
            value += verticalDelta/4*step
        }

        onHorizontalWheelMoved: {
            value += horizontalDelta/4*step
        }
    }
}
