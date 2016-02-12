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

    readonly property int waitTime: 200

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
        wait(waitTime);
        tryCompare(fileMenu, "__popupVisible", true)
        mouseMove(fileMenu.__contentItem, 0, -10)
        wait(waitTime)
        mouseRelease(fileMenu.__contentItem, 0, -10)
        tryCompare(fileMenu, "__popupVisible", true)
        wait(waitTime)

        window.destroy();
    }

    function test_keyNavigation() {
        if (Qt.platform.os === "osx")
            skip("MenuBar cannot be reliably tested on OS X")

        var window = windowComponent.createObject()
        waitForRendering(window.contentItem)
        var fileMenu = findChild(window, "fileMenu")
        verify(fileMenu)
        var editMenu = findChild(window, "editMenu")
        verify(editMenu)

        // Click menu should open
        tryCompare(fileMenu, "__popupVisible", false)
        mouseClick(fileMenu.__visualItem)
        wait(waitTime)
        tryCompare(fileMenu, "__popupVisible", true)
        tryCompare(fileMenu, "__currentIndex", -1)
        tryCompare(fileMenu.__contentItem, "status", Loader.Ready)

        // Move right
        tryCompare(editMenu, "__popupVisible", false)
        keyPress(Qt.Key_Right, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Right, Qt.NoModifier, waitTime)
        tryCompare(editMenu, "__popupVisible", true)
        tryCompare(editMenu.__contentItem, "status", Loader.Ready)

        // Move left
        tryCompare(fileMenu, "__popupVisible", false)
        keyPress(Qt.Key_Left, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Left, Qt.NoModifier, waitTime)
        tryCompare(fileMenu, "__popupVisible", true)
        tryCompare(fileMenu, "__currentIndex", 0)
        tryCompare(fileMenu.__contentItem, "status", Loader.Ready)

        // Move down
        var saveMenuItem = findChild(window, "saveMenuItem")
        verify(saveMenuItem)
        tryCompare(saveMenuItem.__visualItem.styleData, "selected", false)
        keyPress(Qt.Key_Down, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Down, Qt.NoModifier, waitTime)
        tryCompare(fileMenu, "__currentIndex", 1)
        tryCompare(saveMenuItem.__visualItem.styleData, "selected", true)

        // Move up
        var recentFilesSubMenu = findChild(window, "recentFilesSubMenu")
        verify(recentFilesSubMenu)
        tryCompare(recentFilesSubMenu.__visualItem.styleData, "selected", false)
        keyPress(Qt.Key_Up, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Up, Qt.NoModifier, waitTime)
        tryCompare(fileMenu, "__currentIndex", 0)
        tryCompare(recentFilesSubMenu.__visualItem.styleData, "selected", true)

        // Move right inside sub menu
        tryCompare(recentFilesSubMenu, "__popupVisible", false)
        tryCompare(recentFilesSubMenu, "__currentIndex", -1)
        keyPress(Qt.Key_Right, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Right, Qt.NoModifier, waitTime)
        tryCompare(recentFilesSubMenu, "__popupVisible", true)
        tryCompare(recentFilesSubMenu, "__currentIndex", 0)
        tryCompare(recentFilesSubMenu.__contentItem, "status", Loader.Ready)

        // Move down inside sub menu
        var recentFile2MenuItem = findChild(window, "recentFile2MenuItem")
        verify(recentFile2MenuItem)
        tryCompare(recentFile2MenuItem.__visualItem.styleData, "selected", false)
        tryCompare(recentFilesSubMenu, "__currentIndex", 0)
        keyPress(Qt.Key_Down, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Down, Qt.NoModifier, waitTime)
        tryCompare(recentFilesSubMenu, "__currentIndex", 1)
        tryCompare(recentFile2MenuItem.__visualItem.styleData, "selected", true)

        // Move up inside sub menu
        var recentFile1MenuItem = findChild(window, "recentFile1MenuItem")
        verify(recentFile1MenuItem)
        tryCompare(recentFile1MenuItem.__visualItem.styleData, "selected", false)
        tryCompare(recentFilesSubMenu, "__currentIndex", 1)
        keyPress(Qt.Key_Up, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Up, Qt.NoModifier, waitTime)
        tryCompare(recentFilesSubMenu, "__currentIndex", 0)
        tryCompare(recentFile1MenuItem.__visualItem.styleData, "selected", true)

        // Move left out of sub menu
        keyPress(Qt.Key_Left, Qt.NoModifier, waitTime)
        keyRelease(Qt.Key_Left, Qt.NoModifier, waitTime)
        tryCompare(recentFilesSubMenu, "__popupVisible", false)
        tryCompare(recentFilesSubMenu, "__currentIndex", -1)

        window.destroy()
    }
}
