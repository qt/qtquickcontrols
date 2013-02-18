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
        \qmltype TabBar
        \internal
        \inqmlmodule QtDesktop.Private 1.0
*/
Item {
    id: tabbar
    height: tabrow.height
    width: tabrow.width


    Keys.onRightPressed: {
        if (tabFrame && tabFrame.current < tabFrame.count - 1)
            tabFrame.current = tabFrame.current + 1
    }
    Keys.onLeftPressed: {
        if (tabFrame && tabFrame.current > 0)
            tabFrame.current = tabFrame.current - 1
    }

    onTabFrameChanged: parent = tabFrame
    visible: tabFrame ? tabFrame.tabsVisible : true


    property Item tabFrame
    property var style
    property var styleItem: tabFrame.__styleItem ? tabFrame.__styleItem : null

    property string tabBarAlignment: styleItem ? styleItem.tabBarAlignment : "left"
    property string position: tabFrame ? tabFrame.position : "North"

    property int tabOverlap: styleItem ? styleItem.tabOverlap : 0
    property int tabBaseOverlap: styleItem ? styleItem.tabBaseOverlap : 0

    function tab(index) {
        for (var i = 0; i < tabrow.children.length; ++i) {
            if (tabrow.children[i].tabindex == index) {
                return tabrow.children[i]
            }
        }
        return null;
    }

    Row {
        id: tabrow
        Accessible.role: Accessible.PageTabList
        spacing: -tabOverlap

        states: [
            State {
                name: "left"
                when: tabBarAlignment == "left"
                AnchorChanges { target:tabrow ; anchors.left: parent.left }
                PropertyChanges { target:tabrow ; anchors.leftMargin: styleItem ? styleItem.leftMargin : 0 }
            },
            State {
                name: "center"
                when: tabBarAlignment == "center"
                AnchorChanges { target:tabrow ; anchors.horizontalCenter: tabbar.horizontalCenter }
            },
            State {
                name: "right"
                when: tabBarAlignment == "right"
                AnchorChanges { target:tabrow ; anchors.right: parent.right }
                PropertyChanges { target:tabrow ; anchors.rightMargin: styleItem ? styleItem.rightMargin : 0 }
            }
        ]


        Repeater {
            id: repeater
            focus: true
            model: tabFrame ? tabFrame.tabs.length : null
            delegate: Item {
                id: tabitem
                focus: true

                property int tabindex: index
                property bool selectedHelper: selected
                property bool selected : tabFrame.current == index
                property bool hover: mousearea.containsMouse
                property bool first: index === 0
                property string title: tabFrame.tabs[index].title

                z: selected ? 1 : -index
                implicitWidth: Math.min(tabloader.implicitWidth, tabbar.width/tabs.length) + 1
                implicitHeight: tabloader.implicitHeight

                Loader {
                    id: tabloader

                    sourceComponent: loader.item ? loader.item.tab : null
                    anchors.fill: parent

                    property Item control: tabFrame
                    property Item tab: tabitem
                    property int index: tabindex
                    property bool nextSelected: tabFrame.current === index + 1
                    property bool previousSelected: tabFrame.current === index - 1
                    property string title: tab.title
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: tabFrame.current = index
                    onPressAndHold: tabitem.parent = null
                }
                Accessible.role: Accessible.PageTab
                Accessible.name: tabFrame.tabs[index].title
            }
        }
    }
}
