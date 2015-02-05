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

ApplicationWindow {
    width: 400
    height: 400

    Rectangle {
        id: back
        anchors.fill: parent
        color: enabled ? "lightgray" : "wheat"
    }

    Column {
        spacing: 8
        anchors.centerIn: parent

        Row {
            Button {
                id: button1
                focus: true
                text: "Button 1"
                activeFocusOnPress: true
                KeyNavigation.tab: button2
                onClicked: back.enabled = !back.enabled
            }
            Button {
                id: button2
                text: "Button 2"
                activeFocusOnPress: true
                KeyNavigation.tab: button3
                KeyNavigation.backtab: button1
                onClicked: back.enabled = !back.enabled
            }
            Button {
                id: button3
                text: "Button 3"
                activeFocusOnPress: true
                KeyNavigation.tab: checkbox1
                KeyNavigation.backtab: button2
                onClicked: back.enabled = !back.enabled
            }
        }

        Row {
            CheckBox {
                id: checkbox1
                text: "Checkbox 1"
                activeFocusOnPress: true
                KeyNavigation.tab: checkbox2
                KeyNavigation.backtab: button3
                onClicked: back.enabled = !back.enabled
            }
            CheckBox {
                id: checkbox2
                text: "Checkbox 2"
                activeFocusOnPress: true
                KeyNavigation.tab: checkbox3
                KeyNavigation.backtab: checkbox1
                onClicked: back.enabled = !back.enabled
            }
            CheckBox {
                id: checkbox3
                text: "Checkbox 3"
                activeFocusOnPress: true
                KeyNavigation.tab: radioButton1
                KeyNavigation.backtab: checkbox2
                onClicked: back.enabled = !back.enabled
            }
        }

        Row {
            ExclusiveGroup { id: exclusive }
            RadioButton {
                id: radioButton1
                text: "RadioButton 1"
                exclusiveGroup: exclusive
                activeFocusOnPress: true
                KeyNavigation.tab: radioButton2
                KeyNavigation.backtab: checkbox3
                onClicked: back.enabled = !back.enabled
            }
            RadioButton {
                id: radioButton2
                text: "RadioButton 2"
                exclusiveGroup: exclusive
                activeFocusOnPress: true
                KeyNavigation.tab: radioButton3
                KeyNavigation.backtab: radioButton1
                onClicked: back.enabled = !back.enabled
            }
            RadioButton {
                id: radioButton3
                text: "RadioButton 3"
                exclusiveGroup: exclusive
                activeFocusOnPress: true
                KeyNavigation.backtab: radioButton2
                onClicked: back.enabled = !back.enabled
            }
        }
    }
}
