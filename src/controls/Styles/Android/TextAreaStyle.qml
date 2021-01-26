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
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

ScrollViewStyle {
    id: style

    readonly property TextArea control: __control

    transientScrollBars: true

    readonly property var styleDef: AndroidStyle.styleDef.editTextStyle

    readonly property int renderType: Text.QtRendering
    readonly property real textMargin: Math.max(styleDef.View_background.padding.top || 0,
                                                styleDef.View_background.padding.left || 0)

    readonly property alias font: label.font
    readonly property alias textColor: label.color
    readonly property alias placeholderTextColor: label.hintColor
    readonly property alias selectionColor: label.selectionColor
    readonly property color selectedTextColor: label.selectedTextColor
    readonly property color backgroundColor: control.backgroundVisible ? AndroidStyle.colorValue(styleDef.defaultBackgroundColor) : "transparent"

    LabelStyle {
        id: label
        visible: false
        enabled: control.enabled
        focused: control.activeFocus
        window_focused: focused && control.Window.active
        styleDef: style.styleDef
    }

    property Component __selectionHandle: DrawableLoader {
        styleDef: AndroidStyle.styleDef.textViewStyle.TextView_textSelectHandleLeft
        x: -width / 4 * 3
        y: styleData.lineHeight
    }

    property Component __cursorHandle: CursorHandleStyle { }
}
