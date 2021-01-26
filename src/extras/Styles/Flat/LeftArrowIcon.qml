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

import QtQuick 2.3

Canvas {
    implicitWidth: 32
    implicitHeight: 32

    property color color: "white"

    onColorChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.reset();

        ctx.beginPath();
        ctx.moveTo(0.66321495 * width, 0.06548707 * height);
        ctx.lineTo(0.2191097 * width, 0.50959232 * height);
        ctx.lineTo(0.66628301 * width, 0.95676556 * height);
        ctx.lineTo(0.77673409 * width, 0.84631453 * height);
        ctx.lineTo(0.44001181 * width, 0.50959232 * height);
        ctx.lineTo(0.77366599 * width, 0.1759381 * height);
        ctx.fillStyle = color;
        ctx.fill();
    }
}
