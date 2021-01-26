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

import QtQuick 2.3
import QtQuick.Controls.Styles 1.3

SliderStyle {
    groove: Rectangle {
        implicitWidth: 20
        implicitHeight: 2

        color: "#a8a8a8"
        radius: 45.0

        Rectangle {
            width: styleData.handlePosition
            height: parent.height
            color: "#0a60ff"
            radius: parent.radius
        }
    }

    handle: Item {
        width: 29
        height: 32

        Rectangle {
            y: 3
            width: 29
            height: 29
            radius: 90.0

            color: "#d6d6d6"
            opacity: 0.2
        }

        Rectangle {
            width: 29
            height: 29
            radius: 90.0

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#e2e2e2" }
                GradientStop { position: 1.0; color: "#d6d6d6" }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                radius: parent.radius
            }
        }
    }
}
