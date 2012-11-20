/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
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
import QtDesktop.Styles 1.0

Item {
    id: flickable
    anchors.fill: parent
    enabled: enabledCheck.checked

    property string tabPosition: tabPositionGroup.checkedButton == r2 ? "South" : "North"

    Row {
        id: contentRow
        anchors.fill:parent
        anchors.margins: 8
        spacing: 16
        Column {
            spacing: 9
            Row {
                spacing:8
                Button {
                    id: button1
                    text: "Button 1"
                    width: 96
                    tooltip:"This is an interesting tool tip"
                    KeyNavigation.tab: button2
                }
                Button {
                    id:button2
                    text:"Button 2"
                    width:96
                    KeyNavigation.tab: combo
                }
            }
            ComboBox {
                id: combo;
                model: choices;
                width: parent.width;
                KeyNavigation.tab: t1
            }
            Row {
                spacing: 8
                SpinBox {
                    id: t1
                    width: 97

                    minimumValue: -50
                    value: -20

                    KeyNavigation.tab: t2
                }
                SpinBox {
                    id: t2
                    width:97
                    KeyNavigation.tab: t3
                }
            }
            TextField {
                id: t3
                KeyNavigation.tab: slider
                placeholderText: "This is a placeholder for a TextField"
            }
            ProgressBar {
                // normalize value [0.0 .. 1.0]
                value: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
            }
            ProgressBar {
                indeterminate: true
            }
            Slider {
                id: slider
                value: 0.5
                tickmarksEnabled: tickmarkCheck.checked
                KeyNavigation.tab: frameCheckbox
            }
        }
        Column {
            id: rightcol
            spacing: 12
            GroupBox {
                id: group1
                title: "CheckBox"
                width: area.width
                adjustToContentSize: true
                ButtonRow {
                    exclusive: false
                    CheckBox {
                        id: frameCheckbox
                        text: "Text frame"
                        checked: true
                        KeyNavigation.tab: tickmarkCheck
                    }
                    CheckBox {
                        id: tickmarkCheck
                        text: "Tickmarks"
                        checked: true
                        KeyNavigation.tab: r1
                    }
                }
            }
            GroupBox {
                id: group2
                title:"Tab Position"
                width: area.width
                adjustToContentSize: true
                ButtonRow {
                    id: tabPositionGroup
                    exclusive: true
                    RadioButton {
                        id: r1
                        text: "North"
                        KeyNavigation.tab: r2
                        checked: true
                    }
                    RadioButton {
                        id: r2
                        text: "South"
                        KeyNavigation.tab: area
                    }
                }
            }

            TextArea {
                id: area
                frame: frameCheckbox.checked
                text: loremIpsum + loremIpsum
                KeyNavigation.tab: button1
            }
        }
    }
}
