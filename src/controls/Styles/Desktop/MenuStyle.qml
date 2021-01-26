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

import QtQml 2.14 as Qml
import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0

Style {
    id: styleRoot

    property string __menuItemType: "menuitem"

    property int submenuOverlap: 0
    property int submenuPopupDelay: 0
    property int __maxPopupHeight: 0

    property Component frame: StyleItem {
        elementType: "menu"

        Rectangle {
            visible: anchors.margins > 0
            anchors {
                fill: parent
                margins: pixelMetric("menupanelwidth")
            }
            color: SystemPaletteSingleton.window(control.enabled)
        }

        Component.onCompleted: {
            var menuHMargin = pixelMetric("menuhmargin")
            var menuVMargin = pixelMetric("menuvmargin")
            var menuPanelWidth = pixelMetric("menupanelwidth")
            styleRoot.padding.left = menuHMargin + menuPanelWidth
            styleRoot.padding.right = menuHMargin + menuPanelWidth
            styleRoot.padding.top = menuVMargin + menuPanelWidth
            styleRoot.padding.bottom = menuVMargin + menuPanelWidth
            styleRoot.submenuOverlap = 2 * menuPanelWidth
            styleRoot.submenuPopupDelay = styleHint("submenupopupdelay")
        }

        // ### The Screen attached property can only be set on an Item,
        // ### and will get its values only when put on a Window.
        readonly property int desktopAvailableHeight: Screen.desktopAvailableHeight
        Qml.Binding {
            target: styleRoot
            property: "__maxPopupHeight"
            value: desktopAvailableHeight * 0.99
            restoreMode: Binding.RestoreBinding
        }
    }

    property Component menuItemPanel: StyleItem {
        elementType: __menuItemType

        text: styleData.text
        property string textAndShorcut: text + (styleData.shortcut ? "\t" + styleData.shortcut : "")
        contentWidth: textWidth(textAndShorcut)
        contentHeight: textHeight(textAndShorcut)

        enabled: styleData.enabled
        selected: styleData.selected
        on: styleData.checkable && styleData.checked

        hints: { "showUnderlined": styleData.underlineMnemonic }

        properties: {
            "checkable": styleData.checkable,
            "exclusive": styleData.exclusive,
            "shortcut": styleData.shortcut,
            "type": styleData.type,
            "scrollerDirection": styleData.scrollerDirection,
            "icon": !!__menuItem && __menuItem.__icon
        }
    }

    property Component scrollIndicator: menuItemPanel

    property Component __scrollerStyle: null
}
