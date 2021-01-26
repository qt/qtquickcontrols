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

Drawable {
    id: root

    implicitWidth: Math.max(loader.implicitWidth, styleDef.width || 0)
    implicitHeight: Math.max(loader.implicitHeight, styleDef.height || 0)

    DrawableLoader {
        id: loader
        anchors.centerIn: parent
        anchors.alignWhenCentered: true
        styleDef: root.styleDef.drawable
        focused: root.focused
        pressed: root.pressed
        checked: root.checked
        selected: root.selected
        accelerated: root.accelerated
        window_focused: root.window_focused
        index: root.index
        level: root.level
        levelId: root.levelId
        orientations: root.orientations
        duration: root.duration
        excludes: root.excludes
        clippables: root.clippables

        // TODO:
        // - real root.styleDef.pivotX, pivotXRel (bool)
        // - real root.styleDef.pivotY, pivotYRel (bool)

        RotationAnimator on rotation {
            duration: root.duration
            loops: Animation.Infinite
            from: root.styleDef.fromDegrees
            to: root.styleDef.toDegrees
            running: (from || to) && root.visible && Qt.application.active
        }
    }
}
