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
import QtQuick.Controls.Styles.Android 1.0

ColorDrawable {
    id: root

    Component {
        id: component
        GradientStop { }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            id: gradient
            function reload() {
                var stops = []
                if (styleDef && styleDef.colors) {
                    for (var i = 0; i < styleDef.colors.length; ++i) {
                        var stop = component.createObject(root)
                        stop.color = AndroidStyle.colorValue(styleDef.colors[i])
                        if (styleDef.positions[i] !== undefined)
                            stop.position = styleDef.positions[i]
                        else // spread evenly if positions are not defined
                            stop.position = i / (styleDef.colors.length - 1)
                        stops.push(stop)
                    }
                }
                gradient.stops = stops
            }
        }
    }

    onStyleDefChanged: gradient.reload()
    Component.onCompleted: gradient.reload()
}
