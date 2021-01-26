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
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0

Loader {
    id: loader

    property var styleDef

    property bool focused
    property bool pressed
    property bool checked
    property bool selected
    property bool accelerated
    property bool window_focused

    property int index: 0
    property real level: 0
    property string levelId: ""
    property int orientations: Qt.Horizontal
    property int duration: 0

    property var excludes: []
    property var clippables: []

    property Padding padding: Padding {
        top: loader.item ? loader.item.padding.top : 0
        left: loader.item ? loader.item.padding.left : 0
        right: loader.item ? loader.item.padding.right : 0
        bottom: loader.item ? loader.item.padding.bottom : 0
    }

    readonly property string type: styleDef ? styleDef.type : ""

    readonly property bool isExcluded: !!styleDef && excludes.indexOf(styleDef.id) !== -1
    readonly property bool isClippable: !!styleDef && clippables.indexOf(styleDef.id) !== -1

    active: !!styleDef && !isExcluded
    sourceComponent: type === "animation" ? Qt.createComponent("AnimationDrawable.qml") :
      isClippable || type === "clipDrawable" ? Qt.createComponent("ClipDrawable.qml") :
                     type === "color" ? Qt.createComponent("ColorDrawable.qml") :
                     type === "gradient" ? Qt.createComponent("GradientDrawable.qml") :
                     type === "image" ? Qt.createComponent("ImageDrawable.qml") :
                     type === "layer" ? Qt.createComponent("LayerDrawable.qml") :
                     type === "9patch" ? Qt.createComponent("NinePatchDrawable.qml") :
                     type === "rotate" ? Qt.createComponent("RotateDrawable.qml") :
                     type === "stateslist" ? Qt.createComponent("StateDrawable.qml") : null

    Qml.Binding {
        target: loader.item
        property: "styleDef"
        value: loader.styleDef
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "focused"
        value: loader.focused
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "pressed"
        value: loader.pressed
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "checked"
        value: loader.checked
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "selected"
        value: loader.selected
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "accelerated"
        value: loader.accelerated
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "window_focused"
        value: loader.window_focused
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "level"
        value: loader.level
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "levelId"
        value: loader.levelId
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "orientations"
        value: loader.orientations
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "duration"
        value: loader.duration
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "excludes"
        value: loader.excludes
        restoreMode: Binding.RestoreBinding
    }
    Qml.Binding {
        target: loader.item
        property: "clippables"
        value: loader.clippables
        restoreMode: Binding.RestoreBinding
    }
}
