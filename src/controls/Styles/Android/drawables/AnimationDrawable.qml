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

    property int currentFrame: 0
    readonly property int frameCount: styleDef.frames ? styleDef.frames.length : 0
    readonly property var frameDef: styleDef.frames ? styleDef.frames[currentFrame] : undefined
    readonly property alias running: timer.running
    property bool oneshot: styleDef.oneshot

    Timer {
        id: timer
        repeat: true
        running: root.frameCount && root.visible && Qt.application.active
        interval: root.frameDef ? root.frameDef.duration : 0
        onTriggered: {
            var frame = root.currentFrame + 1
            repeat = !root.oneshot || frame < root.frameCount - 1
            root.currentFrame = frame % root.frameCount
        }
    }

    DrawableLoader {
        id: loader
        anchors.fill: parent
        styleDef: root.frameDef ? root.frameDef.drawable : undefined
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
    }
}
