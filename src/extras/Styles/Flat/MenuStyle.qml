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
import QtQuick.Controls.Styles 1.2 as Base
import QtQuick.Controls.Styles.Flat 1.0

Base.MenuStyle {
    id: style
    font.family: FlatStyle.fontFamily
    __leftLabelMargin: Math.round(30 * FlatStyle.scaleFactor)

    frame: Rectangle {
        border.color: FlatStyle.darkFrameColor
        border.width: FlatStyle.onePixel
    }

    itemDelegate.background: Rectangle {
        color: !!styleData.pressed || styleData.selected ? FlatStyle.disabledColor : "transparent"
        opacity: !!styleData.pressed || styleData.selected ? 0.15 : 1.0
    }

    itemDelegate.label: Text {
        text: formatMnemonic(styleData.text, styleData.underlineMnemonic)
        renderType: FlatStyle.__renderType
        color: FlatStyle.defaultTextColor
        font.family: FlatStyle.fontFamily
        font.pixelSize: FlatStyle.defaultFontSize
        verticalAlignment: Text.AlignVCenter
        height: Math.round(26 * FlatStyle.scaleFactor)
    }

    itemDelegate.shortcut: Text {
        text: styleData.shortcut
        renderType: FlatStyle.__renderType
        color: FlatStyle.defaultTextColor
        font.family: FlatStyle.fontFamily
        font.pixelSize: FlatStyle.defaultFontSize
    }

    itemDelegate.checkmarkIndicator: CheckBoxDrawer {
        visible: styleData.checked
        controlEnabled: styleData.enabled
        controlChecked: styleData.checked
        backgroundVisible: false
        x: -4 // ### FIXME: compensate hardcoded "x: 4" in MenuStyle
        y: FlatStyle.onePixel
    }

    itemDelegate.submenuIndicator: LeftArrowIcon {
        scale: -1
        color: "#000000"
        width: Math.round(10 * FlatStyle.scaleFactor)
        height: Math.round(10 * FlatStyle.scaleFactor)
        baselineOffset: Math.round(7 * FlatStyle.scaleFactor)
    }

    separator: Rectangle {
        color: FlatStyle.lightFrameColor
        width: parent.width
        implicitHeight: FlatStyle.onePixel
    }
}
