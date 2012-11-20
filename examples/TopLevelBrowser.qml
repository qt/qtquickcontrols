/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
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
import "content"

Window {
    id: topLevelBrowser
    title: "Qml Desktop Browser"

    width: 640
    height: 480
    visible: true

    MenuBar {
        Menu {
            text: "File"
            MenuItem {
                text: "New Tab"
                shortcut: "Ctrl+T"
                onTriggered: {
                    browser.addTab()
                }
            }
            MenuItem {
                text: "New Window"
                shortcut: "Ctrl+N"
                onTriggered: {
                    var topLevelBrowserComponent = Qt.createComponent("TopLevelBrowser.qml")
                     if (topLevelBrowserComponent.status == Component.Ready) {
                        console.log("creating browserWindow")
                        var browserWindow = topLevelBrowserComponent.createObject(null);
                    }
                }
            }
            MenuItem {
                text: "Open Location"
                shortcut: "Ctrl+L"
                onTriggered: {
                    browser.address.focus = true
                    browser.address.selectAll()
                    browser.address.forceActiveFocus()
                }
            }
            Separator {}
            MenuItem {
                text: "Close Tab"
                shortcut: "Ctrl+W"
                onTriggered: {
                    browser.closeTab()
                }
            }
            MenuItem {
                text: "Close Window"
                shortcut: "Ctrl+Shift+W"
                onTriggered: {
                    topLevelBrowser.close = true
                }
            }
            Separator {}
            MenuItem {
                text: "Close Browser"
                shortcut: "Ctrl+Q"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            text: "Edit"
            MenuItem {
                text: "Copy"
            }
            MenuItem {
                text: "Paste"
            }
        }
    }

    Browser {
        id: browser
        anchors.fill: parent
    }

}

