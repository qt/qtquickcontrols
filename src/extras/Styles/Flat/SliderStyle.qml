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
import QtQuick.Controls.Private 1.0
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

Base.SliderStyle {
    handle: Item {
        width: Math.round(26 * FlatStyle.scaleFactor)
        height: width

        readonly property bool focusedOnly: control.activeFocus && !control.pressed

        Rectangle {
            id: handleBorder
            width: parent.width
            height: width
            radius: width / 2
            color: focusedOnly ? FlatStyle.focusedColor :
                   control.hovered && !control.pressed ? FlatStyle.styleColor : "#000000"
            opacity: (control.activeFocus || control.hovered) && !control.pressed ? 1.0 : 0.2
        }

        Rectangle {
            id: handleBody
            readonly property real borderThickness: focusedOnly ? FlatStyle.twoPixels : FlatStyle.onePixel
            x: borderThickness
            y: borderThickness
            width: parent.width - 2 * borderThickness
            height: width
            border.color: "white"
            border.width: (width - parent.width * 10 / 26) / 2
            radius: width / 2
            color: !control.enabled ? FlatStyle.disabledFillColor :
                   focusedOnly ? FlatStyle.focusedColor : FlatStyle.styleColor
        }

        Rectangle {
            id: pressedDarkness
            anchors.fill: parent
            radius: width / 2
            color: "#000000"
            opacity: 0.2
            visible: control.pressed
        }
    }

    groove: Item {
        implicitWidth: Math.round(100 * FlatStyle.scaleFactor)
        height: Math.round(4 * FlatStyle.scaleFactor)
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: emptyGroove
            width: parent.width
            height: parent.height
            radius: Math.round(2 * FlatStyle.scaleFactor)
            color: "#000000"
            opacity: control.enabled ? 0.2 : 0.12
        }

        Rectangle {
            id: filledGroove
            color: control.enabled ? FlatStyle.styleColor : FlatStyle.mediumFrameColor
            width: styleData.handlePosition
            height: parent.height
            radius: emptyGroove.radius
        }
    }

    // TODO: tickmarks
}
