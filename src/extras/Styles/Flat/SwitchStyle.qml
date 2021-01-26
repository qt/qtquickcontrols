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
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2 as Base
import QtQuick.Controls.Styles.Flat 1.0

Base.SwitchStyle {
    readonly property int __knobHeight: Math.round(26 * FlatStyle.scaleFactor)

    groove: Item {
        implicitWidth: Math.round(46 * FlatStyle.scaleFactor)
        implicitHeight: __knobHeight
        Rectangle {
            radius: height / 2
            y: 1 * FlatStyle.scaleFactor
            implicitWidth: parent.implicitWidth
            implicitHeight: Math.round(24 * FlatStyle.scaleFactor)
            border.width: (control.activeFocus ? FlatStyle.twoPixels : FlatStyle.onePixel)
            border.color: control.activeFocus ? FlatStyle.highlightColor : control.enabled && control.checked ? FlatStyle.styleColor : FlatStyle.mediumFrameColor
            color: !control.checked ? "transparent" :
                   !control.enabled ? FlatStyle.disabledFillColor :
                   control.activeFocus ? FlatStyle.highlightColor : FlatStyle.styleColor
        }
    }

    handle: Item {
        implicitWidth: __knobHeight
        implicitHeight: __knobHeight
        Rectangle {
            id: knobShadow
            x: 1 * FlatStyle.scaleFactor
            y: 1 * FlatStyle.scaleFactor
            radius: height / 2
            width: parent.width
            height: parent.height
            color: "#000000"
            opacity: 0.1
        }
        Rectangle {
            id: knob
            radius: height / 2
            width: parent.width
            height: parent.height
            border.width: (control.activeFocus ? FlatStyle.twoPixels : FlatStyle.onePixel)
            border.color: !control.enabled ? FlatStyle.mediumFrameColor :
                          control.pressed && control.activeFocus ? FlatStyle.focusedAndPressedStrokeColor :
                          control.activeFocus ? FlatStyle.focusedStrokeColor :
                          control.checked ? FlatStyle.strokeColor : FlatStyle.darkFrameColor
            color: !control.enabled ? FlatStyle.disabledFillColor : control.pressed ? FlatStyle.lightFrameColor : FlatStyle.backgroundColor
        }
    }
}
