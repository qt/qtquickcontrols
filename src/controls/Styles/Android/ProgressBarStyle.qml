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
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles.Android 1.0
import "drawables"

Style {
    readonly property ProgressBar control: __control

    property Component panel: Item {
        id: panel

        readonly property bool horizontal: control.orientation === Qt.Horizontal
        readonly property var styleDef: AndroidStyle.styleDef.progressBarStyleHorizontal

        readonly property real minWidth: styleDef.ProgressBar_minWidth || 0
        readonly property real minHeight: styleDef.ProgressBar_minHeight || 0
        readonly property real maxWidth: styleDef.ProgressBar_maxWidth || minWidth
        readonly property real maxHeight: styleDef.ProgressBar_maxHeight || minHeight

        readonly property real preferredWidth: Math.min(maxWidth, Math.max(minWidth, bg.implicitWidth))
        readonly property real preferredHeight: Math.min(maxHeight, Math.max(minHeight, bg.implicitHeight))

        implicitWidth: horizontal ? preferredWidth : preferredHeight
        implicitHeight: horizontal ? preferredHeight : preferredWidth

        DrawableLoader {
            id: bg
            width: horizontal ? parent.width : parent.height
            height: !horizontal ? parent.width : parent.height
            y: horizontal ? 0 : width
            rotation: horizontal ? 0 : -90
            transformOrigin: Item.TopLeft
            styleDef: control.indeterminate ? panel.styleDef.ProgressBar_indeterminateDrawable
                                            : panel.styleDef.ProgressBar_progressDrawable
            level: (control.value - control.minimumValue) / (control.maximumValue - control.minimumValue)
            levelId: panel.styleDef.ProgressBar_progress_id
            excludes: [panel.styleDef.ProgressBar_secondaryProgress_id]
        }
    }
}
