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
    property Component panel: StyleItem {
        anchors.fill: parent
        elementType: "progressbar"
        // XXX: since desktop uses int instead of real, the progressbar
        // range [0..1] must be stretched to a good precision
        property int factor : 1000
        property int decimals: 3
        value:   indeterminate ? 0 : control.value.toFixed(decimals) * factor // does indeterminate value need to be 1 on windows?
        minimum: indeterminate ? 0 : control.minimumValue.toFixed(decimals) * factor
        maximum: indeterminate ? 0 : control.maximumValue.toFixed(decimals) * factor
        enabled: control.enabled
        horizontal: control.orientation === Qt.Horizontal
        hints: control.styleHints
        contentWidth: horizontal ? 200 : 23
        contentHeight: horizontal ? 23 : 200
    }
}
