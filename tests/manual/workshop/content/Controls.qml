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
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

Item {
    id: flickable
    anchors.fill: parent
    enabled: enabledCheck.checked

    property int tabPosition: tabPositionGroup.current === r2 ? Qt.BottomEdge : Qt.TopEdge

    property string loremIpsum:
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor "+
            "incididunt ut labore et dolore magna aliqua.\n Ut enim ad minim veniam, quis nostrud "+
            "exercitation ullamco laboris nisi ut aliquip ex ea commodo cosnsequat. ";

    ListModel {
        id: choices
        ListElement { text: "Banana" }
        ListElement { text: "Orange" }
        ListElement { text: "Apple" }
        ListElement { text: "Coconut" }
    }

    RowLayout {
        id: contentRow
        anchors.fill:parent
        anchors.margins: 8
        spacing: 16
        ColumnLayout {
            id: firstColumn
            Layout.minimumWidth: implicitWidth
            Layout.fillWidth: false
            RowLayout {
                id: buttonrow
                Button {
                    id: button1
                    text: "Button 1"
                    tooltip:"This is an interesting tool tip"
                    Layout.fillWidth: true
                }
                Button {
                    id:button2
                    text:"Button 2"
                    Layout.fillWidth: true
                    menu: Menu {
                        MenuItem { text: "This Button" }
                        MenuItem { text: "Happens To Have" }
                        MenuItem { text: "A Menu Assigned" }
                    }
                }
            }
            ComboBox {
                id: combo
                model: choices
                currentIndex: 2
                Layout.fillWidth: true
            }
            ComboBox {
                model: Qt.fontFamilies()
                Layout.fillWidth: true
                currentIndex: 47
            }
            ComboBox {
                id: editableCombo
                editable: true
                model: choices
                Layout.fillWidth: true
                currentIndex: 2
                onAccepted: {
                    if (editableCombo.find(currentText) === -1) {
                        choices.append({text: editText})
                        currentIndex = editableCombo.find(editText)
                    }
                }
            }
            RowLayout {
                SpinBox {
                    id: t1
                    Layout.fillWidth: true
                    minimumValue: -50
                    value: -20
                }
                SpinBox {
                    id: t2
                    Layout.fillWidth: true
                }
            }
            TextField {
                id: t3
                placeholderText: "This is a placeholder for a TextField"
                Layout.fillWidth: true
            }
            ProgressBar {
                // normalize value [0.0 .. 1.0]
                value: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
                Layout.fillWidth: true
            }
            ProgressBar {
                indeterminate: true
                Layout.fillWidth: true
            }
            Slider {
                id: slider
                value: 0.5
                Layout.fillWidth: true
                tickmarksEnabled: tickmarkCheck.checked
                stepSize: tickmarksEnabled ? 0.1 : 0
            }
            MouseArea {
                id: busyCheck
                Layout.fillWidth: true
                Layout.fillHeight: true
                hoverEnabled:true
                Layout.preferredHeight: busyIndicator.height
                BusyIndicator {
                    id: busyIndicator
                    running: busyCheck.containsMouse
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
        ColumnLayout {
            id: rightcol
            Layout.fillWidth: true
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            GroupBox {
                id: group1
                title: "CheckBox"
                Layout.fillWidth: true
                RowLayout {
                    Layout.fillWidth: true
                    CheckBox {
                        id: frameCheckbox
                        text: "Text frame"
                        checked: true
                        Layout.minimumWidth: 100
                    }
                    CheckBox {
                        id: tickmarkCheck
                        text: "Tickmarks"
                        checked: false
                        Layout.minimumWidth: 100
                    }
                    CheckBox {
                        id: wrapCheck
                        text: "Word wrap"
                        checked: true
                        Layout.minimumWidth: 100
                    }
                }
            }
            GroupBox {
                id: group2
                title:"Tab Position"
                Layout.fillWidth: true
                RowLayout {
                    ExclusiveGroup { id: tabPositionGroup }
                    RadioButton {
                        id: r1
                        text: "Top"
                        checked: true
                        exclusiveGroup: tabPositionGroup
                        Layout.minimumWidth: 100
                    }
                    RadioButton {
                        id: r2
                        text: "Bottom"
                        exclusiveGroup: tabPositionGroup
                        Layout.minimumWidth: 100
                    }
                }
            }

            TextArea {
                id: area
                frameVisible: frameCheckbox.checked
                text: loremIpsum + loremIpsum
                textFormat: Qt.RichText
                wrapMode: wrapCheck.checked ? TextEdit.WordWrap : TextEdit.NoWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
                menu: editmenu
            }
        }
    }

    ExclusiveGroup {
        id: textFormatGroup

        Action {
            id: a1
            text: "Align &Left"
            checkable: true
            Component.onCompleted: checked = true
        }

        Action {
            id: a2
            text: "&Center"
            checkable: true
        }

        Action {
            id: a3
            text: "Align &Right"
            checkable: true
        }
    }

    Component {
        id: editmenu
        Menu {
            MenuItem { action: cutAction }
            MenuItem { action: copyAction }
            MenuItem { action: pasteAction }
            MenuSeparator {}
            Menu {
                title: "Text &Format"
                MenuItem { action: a1 }
                MenuItem { action: a2 }
                MenuItem { action: a3 }
                MenuSeparator { }
                MenuItem { text: "Allow &Hyphenation"; checkable: true }
            }
            Menu {
                title: "Font &Style"
                MenuItem { text: "&Bold"; checkable: true }
                MenuItem { text: "&Italic"; checkable: true }
                MenuItem { text: "&Underline"; checkable: true }
            }
        }
    }
}
