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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Private 1.0

BasicTableViewStyle {
    id: root

    readonly property TreeView control: __control

    property int indentation: 16

    property Component branchDelegate: Item {
        width: indentation
        height: 16
        Text {
            visible: styleData.column === 0 && styleData.hasChildren
            text: styleData.isExpanded ? "\u25bc" : "\u25b6"
            color: !control.activeFocus || styleData.selected ? styleData.textColor : "#666"
            font.pointSize: 10
            renderType: Text.NativeRendering
            style: Text.PlainText
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 2
        }
    }

    __branchDelegate: branchDelegate
    __indentation: indentation
}
