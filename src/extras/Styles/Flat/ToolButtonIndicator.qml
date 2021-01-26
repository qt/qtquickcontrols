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
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles.Flat 1.0

// Internal, for use with ToolButtonStyle and ToolBarStyle
Item {
    id: toolButtonIndicator
    implicitWidth: Math.round(26 * FlatStyle.scaleFactor)
    implicitHeight: Math.round(26 * FlatStyle.scaleFactor)

    property bool buttonEnabled: false
    property bool buttonHasActiveFocus: false
    property bool buttonPressedOrChecked: false

    Column {
        anchors.centerIn: parent
        spacing: Math.round(2 * FlatStyle.scaleFactor)

        Repeater {
            model: toolButtonIndicator.visible ? 3 : 0

            Rectangle {
                width: Math.round(4 * FlatStyle.scaleFactor)
                height: width
                radius: width / 2
                color: !buttonEnabled ? FlatStyle.disabledColor : buttonPressedOrChecked && buttonHasActiveFocus
                    ? FlatStyle.selectedTextColor : buttonHasActiveFocus
                    ? FlatStyle.focusedColor : FlatStyle.defaultTextColor
                opacity: !buttonEnabled ? FlatStyle.disabledOpacity : 1
            }
        }
    }
}
