/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

Style {
    readonly property CheckBox control: __control

    property Component panel: Item {
        id: panel

        readonly property var styleDef: AndroidStyle.styleDef.checkboxStyle

        readonly property real minWidth: styleDef.View_minWidth || 0
        readonly property real minHeight: styleDef.View_minHeight || 0

        implicitWidth: Math.max(minWidth, indicator.implicitWidth + label.implicitWidth)
        implicitHeight: Math.max(minHeight, Math.max(indicator.implicitHeight, label.implicitHeight))

        DrawableLoader {
            id: indicator
            pressed: control.pressed
            checked: control.checked
            focused: control.activeFocus
            window_focused: control.Window.active
            styleDef: panel.styleDef.CompoundButton_button
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }

        LabelStyle {
            id: label
            text: StyleHelpers.removeMnemonics(control.text)
            pressed: control.pressed
            focused: control.activeFocus
            selected: control.checked
            window_focused: control.Window.active
            styleDef: panel.styleDef

            anchors.fill: parent
            anchors.leftMargin: indicator.width // TODO: spacing
        }
    }
}
