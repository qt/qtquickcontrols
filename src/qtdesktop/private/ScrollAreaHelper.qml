/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
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
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtDesktop 1.0

WheelArea {
    id: wheelarea

    property alias horizontalScrollBar: hscrollbar
    property alias verticalScrollBar: vscrollbar
    property int macOffset: styleitem.style == "mac" ? 1 : 0
    property bool blockUpdates: false
    property int availableHeight : height - (hscrollbar.visible ? hscrollbar.height : 0)
    property int availableWidth: width - vscrollbar.width

    anchors.fill: parent
    anchors.margins: frameWidth
    horizontalMinimumValue: hscrollbar.minimumValue
    horizontalMaximumValue: hscrollbar.maximumValue
    verticalMinimumValue: vscrollbar.minimumValue
    verticalMaximumValue: vscrollbar.maximumValue

    onVerticalValueChanged: {
        if (!blockUpdates)
            verticalScrollBar.value = verticalValue
    }

    onHorizontalValueChanged: {
        if (!blockUpdates)
            horizontalScrollBar.value = horizontalValue
    }

    StyleItem {
        // This is the filled corner between scrollbars
        id: cornerFill
        elementType: "scrollareacorner"
        width: vscrollbar.width
        anchors.right: parent.right
        height: hscrollbar.height
        anchors.bottom: parent.bottom
        visible: hscrollbar.visible && vscrollbar.visible
    }

    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        visible: contentWidth > availableWidth
        maximumValue: contentWidth > availableWidth ? root.contentWidth - availableWidth : 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.leftMargin: parent.macOffset
        anchors.bottomMargin: -parent.macOffset
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: vscrollbar.visible ? vscrollbar.width -parent.macOffset: 0
        onValueChanged: {
            if (!blockUpdates) {
                contentX = value
                horizontalValue = value
            }
        }
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        // We cannot bind directly to tree.height due to binding loops so we have to redo the calculation here
        // visible: contentHeight > availableHeight
        maximumValue: contentHeight > availableHeight ? root.contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 1//parent.macOffset
        anchors.rightMargin: -parent.macOffset
        anchors.bottomMargin: hscrollbar.visible ? hscrollbar.height - parent.macOffset :  0

        onValueChanged: {
            if (!blockUpdates) {
                contentY = value
                verticalValue = value
            }
        }
    }
}
