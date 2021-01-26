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

    implicitWidth: Math.max(repeater.implicitWidth, styleDef.width || 0)
    implicitHeight: Math.max(repeater.implicitHeight, styleDef.height || 0)

    Repeater {
        id: repeater
        anchors.fill: parent
        model: index >= 0 ? [styleDef.layers[index]] : styleDef.layers
        DrawableLoader {
            id: loader
            anchors.fill: parent
            styleDef: modelData
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
            // TODO: find a cleaner way to promote the implicit size of the largest layer
            onImplicitWidthChanged: repeater.implicitWidth = Math.max(implicitWidth, repeater.implicitWidth)
            onImplicitHeightChanged: repeater.implicitHeight = Math.max(implicitHeight, repeater.implicitHeight)
        }
    }
}
