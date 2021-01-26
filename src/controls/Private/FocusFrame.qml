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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype FocusFrame
    \internal
    \inqmlmodule QtQuick.Controls.Private
*/
Item {
    id: root
    activeFocusOnTab: false
    Accessible.role: Accessible.StatusBar

    anchors.topMargin: focusMargin
    anchors.leftMargin: focusMargin
    anchors.rightMargin: focusMargin
    anchors.bottomMargin: focusMargin

    property int focusMargin: loader.item ? loader.item.margin : -3

    Loader {
        id: loader
        z: 2
        anchors.fill: parent
        sourceComponent: Settings.styleComponent(Settings.style, "FocusFrameStyle.qml", root)
    }
}
