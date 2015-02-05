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

Column {
    width: 200
    height: 200
    property alias control1: _control1
    property alias control2: _control2
    GroupBox  {
        id: _control1
        title: "control1"
        checkable: true
        Column {
            objectName: "column1"
            property alias child1: _child1
            property alias child2: _child2
            anchors.fill: parent
            Button {
                id: _child1
                text: "child1"
            }
            Button {
                id: _child2
                text: "child2"
            }
        }
    }
    GroupBox  {
        id: _control2
        title: "control2"
        Column {
            objectName: "column2"
            property alias child3: _child3
            property alias child4: _child4
            anchors.fill: parent
            Button {
                id: _child3
                text: "child3"
            }
            Button {
                id: _child4
                text: "child4"
            }
        }
    }
}
