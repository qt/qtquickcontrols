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
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Private 1.0

ScrollViewStyle {
    corner: null
    incrementControl: null
    decrementControl: null
    frame: null
    scrollBarBackground: null
    padding { top: 0; left: 0; right: 0; bottom: 0 }

    __scrollBarFadeDelay: 50
    __scrollBarFadeDuration: 200
    __stickyScrollbars: true

    handle: Item {
        implicitWidth: 2.5
        implicitHeight: 2.5

        anchors.top: !styleData.horizontal ? parent.top : undefined
        anchors.left: styleData.horizontal ? parent.left : undefined
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        anchors.leftMargin: implicitWidth
        anchors.topMargin: implicitHeight + 1
        anchors.rightMargin: implicitWidth * (!styleData.horizontal ? 2 : 4)
        anchors.bottomMargin: implicitHeight * (styleData.horizontal ? 2 : 4)

        Behavior on width { enabled: !styleData.horizontal; NumberAnimation { duration: 100 } }
        Behavior on height { enabled: styleData.horizontal; NumberAnimation { duration: 100 } }

        Loader {
            anchors.fill: parent
            sourceComponent: styleData.horizontal ? horzontalHandle : verticalHandle
        }

        Component {
            id: verticalHandle
            Rectangle {
                color: "black"
                opacity: 0.3
                radius: parent.parent.implicitWidth
                width: parent.width
                y: overshootBottom > 0 ? parent.height - height : 0
                height: Math.max(8, parent.height - overshootTop - overshootBottom)

                property real overshootTop: -Math.min(0, __control.flickableItem.contentY)
                property real overshootBottom: Math.max(0, __control.flickableItem.contentY
                                                        - __control.flickableItem.contentHeight
                                                        + __control.flickableItem.height)
            }
        }

        Component {
            id: horzontalHandle
            Rectangle {
                color: "black"
                opacity: 0.3
                radius: parent.parent.implicitHeight
                height: parent.height
                x: overshootRight > 0 ? parent.width - width : 0
                width: Math.max(8, parent.width - overshootLeft - overshootRight)

                property real overshootLeft: -Math.min(0, __control.flickableItem.contentX)
                property real overshootRight: Math.max(0, __control.flickableItem.contentX
                                                       - __control.flickableItem.contentWidth
                                                       + __control.flickableItem.width)
            }
        }
    }
}
