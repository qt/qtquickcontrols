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
import "Styles/Settings.js" as Settings

/*!
    \qmltype TabFrame
    \inqmlmodule QtDesktop 1.0
    \brief TabFrame is doing bla...bla...
*/

Item {
    id: tabWidget
    width: 100
    height: 100
    property int current: 0
    property int count: stack.children.length
    property bool frame: true
    property bool tabsVisible: true
    property string position: "North"
    default property alias tabs : stack.children
    property Item tabBar: tabbarItem
    property Component delegate: Qt.createComponent(Settings.THEME_PATH + "/TabFrameStyle.qml")

    onCurrentChanged: __setOpacities()
    Component.onCompleted: __setOpacities()

    function __setOpacities() {
        for (var i = 0; i < stack.children.length; ++i) {
            stack.children[i].visible = (i == current ? true : false)
        }
    }

    Component {
        id: tabcomp
        Tab {}
    }

    function addTab(component, title) {
        var tab = tabcomp.createObject(this);
        component.createObject(tab)
        tab.parent = stack
        tab.title = title
        __setOpacities()
        return tab
    }

    function removeTab(id) {
        var tab = tabs[id]
        tab.destroy()
        if (current > 0)
            current-=1
    }

    Loader {
        id: loader
        anchors.fill: parent
        anchors.topMargin: tabbarItem && tabsVisible && position == "North" ? Math.max(0, tabbarItem.height - stack.baseOverlap) : 0
        anchors.bottomMargin: tabbarItem && tabsVisible && position == "South" ? Math.max(0, tabbarItem.height - stack.baseOverlap) : 0
        sourceComponent: delegate
        Item {
            id: stack
            anchors.fill: parent
            anchors.margins: (frame ? frameWidth : 0)
            anchors.topMargin: anchors.margins + (style =="mac" ? 6 : 0)
            anchors.bottomMargin: anchors.margins + (style =="mac" ? 6 : 0)
            property int frameWidth
            property string style
            property int baseOverlap
        }
        onLoaded: item.z = -1
    }

    TabBar {
        id: tabbarItem
        tabFrame: tabWidget
        anchors.top: parent.top
        anchors.left: tabWidget.left
        anchors.right: tabWidget.right
    }

    states: [
        State {
            name: "South"
            when: position == "South" && tabbarItem != undefined
            PropertyChanges {
                target: tabbarItem
                anchors.topMargin: tabbarItem.height
            }
            AnchorChanges {
                target: tabbarItem
                anchors.top: undefined
                anchors.bottom: tabWidget.bottom
            }
        }
    ]
}
