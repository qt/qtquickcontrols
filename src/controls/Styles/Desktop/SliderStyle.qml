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
    readonly property Item control: __control
    property Component panel: StyleItem {
        elementType: "slider"
        sunken: control.pressed
        implicitWidth: 200
        contentHeight: horizontal ? 22 : 200
        contentWidth: horizontal ? 200 : 22

        maximum: control.maximumValue*100
        minimum: control.minimumValue*100
        step: control.stepSize*100
        value: control.__handlePos*100
        horizontal: control.orientation === Qt.Horizontal
        enabled: control.enabled
        hasFocus: control.activeFocus
        hover: control.hovered
        hints: control.styleHints
        activeControl: control.tickmarksEnabled ? "ticks" : ""
        property int handleWidth: 15
        property int handleHeight: 15
    }
    padding { top: 0 ; left: 0 ; right: 0 ; bottom: 0 }
}
