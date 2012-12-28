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

/*!
    \qmltype ApplicationWindow
    \inqmlmodule QtDesktop 1.0
    \brief ApplicationWindow is doing bla...bla...
*/

Window {
    id: root
    width: 320
    height: 240

    property MenuBar menuBar
    property alias toolBar: toolBarArea.data
    property alias statusBar: statusBarArea.data
    default property alias data: contentArea.data
    property alias backgroundColor: syspal.window
    property bool showMenuBar: menuBar ? menuBar.showMenuBar : false

    SystemPalette {id: syspal}

    Rectangle {
        anchors.fill: parent
        color: backgroundColor
    }

    StyleItem {
        id: menuBarArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        elementType: "menubar"
        visible: showMenuBar
        contentHeight: showMenuBar ? 20 : 0
        Row {
            id: row
            anchors.fill: parent
            Repeater {
                model: showMenuBar ? menuBar.menuList.length : 0
                StyleItem {
                    id: menuItem
                    elementType: "menubaritem"
                    contentWidth: 100
                    contentHeight: 20
                    width: text.paintedWidth + 12
                    height :text.paintedHeight + 4
                    sunken: true
                    selected: mouse.pressed
                    property var menu: menuBar.menuList[index]
                    Text {
                        id: text
                        text: menu.text
                        anchors.centerIn: parent
                        renderType: Text.NativeRendering
                        color: menuItem.selected ? syspal.highlightedText : syspal.windowText
                    }
                    MouseArea {
                        id: mouse
                        anchors.fill:parent
                        onPressed: menu.showPopup(menuItem.x, menuBarArea.height, 0, root)
                    }
                }
            }
        }
    }

    Row {
        id: toolBarArea
        anchors.top: menuBarArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Item {
        id: contentArea
        anchors.top: toolBarArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: statusBarArea.top
    }

    Row {
        id: statusBarArea
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
