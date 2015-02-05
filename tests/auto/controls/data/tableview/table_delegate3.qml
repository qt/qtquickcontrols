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

TableView {
    id: table
    model: 5
    property bool _pressed: false
    property bool _clicked: false
    property bool _released: false
    property bool _doubleClicked: false
    property bool _pressAndHold: false

    headerVisible: false

    function clearTestData() {
        _pressed = false
        _released = false
        _clicked = false
        _doubleClicked = false
        _pressAndHold = false
    }

    TableViewColumn {
        id: column1
        title: 'Title'
        role: "text"
            delegate: Text {
                text: "left"
                MouseArea {
                    acceptedButtons: Qt.LeftButton
                    anchors.fill: parent
                    onPressed: table._pressed = true
                    onClicked: table._clicked = true
                    onReleased: table._released = true
                    onDoubleClicked: table._doubleClicked = true
                    onPressAndHold: table._pressAndHold = true
                }
            }
    }
}
