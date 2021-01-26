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
import QtQuick.Controls.Styles 1.2 as Base

Base.BusyIndicatorStyle {
    indicator: Item {
        id: indicator

        function resolveSize() {
            // Small: 26, Medium: 52, Large: 104
            var sizeHint = control.styleHints ? control.styleHints['size'] : undefined
            if (sizeHint === "small" || !sizeHint && control.width > 0 && control.width < 52)
                return "Small"
            if (sizeHint === "large" || !sizeHint && control.width >= 104)
                return "Large"
            return "Medium"
        }

        anchors.centerIn: parent
        implicitWidth: image.sourceSize.width
        implicitHeight: image.sourceSize.height

        opacity: control.running ? 1 : 0
        Behavior on opacity { OpacityAnimator { duration: 250 } }

        Image {
            id: image
            anchors.centerIn: parent
            anchors.alignWhenCentered: true
            source: "images/BusyIndicator_Normal-" + indicator.resolveSize() + ".png"

            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
                running: indicator.visible && (control.running || indicator.opacity > 0)
            }
        }
    }
}
