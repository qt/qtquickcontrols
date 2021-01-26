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
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0


Style {
    readonly property GroupBox control: __control

    property var __style: StyleItem { id: style }
    property int titleHeight: 18

    Component.onCompleted: {
        var stylename = __style.style
        if (stylename.indexOf("windows") > -1)
            titleHeight = 9
    }

    padding {
        top: Math.round(Settings.dpiScaleFactor * (control.title.length > 0 || control.checkable ? titleHeight : 0) + (style.style == "mac" ? 9 : 6))
        left: Math.round(Settings.dpiScaleFactor * 8)
        right: Math.round(Settings.dpiScaleFactor * 8)
        bottom: Math.round(Settings.dpiScaleFactor * 7 + (style.style.indexOf("windows") > -1 ? 2 : 0))
    }

    property Component panel: StyleItem {
        anchors.fill: parent
        id: styleitem
        elementType: "groupbox"
        text: control.title
        on: control.checked
        hasFocus: control.__checkbox.activeFocus
        activeControl: control.checkable ? "checkbox" : ""
        properties: { "checkable" : control.checkable , "sunken" : !control.flat}
        border {top: 32 ; bottom: 8}
        Accessible.role: Accessible.Grouping
    }
}
