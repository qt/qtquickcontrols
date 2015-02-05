/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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
import QtQuick.Controls.Private 1.0

Style {
    readonly property RadioButton control: __control
    property Component panel: Item {
        anchors.fill: parent

        implicitWidth:  styleitem.implicitWidth
        implicitHeight: styleitem.implicitHeight
        baselineOffset: styleitem.baselineOffset

        StyleItem {
            id: styleitem
            elementType: "radiobutton"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: macStyle ? -1 : 0
            sunken: control.pressed
            on: control.checked || control.pressed
            hover: control.hovered
            enabled: control.enabled
            hasFocus: control.activeFocus && styleitem.style == "mac"
            hints: control.styleHints
            contentHeight: textitem.implicitHeight
            contentWidth: Math.ceil(textitem.implicitWidth) + 4
            property int indicatorWidth: pixelMetric("indicatorwidth") + (macStyle ? 2 : 4)
            property bool macStyle: (style === "mac")

            Text {
                id: textitem
                text: control.text
                anchors.left: parent.left
                anchors.leftMargin: parent.indicatorWidth
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: parent.macStyle ? 2 : 0
                anchors.right: parent.right
                renderType: Text.NativeRendering
                elide: Text.ElideRight
                enabled: control.enabled
                color: SystemPaletteSingleton.windowText(control.enabled)
                StyleItem {
                    elementType: "focusrect"
                    anchors.margins: -1
                    anchors.leftMargin: -2
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    width: textitem.implicitWidth + 3
                    visible: control.activeFocus
                }
            }
        }
    }
}
