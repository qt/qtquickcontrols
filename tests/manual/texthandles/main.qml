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

import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

ApplicationWindow {
    id: window

    width: 800
    height: 480
    visible: true

    toolBar: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.margins: window.spacing
            CheckBox {
                id: selectBox
                text: "SelectByMouse"
                checked: true
            }
            CheckBox {
                id: handleBox
                text: "Handles"
                checked: true
                enabled: selectBox.checked
            }
            CheckBox {
                id: outlineBox
                text: "Outlines"
                checked: false
                enabled: handleBox.enabled && handleBox.checked
            }
            Item { width: 1; height: 1; Layout.fillWidth: true }
            CheckBox {
                id: wrapBox
                text: "Wrap"
                checked: true
            }
        }
    }

    property int spacing: edit.font.pixelSize / 2

    property string loremIpsum: "Lorem ipsum dolor sit amet, <a href='http://qt.digia.com'>consectetur</a> adipiscing elit. " +
                                "Morbi varius a lorem ac blandit. Donec eu nisl eu nisi consectetur commodo. " +
                                "Vestibulum tincidunt <img src='http://qt.digia.com/Static/Images/QtLogo.png'>ornare</img> tempor. " +
                                "Nulla dolor dui, vehicula quis tempor quis, ullamcorper vel dui. " +
                                "Integer semper suscipit ante, et luctus magna malesuada sed. " +
                                "Sed ipsum velit, pellentesque non aliquam eu, bibendum ac magna. " +
                                "Donec et luctus dolor. Nulla semper quis neque vitae cursus. " +
                                "Etiam auctor, ipsum vel varius tincidunt, erat lacus pulvinar sem, eu egestas leo nulla non felis. " +
                                "Maecenas hendrerit commodo turpis, ac convallis leo congue id. " +
                                "Donec et egestas ante, a dictum sapien."

    ColumnLayout {
        spacing: window.spacing
        anchors.margins: window.spacing
        anchors.fill: parent

        TextField {
            id: field
            z: 1
            text: loremIpsum
            Layout.fillWidth: true
            selectByMouse: selectBox.checked

            style: TextFieldStyle {
                __cursorHandle: handleBox.checked ? cursorDelegate : null
                __selectionHandle: handleBox.checked ? selectionDelegate : null
            }
        }

        SpinBox {
            id: spinbox
            z: 1
            decimals: 2
            value: 500000
            maximumValue: 1000000
            Layout.fillWidth: true
            selectByMouse: selectBox.checked
            horizontalAlignment: Qt.AlignHCenter

            style: SpinBoxStyle {
                __cursorHandle: handleBox.checked ? cursorDelegate : null
                __selectionHandle: handleBox.checked ? selectionDelegate : null
            }
        }

        ComboBox {
            id: combobox
            z: 1
            editable: true
            currentIndex: 1
            Layout.fillWidth: true
            selectByMouse: selectBox.checked
            model: ListModel {
                id: combomodel
                ListElement { text: "Apple" }
                ListElement { text: "Banana" }
                ListElement { text: "Coconut" }
                ListElement { text: "Orange" }
            }
            onAccepted: {
                if (find(currentText) === -1) {
                    combomodel.append({text: editText})
                    currentIndex = find(editText)
                }
            }

            style: ComboBoxStyle {
                __cursorHandle: handleBox.checked ? cursorDelegate : null
                __selectionHandle: handleBox.checked ? selectionDelegate : null
            }
        }

        TextArea {
            id: edit
            Layout.fillWidth: true
            Layout.fillHeight: true

            textFormat: Qt.RichText
            selectByMouse: selectBox.checked
            wrapMode: wrapBox.checked ? Text.Wrap : Text.NoWrap
            text: loremIpsum + "<p>" + loremIpsum + "<p>" + loremIpsum + "<p>" + loremIpsum

            style: TextAreaStyle {
                __cursorHandle: handleBox.checked ? cursorDelegate : null
                __selectionHandle: handleBox.checked ? selectionDelegate : null
            }
        }
    }

    Component {
        id: selectionDelegate
        Rectangle {
            x: -width + edit.font.pixelSize / 2
            y: (styleData.lineHeight - height) / 2
            width: edit.font.pixelSize * 2.5
            height: edit.font.pixelSize * 2.5
            border.width: outlineBox.checked ? 1 : 0
            radius: width / 4
            color: "transparent"
            Rectangle {
                color: "white"
                border.width: 1
                radius: width / 2
                width: height
                height: edit.font.pixelSize / 2
                anchors.right: parent.right
                anchors.rightMargin: width / 2
                anchors.verticalCenter: parent.verticalCenter
                visible: control.activeFocus && styleData.hasSelection
            }
        }
    }

    Component {
        id: cursorDelegate
        Rectangle {
            x: styleData.hasSelection ? -edit.font.pixelSize / 2 : -width / 2
            y: (styleData.lineHeight - height) / 2
            width: edit.font.pixelSize * 2.5
            height: edit.font.pixelSize * 2.5
            border.width: outlineBox.checked ? 1 : 0
            radius: width / 4
            color: "transparent"
            Rectangle {
                color: "white"
                border.width: 1
                radius: width / 2
                width: height
                height: edit.font.pixelSize / 2
                anchors.left: parent.left
                anchors.leftMargin: width / 2
                anchors.verticalCenter: parent.verticalCenter
                visible: control.activeFocus && styleData.hasSelection
            }
        }
    }
}
