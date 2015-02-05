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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

GridLayout {
    columns: 4
    property int index: -1
    rowSpacing: 5
    columnSpacing: 5
    Label {
        Layout.rowSpan: 2
        text: "Stack Index: " + index
    }
    Button {
        text: "Push New Component"
        onClicked: stackView.push(componentPage)
    }
    Button {
        text: "Push New URL"
        onClicked: stackView.push(Qt.resolvedUrl("View.qml"))
    }
    Button {
        text: "Back"
        enabled: index !== 0
        onClicked: stackView.pop()
    }

    RowLayout {
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        Layout.columnSpan: 3
        spacing: 5
        Label { text: "Jump to index:" }
        ComboBox {
            model: stackView.depth
            currentIndex: stackView.currentItem.Stack.index
            enabled: stackView.depth > 1
            onCurrentIndexChanged: {
                if (stackView.currentItem !== null &&
                        currentIndex !== stackView.currentItem.Stack.index)
                    stackView.pop(stackView.get(currentIndex, true))
            }
        }
    }
}
