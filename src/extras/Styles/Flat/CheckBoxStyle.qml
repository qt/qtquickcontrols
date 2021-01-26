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

Base.CheckBoxStyle {
    spacing: Math.round(8 * FlatStyle.scaleFactor)

    indicator: CheckBoxDrawer {
        controlEnabled: control.enabled
        controlActiveFocus: control.activeFocus
        controlPressed: control.pressed
        controlHovered: !Settings.hasTouchScreen && control.hovered
        controlChecked: control.checked
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
