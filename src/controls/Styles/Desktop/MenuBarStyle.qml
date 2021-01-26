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
import "." as Desktop

Style {
    id: styleRoot

    property Component background: StyleItem {
        elementType: "menubar"

        Component.onCompleted: {
            styleRoot.padding.left = pixelMetric("menubarhmargin") + pixelMetric("menubarpanelwidth")
            styleRoot.padding.right = pixelMetric("menubarhmargin") + pixelMetric("menubarpanelwidth")
            styleRoot.padding.top = pixelMetric("menubarvmargin") + pixelMetric("menubarpanelwidth")
            styleRoot.padding.bottom = pixelMetric("menubarvmargin") + pixelMetric("menubarpanelwidth")
        }
    }

    property Component itemDelegate: StyleItem {
        elementType: "menubaritem"

        text: styleData.text
        property string plainText: StyleHelpers.removeMnemonics(text)
        contentWidth: textWidth(plainText)
        contentHeight: textHeight(plainText)
        width: implicitWidth

        enabled: styleData.enabled
        sunken: styleData.open
        selected: (parent && styleData.selected) || sunken

        hints: { "showUnderlined": styleData.underlineMnemonic }
    }

    property Component menuStyle: Desktop.MenuStyle { }
}
