/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
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
