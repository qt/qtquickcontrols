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

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import "Styles/Settings.js" as Settings

/*!
    \qmltype SpinBox
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup controls
    \brief SpinBox provides a spin box control.

    SpinBox allows the user to choose a value by clicking the up/down buttons or pressing up/down on the keyboard to increase/decrease
    the value currently displayed. The user can also type the value in manually.

    By default the SpinBox provides discrete values in the range [0-99] with a \l stepSize of 1 and 0 \l decimals.

    \code
    SpinBox {
        id: spinbox
    }
    \endcode

    Note that if you require decimal values you will need to set the \l decimals to a non 0 value.

    \code
    SpinBox {
        id: spinbox
        decimals: 2
    }
    \endcode

*/

Control {
    id: spinbox

    /*!
        The value of this SpinBox, clamped to \l minimumValue and \l maximumValue.

        The default value is \c 0
    */
    property real value: 0

    /*!
        The minimum value of the SpinBox range.
        The \l value is clamped to this value.

        The default value is \c 0
    */
    property real minimumValue: 0

    /*!
        The maximum value of the SpinBox range.
        The \l value is clamped to this value. If maximumValue is smaller than
        \l minimumValue, \l minimumValue will be enforced.

        The default value is \c 99
    */
    property real maximumValue: 99

    /*!
        The amount by which the \l value is incremented/decremented when a
        spin button is pressed.

        The default value is 1.0.
    */
    property real stepSize: 1.0

    /*! The suffix for the value. I.e "cm" */
    property string suffix

    /*! The prefix for the value. I.e "$" */
    property string prefix

    /*! This property indicates the amount of decimals.
      Note that if you enter more decimals than specified, they will
      be truncated to the specified amount of decimal places.
      The default value is \c 0
    */
    property int decimals: 0

    /*! \qmlproperty font SpinBox::font

        This property indicates the current font used by the SpinBox.
    */
    property alias font: input.font

    /*! This property indicates if the Spinbox should get active
      focus when pressed.
      The default value is \c true
    */
    property bool activeFocusOnPress: true

    /*! \internal */
    style: Qt.createComponent(Settings.THEME_PATH + "/SpinBoxStyle.qml", spinbox)

    /*! \internal */
    function __increment() {
        input.setValue(input.text)
        value += stepSize
        if (value > maximumValue)
            value = maximumValue
        input.text = value.toFixed(decimals)
    }

    /*! \internal */
    function __decrement() {
        input.setValue(input.text)
        value -= stepSize
        if (value < minimumValue)
            value = minimumValue
        input.text =  value.toFixed(decimals)
    }

    /*! \internal */
    property bool __initialized: false
    /*! \internal */
    readonly property bool __upEnabled: value != maximumValue;
    /*! \internal */
    readonly property bool __downEnabled: value != minimumValue;
    /*! \internal */
    readonly property alias __upPressed: mouseUp.pressed
    /*! \internal */
    readonly property alias __downPressed: mouseDown.pressed
    /*! \internal */
    property alias __upHovered: mouseUp.containsMouse
    /*! \internal */
    property alias __downHovered: mouseDown.containsMouse
    /*! \internal */
    property alias __containsMouse: mouseArea.containsMouse
    /*! \internal */
    property alias __text: input.text
    /*! \internal */
    readonly property int __contentHeight: Math.max(input.implicitHeight, 20)
    /*! \internal */
    readonly property int __contentWidth: suffixItem.implicitWidth +
                                   Math.max(maxSizeHint.implicitWidth,
                                            minSizeHint.implicitWidth) +
                                   prefixItem.implicitWidth
    Text {
        id: maxSizeHint
        text: maximumValue.toFixed(decimals)
        font: input.font
        visible: false
    }

    Text {
        id: minSizeHint
        text: minimumValue.toFixed(decimals)
        font: input.font
        visible: false
    }

    /*! \internal */
    onDecimalsChanged: input.setValue(value)
    /*! \internal */
    onMaximumValueChanged: input.setValue(value)
    /*! \internal */
    onMinimumValueChanged: input.setValue(value)
    /*! \internal */
    Component.onCompleted: {
        __initialized = true;
        input.setValue(value)
    }

    /*! \internal */
    onValueChanged: if (__initialized) input.setValue(value)

    Accessible.name: input.text
    Accessible.role: Accessible.SpinBox

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: if (activeFocusOnPress) input.forceActiveFocus()
    }

    Row {
        id: textLayout
        anchors.fill: parent
        spacing: 1
        clip: true
        anchors.leftMargin: __panel ? __panel.leftMargin : 0
        anchors.topMargin: __panel ? __panel.topMargin : 0
        anchors.rightMargin: __panel ? __panel.rightMargin: 0
        anchors.bottomMargin: __panel ? __panel.bottomMargin: 0

        Text {
            id: prefixItem
            text: prefix
            color: __panel ? __panel.foregroundColor : "black"
            anchors.verticalCenter: parent.verticalCenter
            renderType: Text.NativeRendering
        }

        TextInput {
            id: input
            anchors.verticalCenter: parent.verticalCenter
            activeFocusOnPress: spinbox.activeFocusOnPress
            function setValue(v) {
                var newval = parseFloat(v)

                if (!isNaN(newval)) {
                    // we give minimumValue priority over maximum if they are inconsistent
                    if (newval > maximumValue && maximumValue >= minimumValue)
                        newval = maximumValue
                    else if (v < minimumValue)
                        newval = minimumValue
                    newval = newval.toFixed(decimals)
                    spinbox.value = parseFloat(newval)
                    input.text = newval
                } else {
                    input.text = parseFloat(spinbox.value)
                }
            }

            horizontalAlignment: __panel ? __panel.horizontalTextAlignment : Qt.AlignLeft
            verticalAlignment: __panel ? __panel.verticalTextAlignment : Qt.AlignVCenter
            selectByMouse: true

            validator: DoubleValidator { bottom: minimumValue; top: maximumValue; }
            onAccepted: setValue(input.text)
            color: __panel ? __panel.foregroundColor : "black"
            selectionColor: __panel ? __panel.selectionColor : "black"
            selectedTextColor: __panel ? __panel.selectedTextColor : "black"

            opacity: parent.enabled ? 1 : 0.5
            renderType: Text.NativeRendering
        }
        Text {
            id: suffixItem
            text: suffix
            color: __panel ? __panel.foregroundColor : "black"
            anchors.verticalCenter: parent.verticalCenter
            renderType: Text.NativeRendering
        }
    }

    // Spinbox increment button

    MouseArea {
        id: mouseUp
        hoverEnabled: true

        property var upRect: __panel  ?  __panel.upRect : null

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: upRect ? upRect.x : 0
        anchors.topMargin: upRect ? upRect.y : 0

        width: upRect ? upRect.width : 0
        height: upRect ? upRect.height : 0

        onClicked: __increment()

        property bool autoincrement: false;
        onReleased: autoincrement = false
        Timer { running: mouseUp.pressed; interval: 350 ; onTriggered: mouseUp.autoincrement = true }
        Timer { running: mouseUp.autoincrement; interval: 60 ; repeat: true ; onTriggered: __increment() }
    }

    // Spinbox decrement button

    MouseArea {
        id: mouseDown
        hoverEnabled: true

        onClicked: __decrement()
        property var downRect: __panel ? __panel.downRect : null

        anchors.left: parent.left
        anchors.top: parent.top

        anchors.leftMargin: downRect ? downRect.x : 0
        anchors.topMargin: downRect ? downRect.y : 0

        width: downRect ? downRect.width : 0
        height: downRect ? downRect.height : 0

        property bool autoincrement: false;
        onReleased: autoincrement = false
        Timer { running: mouseDown.pressed; interval: 350 ; onTriggered: mouseDown.autoincrement = true }
        Timer { running: mouseDown.autoincrement; interval: 60 ; repeat: true ; onTriggered: __decrement() }
    }

    Keys.onUpPressed: __increment()
    Keys.onDownPressed: __decrement()
}
