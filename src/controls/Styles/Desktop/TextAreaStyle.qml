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

ScrollViewStyle {
    property font font: __styleitem.font
    property color textColor: SystemPaletteSingleton.text(control.enabled)
    property color selectionColor: SystemPaletteSingleton.highlight(control.enabled)
    property color selectedTextColor: SystemPaletteSingleton.highlightedText(control.enabled)
    property color backgroundColor: control.backgroundVisible ? SystemPaletteSingleton.base(control.enabled) : "transparent"

    property StyleItem __styleitem: StyleItem{
        elementType: "edit"
        visible: false
        active: control.activeFocus
    }

    property int renderType: Text.NativeRendering
    property real textMargin: 4
}
