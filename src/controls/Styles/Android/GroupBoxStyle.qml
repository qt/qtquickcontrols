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

import QtQml 2.14 as Qml
import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

GroupBoxStyle {
    id: root

    panel: Item {
        anchors.fill: parent

        readonly property var styleDef: AndroidStyle.styleDef.checkboxStyle

        readonly property real contentMargin: label.implicitHeight / 3
        readonly property real topMargin: control.checkable ? indicator.height : label.height
        Qml.Binding {
            target: root
            property: "padding.top"
            value: topMargin + contentMargin
            restoreMode: Binding.RestoreBinding
        }
        Qml.Binding {
            target: root
            property: "padding.left"
            value: contentMargin
            restoreMode: Binding.RestoreBinding
        }
        Qml.Binding {
            target: root
            property: "padding.right"
            value: contentMargin
            restoreMode: Binding.RestoreBinding
        }
        Qml.Binding {
            target: root
            property: "padding.bottom"
            value: contentMargin
            restoreMode: Binding.RestoreBinding
        }

        DrawableLoader {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: topMargin
            styleDef: AndroidStyle.styleDef.actionBarStyle.ActionBar_divider
        }

        DrawableLoader {
            active: !control.flat
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.topMargin: topMargin
            styleDef: AndroidStyle.styleDef.actionBarStyle.ActionBar_divider
        }

        DrawableLoader {
            active: !control.flat
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: topMargin
            styleDef: AndroidStyle.styleDef.actionBarStyle.ActionBar_divider
        }

        DrawableLoader {
            active: !control.flat
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            styleDef: AndroidStyle.styleDef.actionBarStyle.ActionBar_divider
        }

        DrawableLoader {
            id: indicator
            active: control.checkable
            checked: control.checked
            pressed: check.pressed
            focused: check.activeFocus
            window_focused: control.Window.active
            styleDef: AndroidStyle.styleDef.checkboxStyle.CompoundButton_button
            width: control.checkable ? item.implicitWidth : 0
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: topMargin / 2
        }

        LabelStyle {
            id: label
            text: control.title
            pressed: check.pressed
            selected: control.checked
            focused: check.activeFocus
            window_focused: control.Window.active
            styleDef: AndroidStyle.styleDef.checkboxStyle

            anchors.left: indicator.right
            anchors.right: parent.right
            anchors.verticalCenter: parent.top
            anchors.verticalCenterOffset: topMargin / 2
        }
    }
}
