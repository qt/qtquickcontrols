/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import "custom" as Components

Components.Button {
    id: button

    implicitWidth: Math.max(72, backgroundItem.implicitWidth)
    implicitHeight: Math.max(22, backgroundItem.implicitHeight)

    property alias containsMouse: tooltip.containsMouse
    property bool defaultbutton: false
    property string styleHint

    TooltipArea {
        // Note this will eat hover events
        id: tooltip
        anchors.fill: parent
        text: button.tooltip
    }

    background: StyleItem {
        id: styleitem
        anchors.fill: parent
        elementType: "button"
        sunken: pressed || checked
        raised: !(pressed || checked)
        hover: containsMouse
        text: iconSource === "" ? "" : button.text
        hasFocus: button.focus
        hint: button.styleHint

        // If no icon, let the style do the drawing
        activeControl: defaultbutton ? "default" : "f"
    }

    label: Item {
        // Used as a fallback since I can't pass the imageURL
        // directly to the style object
        visible: button.iconSource === ""
        Row {
            id: row
            anchors.centerIn: parent
            spacing: 4
            Image {
                source: iconSource
                anchors.verticalCenter: parent.verticalCenter
                fillMode: Image.Stretch //mm Image should shrink if button is too small, depends on QTBUG-14957
            }
            Text {
                id:text
                color: textColor
                anchors.verticalCenter: parent.verticalCenter
                text: button.text
                horizontalAlignment: Text.Center
            }
        }
    }
    Keys.onSpacePressed:animateClick()
}

