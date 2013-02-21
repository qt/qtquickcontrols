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

import QtQuick 2.0
import QtTest 1.0
import QtQuick.Controls 1.0

TestCase {
    id: testCase
    name: "Tests_ScrollArea"
    when:windowShown
    width:400
    height:400


    TextArea { id: textArea }

    Item { id: bigItem  }

    Component {
        id: scrollAreaComponent
        ScrollArea { }
    }

    function test_scroll() {
        var component = scrollAreaComponent
        var scrollArea = component.createObject(testCase);
        verify(scrollArea !== null, "table created is null")

        scrollArea.contentItem = bigItem
        scrollArea.visible = true
        verify(scrollArea.flickableItem, "flickableItem should not be null")
        verify(scrollArea.flickableItem !== scrollArea.contentItem)
        verify(scrollArea.flickableItem.contentHeight === 0, "ContentHeight not set")

        bigItem.height = 222
        bigItem.width = 333

        verify(scrollArea.flickableItem.contentHeight === 222, "ContentHeight not set")
        verify(scrollArea.flickableItem.contentWidth === 333, "ContentHeight not set")

        scrollArea.flickableItem.contentY = 200
        verify(scrollArea.flickableItem.contentY === 200, "ContentY not set")

        scrollArea.flickableItem.contentX = 300
        verify(scrollArea.flickableItem.contentX === 300, "ContentX not set")
    }

    function test_viewport() {
        var component = scrollAreaComponent
        var scrollArea =  component.createObject(testCase);
        verify(scrollArea !== null, "table created is null")

        scrollArea.forceActiveFocus();
        verify(scrollArea.viewport, "Viewport not defined")
        verify(!scrollArea.contentItem, "contentItem should be null")
        verify(!scrollArea.flickableItem, "flickableItem should be null")
        verify(!scrollArea.frame, "Frame should be false")

        scrollArea.contentItem = textArea
        verify(scrollArea.viewport, "Viewport should be defined")
        verify(scrollArea.contentItem, "contentItem should not be null")
        verify(scrollArea.flickableItem, "flickableItem should not be null")
        verify(scrollArea.flickableItem.contentHeight === textArea.height, "Content height not set")

        var prevViewportWidth  = scrollArea.viewport.width
        scrollArea.frame = true
        verify(scrollArea.frame, "Frame should be true")
        verify(scrollArea.viewport.width < prevViewportWidth, "Viewport should be smaller with frame")
    }
}
