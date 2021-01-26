/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2 as Base
import QtQuick.Controls.Styles.Flat 1.0
import QtQuick.Controls.Private 1.0

Base.ButtonStyle {
    padding { top: 0; left: 0; right: 0; bottom: 0 }

    panel: Item {
        id: panelItem

        readonly property bool isDown: control.pressed || (control.checkable && control.checked)
        readonly property bool hasIcon: icon.status === Image.Ready || icon.status === Image.Loading
        readonly property bool hasMenu: !!control.menu
        readonly property bool hasText: !!control.text
        readonly property real margins: 10 * FlatStyle.scaleFactor

        ToolButtonBackground {
            id: background
            anchors.fill: parent
            buttonEnabled: control.enabled
            buttonHasActiveFocus: control.activeFocus
            buttonPressed: control.pressed
            buttonChecked: control.checkable && control.checked
            buttonHovered: !Settings.hasTouchScreen && control.hovered
        }

        implicitWidth: icon.implicitWidth + label.implicitWidth + indicator.implicitHeight
                       + (hasIcon || hasText ? panelItem.margins : 0) + (hasIcon && hasText ? panelItem.margins : 0)
        implicitHeight: Math.max(background.height, Math.max(icon.implicitHeight, Math.max(label.implicitHeight, indicator.height)))
        baselineOffset: label.y + label.baselineOffset

        Image {
            id: icon
            visible: hasIcon
            source: control.iconSource
            anchors.leftMargin: panelItem.margins
            anchors.verticalCenter: parent.verticalCenter
            // center align when only icon, otherwise left align
            anchors.left: hasMenu || hasText ? parent.left : undefined
            anchors.horizontalCenter: !hasMenu && !hasText ? parent.horizontalCenter : undefined
        }
        Text {
            id: label
            visible: hasText
            text: control.text
            elide: Text.ElideRight
            font.family: FlatStyle.fontFamily
            renderType: FlatStyle.__renderType
            color: !enabled ? FlatStyle.disabledColor : panelItem.isDown && control.activeFocus
                    ? FlatStyle.selectedTextColor : control.activeFocus
                    ? FlatStyle.focusedColor : FlatStyle.defaultTextColor
            opacity: !enabled ? FlatStyle.disabledOpacity : 1.0
            horizontalAlignment: hasMenu && !hasIcon ? Qt.AlignLeft : Qt.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: icon.right
            anchors.right: indicator.left
            anchors.leftMargin: hasIcon ? panelItem.margins : 0
            anchors.rightMargin: hasMenu ? 0 : panelItem.margins
        }
        ToolButtonIndicator {
            id: indicator
            visible: panelItem.hasMenu
            buttonEnabled: control.enabled
            buttonHasActiveFocus: control.activeFocus
            buttonPressedOrChecked: panelItem.isDown
            anchors.verticalCenter: parent.verticalCenter
            // center align when only menu, otherwise right align
            anchors.right: hasIcon || hasText ? parent.right : undefined
            anchors.horizontalCenter: !hasIcon && !hasText ? parent.horizontalCenter : undefined
        }
    }
}
