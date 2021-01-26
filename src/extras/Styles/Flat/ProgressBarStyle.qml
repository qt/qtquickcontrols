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
import QtQuick.Extras 1.4
import QtQuick.Extras.Private.CppUtils 1.1

Base.ProgressBarStyle {
    background: Item {
        implicitWidth: Math.round(100 * FlatStyle.scaleFactor)
        implicitHeight: Math.round(16 * FlatStyle.scaleFactor)

        FlatProgressBar {
            enabled: control.enabled
            width: Math.round(parent.width)
            height: Math.round(parent.height)
            indeterminate: control.indeterminate
            progress: (control.value - control.minimumValue) / (control.maximumValue - control.minimumValue)
        }
    }

    progress: null
}
