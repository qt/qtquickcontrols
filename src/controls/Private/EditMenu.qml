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

Loader {
    property Item control
    property Item input
    property Item cursorHandle
    property Item selectionHandle
    property Flickable flickable
    property Component defaultMenu: item && item.defaultMenu ? item.defaultMenu : null
    property QtObject menuInstance: null
    property MouseArea mouseArea
    property QtObject style: __style

    Connections {
        target: control
        function onMenuChanged() {
            if (menuInstance !== null) {
                menuInstance.destroy()
                menuInstance = null
            }
        }
    }

    function getMenuInstance()
    {
        // Lazy load menu when first requested
        if (!menuInstance && control.menu) {
            menuInstance = control.menu.createObject(input);
        }
        return menuInstance;
    }

    function syncStyle() {
        if (!style)
            return;

        if (style.__editMenu)
            sourceComponent = style.__editMenu;
        else {
            // todo: get ios/android/base menus from style as well
            source = (Qt.resolvedUrl(Qt.platform.os === "ios" ? ""
                : Qt.platform.os === "android" ? "" : "EditMenu_base.qml"));
        }
    }
    onStyleChanged: syncStyle();
    Component.onCompleted: syncStyle();
}
