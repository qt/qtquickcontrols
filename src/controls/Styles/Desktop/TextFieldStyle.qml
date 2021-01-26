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

Style {
    property int renderType: Text.NativeRendering

    property Component panel: StyleItem {
        id: textfieldstyle
        elementType: "edit"
        anchors.fill: parent

        sunken: true
        hasFocus: control.activeFocus
        hover: hovered
        hints: control.styleHints

        property color textColor: SystemPaletteSingleton.text(control.enabled)
        property color placeholderTextColor: "darkGray"
        property color selectionColor: SystemPaletteSingleton.highlight(control.enabled)
        property color selectedTextColor: SystemPaletteSingleton.highlightedText(control.enabled)


        property bool rounded: !!hints["rounded"]
        property int topMargin: style === "mac" ? 3 : 2
        property int leftMargin: rounded ? 12 : 4
        property int rightMargin: leftMargin
        property int bottomMargin: 2

        contentWidth: 100
        // Form QLineEdit::sizeHint
        contentHeight: Math.max(control.__contentHeight, 16)

        FocusFrame {
            anchors.fill: parent
            visible: textfield.activeFocus && textfieldstyle.styleHint("focuswidget") && !rounded
        }
        textureHeight: implicitHeight
        textureWidth: 32
        border {top: 8 ; bottom: 8 ; left: 8 ; right: 8}
    }
}
