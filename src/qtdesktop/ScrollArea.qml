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
import "private" as Private

/*!
    \qmltype ScrollArea
    \inqmlmodule QtDesktop 1.0
    \brief ScrollArea is doing bla...bla...
*/

FocusScope {
    id: root
    width: 100
    height: 100

    // Cosmetic propeties
    property bool frame: true
    property bool frameAroundContents: true
    property bool highlightOnFocus: false
    property alias color: colorRect.color // background color
    property int frameWidth: frame ? styleitem.frameWidth : 0

    // Item properties
    property alias horizontalScrollBar: scroller.horizontalScrollBar
    property alias verticalScrollBar: scroller.verticalScrollBar

    // Viewport properties
    property int contentX
    property int contentY
    property int contentHeight : content.childrenRect.height
    property int contentWidth: content.childrenRect.width
    property int viewportHeight: height - (horizontalScrollBar.visible ? verticalScrollBar.height : 0) - 2 * frameWidth
    property int viewportWidth: width - (verticalScrollBar.visible ? verticalScrollBar.width : 0) - 2 * frameWidth
    default property alias data: content.data

    Rectangle {
        id: colorRect
        color: "transparent"
        anchors.fill:styleitem
        anchors.margins: frameWidth
    }

    StyleItem {
        id: styleitem
        elementType: "frame"
        sunken: true
        visible: frame
        anchors.fill: parent
        anchors.rightMargin: frame ? (frameAroundContents ? (verticalScrollBar.visible ? verticalScrollBar.width + 2 * frameMargins : 0) : 0) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (horizontalScrollBar.visible ? horizontalScrollBar.height + 2 * frameMargins : 0) : 0) : 0
        anchors.topMargin: frame ? (frameAroundContents ? 0 : 0) : 0
        property int frameWidth
        property int scrollbarspacing: styleitem.pixelMetric("scrollbarspacing");
        property int frameMargins : frame ? scrollbarspacing : 0
        Component.onCompleted: {
            frameWidth = styleitem.pixelMetric("defaultframewidth");
            frameAroundContents = styleitem.styleHint("framearoundcontents")
        }
    }

    onContentYChanged: {
        scroller.blockUpdates = true
        verticalScrollBar.value = contentY
        scroller.verticalValue = contentY
        scroller.blockUpdates = false
    }

    onContentXChanged: {
        scroller.blockUpdates = true
        horizontalScrollBar.value = contentX
        scroller.horizontalValue = contentX
        scroller.blockUpdates = false
    }

    Item {
        id: clipper
        anchors.fill: styleitem
        anchors.margins: frameWidth
        clip: true
        Item {
            id: content
            x: -root.contentX
            y: -root.contentY
        }
    }


    Private.ScrollAreaHelper {
        id: scroller
        anchors.fill: parent
    }

    StyleItem {
        z: 2
        anchors.fill: parent

        anchors.topMargin: -3
        anchors.leftMargin: -3
        anchors.rightMargin: -5
        anchors.bottomMargin: -5

        visible: highlightOnFocus && parent.activeFocus && styleitem.styleHint("focuswidget")
        elementType: "focusframe"
    }
}
