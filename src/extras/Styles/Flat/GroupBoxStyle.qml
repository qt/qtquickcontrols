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

import QtQml 2.14 as Qml
import QtQuick 2.2
import QtQuick.Controls.Private 1.0 as Private
import QtQuick.Controls.Styles.Flat 1.0

Private.GroupBoxStyle {
    id: root

    readonly property int spacing: Math.round(8 * FlatStyle.scaleFactor)

    padding {
        left: spacing
        right: spacing
        bottom: spacing
    }

    textColor: !control.enabled ? FlatStyle.disabledColor : check.activeFocus ? FlatStyle.focusedTextColor : FlatStyle.defaultTextColor

    panel: Item {
        anchors.fill: parent

        Rectangle {
            id: background
            radius: FlatStyle.radius
            border.width: control.flat ? 0 : FlatStyle.onePixel
            border.color: FlatStyle.lightFrameColor
            color: control.flat ? FlatStyle.flatFrameColor : "transparent"
            anchors.fill: parent
            anchors.topMargin: Math.max(indicator.height, label.height) + root.spacing / 2
        }

        // TODO:
        Qml.Binding {
            target: root.padding
            property: "top"
            value: background.anchors.topMargin + root.spacing
            restoreMode: Binding.RestoreBinding
        }

        CheckBoxDrawer {
            id: indicator
            visible: control.checkable
            controlEnabled: control.enabled
            controlActiveFocus: check.activeFocus
            controlPressed: check.pressed
            controlChecked: control.checked
            anchors.left: parent.left
            // compensate padding around check indicator
            anchors.leftMargin: Math.round(-3 * FlatStyle.scaleFactor)
        }

        Text {
            id: label
            anchors.left: control.checkable ? indicator.right : parent.left
            anchors.right: parent.right
            anchors.verticalCenter: indicator.verticalCenter
            anchors.leftMargin: control.checkable ? root.spacing / 2 : 0
            text: control.title
            color: root.textColor
            renderType: FlatStyle.__renderType
            elide: Text.ElideRight
            font.family: FlatStyle.fontFamily
            font.pixelSize: 16 * FlatStyle.scaleFactor
        }
    }
}
