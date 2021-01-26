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
    readonly property Slider control: __control

    property Component panel: Item {
        id: panel

        readonly property bool horizontal: control.orientation === Qt.Horizontal
        readonly property var styleDef: AndroidStyle.styleDef.seekBarStyle

        readonly property real thumbOffset: styleDef.thumbOffset || thumb.implicitWidth / 2

        readonly property real minWidth: styleDef.ProgressBar_minWidth || styleDef.View_minWidth || 0
        readonly property real minHeight: styleDef.ProgressBar_minHeight || styleDef.View_minHeight || 0

        readonly property real preferredWidth: Math.max(minWidth, track.implicitWidth)
        readonly property real preferredHeight: Math.max(minHeight, Math.max(thumb.implicitHeight, track.implicitHeight))

        implicitWidth: horizontal ? preferredWidth : preferredHeight
        implicitHeight: horizontal ? preferredHeight : preferredWidth

        y: horizontal ? 0 : height
        rotation: horizontal ? 0 : -90
        transformOrigin: Item.TopLeft

        Item {
            anchors.fill: parent
            DrawableLoader {
                id: track
                styleDef: panel.styleDef.ProgressBar_progressDrawable
                level: (control.value - control.minimumValue) / (control.maximumValue - control.minimumValue)
                excludes: [panel.styleDef.ProgressBar_secondaryProgress_id]
                clippables: [panel.styleDef.ProgressBar_progress_id]
                x: thumbOffset
                y: Math.round((Math.round(horizontal ? parent.height : parent.width) - track.height) / 2)
                width: (horizontal ? parent.width : parent.height) - 2 * thumbOffset
            }
            DrawableLoader {
                id: thumb
                pressed: control.pressed
                focused: control.activeFocus
                window_focused: control.Window.active
                styleDef: panel.styleDef.SeekBar_thumb
                x: Math.round((control.__handlePos - control.minimumValue) / (control.maximumValue - control.minimumValue) * ((horizontal ? panel.width : panel.height) - thumb.width))
            }
        }
    }
}
