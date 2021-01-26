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
import QtQuick.Controls 1.3
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.3 as Base

ScrollViewStyle {
    id: root

    Base.TableViewStyle {
        id: baseStyle
    }

    readonly property TableView control: __control
    property alias textColor: baseStyle.textColor
    property alias backgroundColor: baseStyle.backgroundColor
    property alias alternateBackgroundColor: baseStyle.alternateBackgroundColor
    property alias highlightedTextColor: baseStyle.highlightedTextColor
    property alias activateItemOnSingleClick: baseStyle.activateItemOnSingleClick
    property alias headerDelegate: baseStyle.headerDelegate
    property alias rowDelegate: baseStyle.rowDelegate
    property alias itemDelegate: baseStyle.itemDelegate
    padding.top: baseStyle.padding.top
}
