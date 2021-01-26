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

Base.ToolBarStyle {
    padding {
        top: 0
        left: Math.round(FlatStyle.scaleFactor * 10)
        right: Math.round(FlatStyle.scaleFactor * 10)
        bottom: 0
    }

    menuButton: Item {
        implicitWidth: Math.round(FlatStyle.scaleFactor * 26)
        implicitHeight: Math.round(FlatStyle.scaleFactor * 26)

        ToolButtonBackground {
            anchors.fill: parent
            buttonEnabled: control.enabled
            buttonHasActiveFocus: control.activeFocus
            buttonPressed: styleData.pressed
            buttonChecked: false
            buttonHovered: !Settings.hasTouchScreen && styleData.hovered
        }

        ToolButtonIndicator {
            buttonEnabled: control.enabled
            buttonHasActiveFocus: styleData.activeFocus
            buttonPressedOrChecked: styleData.pressed
            anchors.centerIn: parent
        }
    }

    background: Rectangle {
        implicitHeight: Math.max(1, Math.round(FlatStyle.scaleFactor * 40))
        color: FlatStyle.flatFrameColor
    }
}
