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

Base.RadioButtonStyle {
    spacing: Math.round(8 * FlatStyle.scaleFactor)

    indicator: Item {
        implicitWidth: Math.round(26 * FlatStyle.scaleFactor)
        implicitHeight: implicitWidth

        Rectangle {
            id: outer
            anchors.centerIn: parent
            width: Math.round(20 * FlatStyle.scaleFactor)
            height: width
            radius: width / 2
            color: control.enabled ? (control.pressed ? FlatStyle.lightFrameColor : FlatStyle.backgroundColor) : FlatStyle.disabledFillColor
            border.color: !control.enabled ? FlatStyle.disabledFillColor :
                (control.pressed ? FlatStyle.darkFrameColor :
                (control.activeFocus ? FlatStyle.focusedColor :
                (!Settings.hasTouchScreen && control.hovered ? FlatStyle.styleColor : FlatStyle.lightFrameColor)))
            border.width: control.activeFocus && !control.pressed ? FlatStyle.twoPixels : FlatStyle.onePixel
        }

        Rectangle {
            id: inner
            anchors.centerIn: parent
            implicitWidth: Math.round(FlatStyle.scaleFactor * 8)
            width: implicitWidth + (outer.width % 2 + implicitWidth % 2) % 2
            height: width
            radius: width / 2
            visible: control.checked
            color: !control.enabled ? FlatStyle.mediumFrameColor :
                (control.activeFocus ? FlatStyle.focusedColor :
                (control.pressed ? FlatStyle.checkedAndPressedColor : FlatStyle.styleColor))
        }
    }

    label: Text {
        text: control.text
        font.family: FlatStyle.fontFamily
        renderType: FlatStyle.__renderType
        anchors.verticalCenter: parent.verticalCenter
        opacity: enabled ? 1.0 : FlatStyle.disabledOpacity
        color: !enabled ? FlatStyle.disabledColor :
               control.activeFocus ? FlatStyle.focusedTextColor : FlatStyle.defaultTextColor
    }
}
