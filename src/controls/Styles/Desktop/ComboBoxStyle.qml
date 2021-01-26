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
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Private 1.0
import "." as Desktop

Style {
    readonly property ComboBox control: __control
    property int renderType: Text.NativeRendering
    padding { top: 4 ; left: 6 ; right: 6 ; bottom:4 }
    property Component panel: Item {
        property bool popup: !!styleItem.styleHint("comboboxpopup")
        property color textColor: SystemPaletteSingleton.text(control.enabled)
        property color selectionColor: SystemPaletteSingleton.highlight(control.enabled)
        property color selectedTextColor: SystemPaletteSingleton.highlightedText(control.enabled)
        property int dropDownButtonWidth: 24

        implicitWidth: 125
        implicitHeight: styleItem.implicitHeight
        baselineOffset: styleItem.baselineOffset
        anchors.fill: parent
        StyleItem {
            id: styleItem

            height: parent.height
            width: parent.width
            elementType: "combobox"
            sunken: control.pressed
            raised: !sunken
            hover: control.hovered
            enabled: control.enabled
            // The style makes sure the text rendering won't overlap the decoration.
            // In that case, 35 pixels margin in this case looks good enough. Worst
            // case, the ellipsis will be truncated (2nd worst, not visible at all).
            text: elidedText(control.currentText, Text.ElideRight, parent.width - 35)
            hasFocus: control.activeFocus
            // contentHeight as in QComboBox
            contentHeight: Math.max(Math.ceil(textHeight("")), 14) + 2

            hints: control.styleHints
            properties: {
                "popup": control.__popup,
                "editable" : control.editable
            }
        }
    }

    property Component __popupStyle: MenuStyle {
        __menuItemType: "comboboxitem"
    }

    property Component __dropDownStyle: Style {
        id: dropDownStyleRoot
        property int __maxPopupHeight: 600
        property int submenuOverlap: 0
        property int submenuPopupDelay: 0

        property Component frame: StyleItem {
            elementType: "frame"
            Component.onCompleted: {
                var defaultFrameWidth = pixelMetric("defaultframewidth")
                dropDownStyleRoot.padding.left = defaultFrameWidth
                dropDownStyleRoot.padding.right = defaultFrameWidth
                dropDownStyleRoot.padding.top = defaultFrameWidth
                dropDownStyleRoot.padding.bottom = defaultFrameWidth
            }
        }

        property Component menuItemPanel: StyleItem {
            elementType: "itemrow"
            selected: styleData.selected

            implicitWidth: textItem.implicitWidth
            implicitHeight: textItem.implicitHeight

            StyleItem {
                id: textItem
                elementType: "item"
                contentWidth: textWidth(text)
                contentHeight: textHeight(text)
                text: styleData.text
                selected: parent ? parent.selected : false
            }
        }

        property Component __scrollerStyle: Desktop.ScrollViewStyle { }
    }
}
