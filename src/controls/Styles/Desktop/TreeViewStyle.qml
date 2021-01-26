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
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0
import "." as Desktop

Desktop.TableViewStyle {
    id: root

    __indentation: 12

    __branchDelegate: StyleItem {
        id: si
        elementType: "itembranchindicator"
        properties: {
            "hasChildren": styleData.hasChildren,
            "hasSibling": styleData.hasSibling && !styleData.isExpanded
        }
        on: styleData.isExpanded
        selected: styleData.selected
        hasFocus: __styleitem.active

        Component.onCompleted: {
            root.__indentation = si.pixelMetric("treeviewindentation")
            implicitWidth = root.__indentation
            implicitHeight = implicitWidth
            var rect = si.subControlRect("dummy");
            width = rect.width
            height = rect.height
        }
    }
}
