/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
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
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
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

import QtQuick 2.2
import QtQuick.Controls 1.4
import QtTest 1.0

TestCase {
    id: testCase
    name: "Tests_MenuBar"
    when:windowShown
    width:400
    height:400

    Component {
        id: windowComponent
        ApplicationWindow {
            width: 300; height: 300
            visible: true
            menuBar: MenuBar {
                Menu {
                    title: "&File"; objectName: "fileMenu"
                    Menu {
                        title: "&Recent Files"; objectName: "recentFilesSubMenu"
                        MenuItem { text: "RecentFile1"; objectName: "recentFile1MenuItem" }
                        MenuItem { text: "RecentFile2"; objectName: "recentFile2MenuItem" }
                    }
                    MenuItem { text: "&Save"; objectName: "saveMenuItem" }
                    MenuItem { text: "&Load"; objectName: "loadMenuItem" }
                    MenuItem { text: "&Exit"; objectName: "exitMenuItem" }
                }
                Menu {
                    title: "&Edit"; objectName: "editMenu"
                    Menu {
                        title: "&Advanced"; objectName: "advancedSubMenu"
                        MenuItem { text: "advancedOption1"; objectName: "advancedOption1MenuItem" }
                    }
                    MenuItem { text: "&Preferences"; objectName: "preferencesMenuItem" }
                }
            }
        }
    }

    function test_createMenuBar() {
        var menuBar = Qt.createQmlObject('import QtQuick.Controls 1.2; MenuBar {}', testCase, '');
        menuBar.destroy()
    }


    function test_qtBug47295()
    {
        if (Qt.platform.os === "osx")
            skip("MenuBar cannot be reliably tested on OS X")

        var window = windowComponent.createObject()
        waitForRendering(window.contentItem)
        var fileMenu = findChild(window, "fileMenu")
        verify(fileMenu)
        tryCompare(fileMenu, "__popupVisible", false)
        mousePress(fileMenu.__visualItem)
        wait(200);
        tryCompare(fileMenu, "__popupVisible", true)
        mouseMove(fileMenu.__contentItem, 0, -10)
        wait(200)
        mouseRelease(fileMenu.__contentItem, 0, -10)
        tryCompare(fileMenu, "__popupVisible", true)
        wait(200)
    }
}
