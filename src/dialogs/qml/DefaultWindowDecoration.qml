/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Dialogs module of the Qt Toolkit.
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

Rectangle {
    color: "#80000000"
    anchors.fill: parent
    z: 1000000
    property alias content: borderImage.content
    property bool dismissOnOuterClick: true
    signal dismissed
    MouseArea {
        anchors.fill: parent
        onClicked: if (dismissOnOuterClick) dismissed()
        BorderImage {
            id: borderImage
            property Item content

            MouseArea { anchors.fill: parent }

            width: content ? content.width + 15 : 0
            height: content ? content.height + 15 : 0
            onWidthChanged: if (content) content.x = 5
            onHeightChanged: if (content) content.y = 5
            border { left: 10; top: 10; right: 10; bottom: 10 }
            clip: true
            source: "../images/window_border.png"
            anchors.centerIn: parent
            onContentChanged: if (content) content.parent = borderImage
        }
    }
}
