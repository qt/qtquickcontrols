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
import QtDesktop 1.0
import "../shared"

Page {

    ColumnLayout {
        id: root
        anchors.fill: parent
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 20

        property int globalItemHeight: 50

        spacing: 20

        Row {
            id: setupfields
            width: parent.width
            spacing: 20

            Column {
                anchors.margins: 10
                width: parent.width*2/3 - 10

                TitleColumnField {
                    text: "SpinBox Setup"
                }

                SetupField {
                    id: minimumValue
                    property variant defaultValue: spinbox.minimumValue
                    property string title: "Min"
                    onValidated: spinbox.minimumValue = validatedValue
                }

                SetupField {
                    id: maximumValue
                    property variant defaultValue: spinbox.maximumValue
                    property string title: "Max"
                    onValidated: spinbox.maximumValue = validatedValue
                }

                SetupField {
                    id: singleStep
                    property variant defaultValue: spinbox.stepSize
                    property string title: "Step"
                    onValidated: spinbox.stepSize = validatedValue
                }

                SetupField {
                    id: suffix
                    property variant defaultValue: spinbox.suffix
                    property string title: "Suffix"
                    property bool isText: true
                    onValidated: spinbox.suffix = validatedValue
                }

                SetupField {
                    id: prefix
                    property variant defaultValue: "Not implemented"; //spinbox.prefix
                    property string title: "Prefix"
                    property bool isText: true
                    enabled: false // not yet implemented
                    onValidated: spinbox.prefix = validatedValue
                }

                SetupField {
                    id: value
                    property variant defaultValue: spinbox.value
                    property string title: "Value"
                    onValidated: spinbox.value = validatedValue
                }

                SetupField {
                    id: font
                    property variant defaultValue: spinbox.font.pixelSize
                    property string title: "font"
                    onValidated: spinbox.font.pixelSize = validatedValue
                }

                Item {
                    height: decimalSpinBox.height
                    width: parent.width

                    Label {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Decimals"
                        color: "white"
                    }

                    SpinBox {
                        id: decimalSpinBox
                        anchors.right: parent.right
                        decimals: 0
                        maximumValue: 5
                    }
                }
            }

            Column {
                width: parent.width/3 - 10

                anchors.margins: 10

                TitleColumnField {
                    text: "Signals Counts\nChanged Values"
                }

                CountField {
                    id: signalMinimumValueChangedCount
                    property string title: "Min"
                }

                CountField {
                    id: signalMaximumValueChangedCount
                    property string title: "Max"
                }

                CountField {
                    id: signalStepSizeChangedCount
                    property string title: "SingleStep"
                }

                CountField {
                    id: signalSuffixChangedCount
                    property string title: "Suffix"
                }

                CountField {
                    id: signalPrefixChangedCount
                    property string title: "Prefix"
                }

                CountField {
                    id: signalInputMaskChangedCount
                    property string title: "InputMask"
                }

                CountField {
                    id: signalValueChangedCount
                    property string title: "Value"
                }
            }
        }

        RowLayout {
            id: arrowenabled
            width: parent.width

            BooleanField {
                title: "UpEnabled"
                status: spinbox.__upEnabled
            }

            BooleanField {
                title: "DownEnabled"
                status: spinbox.__downEnabled
            }
        }

        RowLayout {
            id: pressed
            width: parent.width

            BooleanField {
                title: "UpPressed"
                status: spinbox.__upPressed
            }

            BooleanField {
                title: "DownPressed"
                status: spinbox.__downPressed
            }
        }

        SpinBox {
            id: spinbox

            width: parent.width
            decimals: decimalSpinBox.value

            onMaximumValueChanged: signalMaximumValueChangedCount.increment()
            onMinimumValueChanged: signalMinimumValueChangedCount.increment()
            onStepSizeChanged: signalStepSizeChangedCount.increment()
            onSuffixChanged: signalSuffixChangedCount.increment()
            onValueChanged: signalValueChangedCount.increment()
            onPrefixChanged: signalPrefixChangedCount.increment() // not yet implemented
        }
    }
}
