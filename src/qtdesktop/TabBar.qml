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
    \qmltype TabBar
    \inqmlmodule QtDesktop 1.0
    \brief TabBar is doing bla...bla...
*/

Item {
    id: tabbar
    property int tabHeight: tabrow.height
    property int tabWidth: tabrow.width

    Keys.onRightPressed: {
        if (tabFrame && tabFrame.current < tabFrame.count - 1)
            tabFrame.current = tabFrame.current + 1
    }
    Keys.onLeftPressed: {
        if (tabFrame && tabFrame.current > 0)
            tabFrame.current = tabFrame.current - 1
    }

    height: tabHeight


    property Item tabFrame
    onTabFrameChanged: parent = tabFrame
    visible: tabFrame ? tabFrame.tabsVisible : true

    property int __overlap :  loader.item ? loader.item.__overlap : 0
    property string position: tabFrame ? tabFrame.position : "North"
    property string tabBarAlignment: loader.item ? loader.item.tabBarAlignment : "Center"
    property int tabOverlap: loader.item ? loader.item.tabOverlap : 0
    property int tabBaseOverlap: loader.item ? loader.item.tabBaseOverlap : 0
    property int tabHSpace: loader.item ? loader.item.tabHSpace : 0
    property int tabVSpace: loader.item ? loader.item.tabVSpace : 0

    function tab(index) {
        for (var i = 0; i < tabrow.children.length; ++i) {
            if (tabrow.children[i].tabindex == index) {
                return tabrow.children[i]
            }
        }
        return null;
    }

    property Component style: Qt.createComponent(Settings.THEME_PATH + "/TabBarStyle.qml")

    Loader {
        id: loader
        sourceComponent: style
        property alias control: tabbar
    }

    Row {
        id: tabrow
        Accessible.role: Accessible.PageTabList
        states:
            State {
            when: tabBarAlignment == "center"
            name: "centered"
            AnchorChanges {
                target:tabrow
                anchors.horizontalCenter: tabbar.horizontalCenter
            }
        }

        Repeater {
            id: repeater
            focus: true
            model: tabFrame ? tabFrame.tabs.length : null
            delegate: Item {
                id: tab
                focus: true

                property int tabindex: index
                property bool selectedHelper: selected
                property bool selected : tabFrame.current == index
                property bool hover: mousearea.containsMouse
                property bool first: index === 0

                z: selected ? 1 : -1
                implicitWidth: Math.min(tabloader.implicitWidth, tabbar.width/tabs.length) + 1
                implicitHeight: tabloader.implicitHeight

                Loader {
                    id: tabloader
                    sourceComponent: loader.item ? loader.item.tab : null
                    anchors.fill: parent
                   // anchors.margins: -2
                    property alias control: tab
                    property int index: tabindex
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: tabFrame.current = index
                }
                Accessible.role: Accessible.PageTab
                Accessible.name: tabFrame.tabs[index].title
            }
        }
    }
}
