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

Item {
    id: selectionDelegate
    x: -width + 10
    y: -20
    width: 80
    height: knob.height + knobLine.height + 60

    Rectangle {
        id: knob
        x: knobLine.x + (knobLine.width / 2) - (width / 2)
        y: knobLine.y - height + 1
        width: 10
        height: width
        radius: width / 2
        visible: knobLine.visible
        color: knobLine.color
    }
    Rectangle {
        id: knobLine
        x: -parent.x - width
        y: -parent.y - 1
        width: 2
        height: styleData.lineHeight + 1
        color: "#ff146fe1"
    }
}
