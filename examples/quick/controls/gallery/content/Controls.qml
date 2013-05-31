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





import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

Item {
    id: flickable
    anchors.fill: parent
    enabled: enabledCheck.checked

    property int tabPosition: tabPositionGroup.current === r2 ? Qt.BottomEdge : Qt.TopEdge

    Row {
        id: contentRow
        anchors.fill:parent
        anchors.margins: 8
        spacing: 16
        Column {
            id: firstColumn
            spacing: 9
            Row {
                spacing:8
                Button {
                    id: button1
                    text: "Button 1"
                    width: 92
                    tooltip:"This is an interesting tool tip"
                }
                Button {
                    id:button2
                    text:"Button 2"
                    width: 102
                    menu: Menu {
                        MenuItem { text: "This Button" }
                        MenuItem { text: "Happens To Have" }
                        MenuItem { text: "A Menu Assigned" }
                    }
                }
            }
            ComboBox {
                id: combo;
                model: choices;
                width: parent.width;
                currentIndex: 2
            }
            Row {
                spacing: 8
                SpinBox {
                    id: t1
                    width: 97

                    minimumValue: -50
                    value: -20
                }
                SpinBox {
                    id: t2
                    width:97
                }
            }
            TextField {
                id: t3
                placeholderText: "This is a placeholder for a TextField"
                width: 200
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
                width: 200
                tickmarksEnabled: tickmarkCheck.checked
            }
        }
        Column {
            id: rightcol
            spacing: 12
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            GroupBox {
                id: group1
                title: "CheckBox"
                width: area.width
                Row {
                    CheckBox {
                        id: frameCheckbox
                        text: "Text frame"
                        checked: true
                        width: 100
                    }
                    CheckBox {
                        id: tickmarkCheck
                        text: "Tickmarks"
                        checked: false
                    }
                    CheckBox {
                        id: wrapCheck
                        text: "Word wrap"
                        checked: true
                    }
                }
            }
            GroupBox {
                id: group2
                title:"Tab Position"
                width: area.width
                Row {
                    ExclusiveGroup { id: tabPositionGroup }
                    RadioButton {
                        id: r1
                        text: "Top"
                        checked: true
                        exclusiveGroup: tabPositionGroup
                        width: 100
                    }
                    RadioButton {
                        id: r2
                        text: "Bottom"
                        exclusiveGroup: tabPositionGroup
                    }
                }
            }

            TextArea {
                id: area
                frameVisible: frameCheckbox.checked
                text: loremIpsum + loremIpsum
                wrapMode: wrapCheck.checked ? TextEdit.WordWrap : TextEdit.NoWrap
                width: contentRow.width - firstColumn.width - contentRow.spacing
                height: parent.height - group1.height - group2.height - 2 * parent.spacing
                anchors { right: parent.right }
            }

            MouseArea {
                id: contextMenu
                parent: area.viewport
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onPressed: editmenu.popup()
            }
        }
    }
}
