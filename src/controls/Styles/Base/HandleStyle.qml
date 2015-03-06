/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
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
import QtQuick.Controls.Private 1.0
import QtQuick.Extras 1.4

Style {
    id: handleStyle
    property alias handleColorTop: __helper.handleColorTop
    property alias handleColorBottom: __helper.handleColorBottom
    property alias handleColorBottomStop: __helper.handleColorBottomStop

    HandleStyleHelper {
        id: __helper
    }

    property Component handle: Item {
        implicitWidth: 50
        implicitHeight: 50

        Canvas {
            id: handleCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                __helper.paintHandle(ctx);
            }
        }
    }

    property Component panel: Item {
        Loader {
            id: handleLoader
            sourceComponent: handle
            anchors.fill: parent
        }
    }
}
