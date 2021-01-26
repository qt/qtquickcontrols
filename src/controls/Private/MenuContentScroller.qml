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

MouseArea {
    id: scrollIndicator
    property int direction: 0

    anchors {
        top: direction === Qt.UpArrow ? parent.top : undefined
        bottom: direction === Qt.DownArrow ? parent.bottom : undefined
    }

    hoverEnabled: visible && Settings.hoverEnabled
    height: scrollerLoader.height
    width: parent.width

    Loader {
        id: scrollerLoader

        width: parent.width
        sourceComponent: scrollIndicatorStyle
        // Extra property values for desktop style
        property var __menuItem: null
        property var styleData: {
            "index": -1,
            "type": MenuItemType.ScrollIndicator,
            "text": "",
            "selected": scrollIndicator.containsMouse,
            "scrollerDirection": scrollIndicator.direction,
            "checkable": false,
            "checked": false,
            "enabled": true
        }
    }

    Timer {
        interval: 100
        repeat: true
        triggeredOnStart: true
        running: parent.containsMouse
        onTriggered: scrollABit()
    }
}
