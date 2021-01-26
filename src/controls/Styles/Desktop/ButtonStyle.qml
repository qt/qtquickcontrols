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
        id: styleitem
        elementType: "button"
        sunken: control.pressed || (control.checkable && control.checked)
        raised: !(control.pressed || (control.checkable && control.checked))
        hover: control.hovered
        text: control.iconSource === "" ? "" : control.text
        hasFocus: control.activeFocus
        hints: control.styleHints
        // If no icon, let the style do the drawing
        activeControl: control.isDefault ? "default" : "f"

        properties: {
            "icon": control.__iconAction.__icon,
            "menu": control.menu
        }
    }
}
