/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0

/*!
        \qmltype ScrollViewHeader
        \internal
        \inqmlmodule QtQuick.Controls.Private 1.0
*/
Item {
    id: wheelarea

    property alias horizontalScrollBar: hscrollbar
    property alias verticalScrollBar: vscrollbar
    property bool blockUpdates: false
    property int availableHeight
    property int availableWidth
    property int contentHeight
    property int contentWidth

    anchors.fill: parent

    property int frameMargin: outerFrame ? frameWidth : 0

    property bool recursionGuard: false

    function doLayout() {
        if (!recursionGuard) {
            recursionGuard = true
            wheelarea.availableWidth = viewport.width
            wheelarea.availableHeight = viewport.height
            wheelarea.contentWidth = flickableItem !== null ? flickableItem.contentWidth : 0
            wheelarea.contentHeight = flickableItem !== null ? flickableItem.contentHeight : 0
            recursionGuard = false
        }
    }

    Connections {
        target: viewport
        onWidthChanged: doLayout()
        onHeightChanged: doLayout()
    }

    Connections {
        target: flickableItem
        onContentWidthChanged: doLayout()
        onContentHeightChanged: doLayout()
    }

    Connections {
        target: flickableItem
        onContentXChanged: {
            hscrollbar.flash()
            vscrollbar.flash()
        }
        onContentYChanged: {
            hscrollbar.flash()
            vscrollbar.flash()
        }
    }

    Loader {
        id: cornerFill
        sourceComponent: __style.corner
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: frameMargin
        anchors.rightMargin: frameMargin
        width: visible ? vscrollbar.width : 0
        height: visible ? hscrollbar.height : 0
        visible: hscrollbar.visible && !hscrollbar.isTransient && vscrollbar.visible && !vscrollbar.isTransient
    }

    ScrollBar {
        id: hscrollbar
        property bool isTransient: !!styleItem && styleItem.styleHint("transientScrollBars")
        property bool active: !!styleItem && (styleItem.sunken || styleItem.activeControl != "none")
        orientation: Qt.Horizontal
        visible: contentWidth > availableWidth
        height: visible ? implicitHeight : 0
        z: 1
        maximumValue: contentWidth > availableWidth ? contentWidth - availableWidth : 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: cornerFill.left
        anchors.leftMargin: frameMargin
        anchors.bottomMargin: frameMargin
        onValueChanged: {
            if (!blockUpdates) {
                flickableItem.contentX = value
            }
        }
        Binding {
            target: hscrollbar.styleItem
            property: "raised"
            value: vscrollbar.active
            when: hscrollbar.isTransient
        }
        function flash() {
            if (hscrollbar.isTransient) {
                hscrollbar.styleItem.on = true
                hscrollbar.styleItem.visible = true
            }
        }
    }

    ScrollBar {
        id: vscrollbar
        property bool isTransient: !!styleItem && styleItem.styleHint("transientScrollBars")
        property bool active: !!styleItem && (styleItem.sunken || styleItem.activeControl != "none")
        orientation: Qt.Vertical
        visible: contentHeight > availableHeight
        width: visible ? implicitWidth : 0
        z: 1
        anchors.bottom: cornerFill.top
        anchors.bottomMargin: hscrollbar.visible ? 0 : frameMargin
        maximumValue: contentHeight > availableHeight ? contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: __scrollBarTopMargin + frameMargin
        anchors.rightMargin: frameMargin
        onValueChanged: {
            if (flickableItem && !blockUpdates && enabled) {
                flickableItem.contentY = value
            }
        }
        Binding {
            target: vscrollbar.styleItem
            property: "raised"
            value: hscrollbar.active
            when: vscrollbar.isTransient
        }
        function flash() {
            if (vscrollbar.isTransient) {
                vscrollbar.styleItem.on = true
                vscrollbar.styleItem.visible = true
            }
        }
    }
}
