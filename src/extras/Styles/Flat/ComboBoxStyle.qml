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
import QtQuick.Controls.Styles 1.2 as Base
import QtQuick.Controls.Styles.Flat 1.0
import QtQuick.Extras.Private 1.0

Base.ComboBoxStyle {
    id: style

    padding {
        top: 0
        left: Math.round(FlatStyle.scaleFactor * (control.editable ? 10 : 6))
        right: 0
        bottom: 0
    }

    font.family: FlatStyle.fontFamily
    textColor: !control.enabled ? FlatStyle.mediumFrameColor :
                control.editable ? FlatStyle.defaultTextColor :
                control.pressed ? FlatStyle.selectedTextColor :
                control.activeFocus ? FlatStyle.focusedTextColor : FlatStyle.styleColor
    selectionColor: FlatStyle.highlightColor
    selectedTextColor: FlatStyle.selectedTextColor

    dropDownButtonWidth: Math.round(28 * FlatStyle.scaleFactor)

    background: Item {
        id: background
        anchors.fill: parent
        implicitWidth: Math.round(100 * FlatStyle.scaleFactor)
        implicitHeight: Math.round(26 * FlatStyle.scaleFactor)

        Rectangle {
            anchors.fill: parent
            radius: FlatStyle.radius

            visible: !control.editable
            opacity: control.enabled ? 1.0 : control.editable ? 0.1 : 0.2

            color: control.editable && !control.enabled ? FlatStyle.disabledColor :
                   control.activeFocus && control.pressed ? FlatStyle.focusedAndPressedColor :
                   control.pressed ? FlatStyle.pressedColorAlt : "transparent"

            border.width: control.activeFocus ? FlatStyle.twoPixels : FlatStyle.onePixel
            border.color: !control.enabled ? FlatStyle.disabledColor :
                           control.activeFocus && control.pressed ? FlatStyle.focusedAndPressedColor :
                           control.activeFocus ? FlatStyle.highlightColor :
                           control.pressed ? FlatStyle.pressedColorAlt : FlatStyle.styleColor
        }

        Item {
            clip: true
            visible: control.editable
            width: style.dropDownButtonWidth
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Rectangle {
                width: background.width
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                radius: FlatStyle.radius
                color: !control.enabled ? FlatStyle.lightFrameColor :
                        control.activeFocus && control.pressed ? FlatStyle.focusedAndPressedColor :
                        control.activeFocus ? FlatStyle.focusedColor :
                        control.pressed ? FlatStyle.pressedColor : FlatStyle.styleColor
            }
        }

        LeftArrowIcon {
            width: Math.round(14 * FlatStyle.scaleFactor)
            height: Math.round(14 * FlatStyle.scaleFactor)
            anchors.right: parent.right
            anchors.rightMargin: width / 2
            anchors.verticalCenter: parent.verticalCenter
            rotation: control.pressed ? 90 : -90
            color: control.editable || control.pressed ? FlatStyle.selectedTextColor
                : control.activeFocus ? FlatStyle.focusedColor
                : control.enabled ? FlatStyle.styleColor : FlatStyle.disabledColor
            opacity: control.enabled || control.editable ? 1.0 : 0.2
        }
    }

    __editor: Item {
        clip: true
        anchors.fill: parent
        anchors.bottomMargin: anchors.margins + 1 // ### FIXME: compensate the -1 margin in ComboBoxStyle:
        Rectangle {
            anchors.fill: parent
            anchors.rightMargin: -Math.round(3 * FlatStyle.scaleFactor)

            radius: FlatStyle.radius
            color: !control.enabled ? FlatStyle.disabledColor : FlatStyle.backgroundColor
            opacity: control.enabled ? 1.0 : 0.1

            border.width: control.activeFocus ? FlatStyle.twoPixels : FlatStyle.onePixel
            border.color: !control.enabled ? FlatStyle.disabledColor :
                           control.activeFocus ? FlatStyle.highlightColor :
                           control.pressed ? FlatStyle.pressedColorAlt : FlatStyle.styleColor
        }
    }

    __dropDownStyle: MenuStyle {
        font: style.font
        __maxPopupHeight: 600
        __menuItemType: "comboboxitem"
        __scrollerStyle: ScrollViewStyle { }

        itemDelegate.background: Item {
            Rectangle {
                anchors.fill: parent
                color: !!styleData.pressed || styleData.selected ? FlatStyle.disabledColor : "transparent"
                opacity: !!styleData.pressed || styleData.selected ? 0.15 : 1.0
            }
            Rectangle {
                color: FlatStyle.darkFrameColor
                width: parent.width
                height: FlatStyle.onePixel
                anchors.bottom: parent.bottom
                visible: styleData.index < control.__menu.items.length - 1 // TODO
            }
        }
    }

    __selectionHandle: SelectionHandleStyle { }
    __cursorHandle: CursorHandleStyle { }
}
