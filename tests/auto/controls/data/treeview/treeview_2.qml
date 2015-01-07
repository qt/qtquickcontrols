/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuickControlsTests 1.0

TreeView {
    width: 500
    height: 500
    property var treeModel: TreeModel {}

    model: treeModel

    property int collapsedCount: 0
    property int expandedCount: 0
    property var signalArgIndex

    TableViewColumn {
        role: "display"
        title: "Default"
        width: 200
    }
    rowDelegate: Rectangle {
        color: styleData.selected? "blue" : styleData.alternate ? "red" : "yellow"
        height: 50
        width: parent.width
    }
    headerDelegate: Text {
        text: styleData.value
        height: 50
        width: parent.width
    }
    itemDelegate: Text {
        text: styleData.value
        height: 50
        width: parent.width
    }

    onCollapsed: {
        signalArgIndex = index
        collapsedCount++
    }
    onExpanded: {
        signalArgIndex = index
        expandedCount++
    }
}
