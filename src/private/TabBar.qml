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

/*!
        \qmltype TabBar
        \internal
        \inqmlmodule QtQuick.Controls.Private 1.0
*/
FocusScope {
    id: tabbar
    height: tabrow.height
    width: tabrow.width

    activeFocusOnTab: true

    Keys.onRightPressed: {
        if (tabView && tabView.currentIndex < tabView.count - 1)
            tabView.currentIndex = tabView.currentIndex + 1
    }
    Keys.onLeftPressed: {
        if (tabView && tabView.currentIndex > 0)
            tabView.currentIndex = tabView.currentIndex - 1
    }

    onTabViewChanged: parent = tabView
    visible: tabView ? tabView.tabsVisible : true

    property var tabView
    property var style
    property var styleItem: tabView.__styleItem ? tabView.__styleItem : null

    property int tabsAlignment: styleItem ? styleItem.tabsAlignment : Qt.AlignLeft

    property int tabOverlap: styleItem ? styleItem.tabOverlap : 0

    property int elide: Text.ElideRight

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
        objectName: "tabrow"
        Accessible.role: Accessible.PageTabList
        spacing: -tabOverlap

        states: [
            State {
                name: "left"
                when: tabsAlignment === Qt.AlignLeft
                AnchorChanges { target:tabrow ; anchors.left: parent.left }
                PropertyChanges { target:tabrow ; anchors.leftMargin: styleItem ? styleItem.tabsLeftPadding : 0 }
            },
            State {
                name: "center"
                when: tabsAlignment === Qt.AlignHCenter
                AnchorChanges { target:tabrow ; anchors.horizontalCenter: tabbar.horizontalCenter }
            },
            State {
                name: "right"
                when: tabsAlignment === Qt.AlignRight
                AnchorChanges { target:tabrow ; anchors.right: parent.right }
                PropertyChanges { target:tabrow ; anchors.rightMargin: styleItem ? styleItem.tabsRightPadding : 0 }
            }
        ]


        Repeater {
            id: repeater
            objectName: "repeater"
            focus: true
            model: tabView.__tabs

            delegate: Item {
                id: tabitem
                focus: true

                property int tabindex: index
                property bool selected : tabView.currentIndex === index
                property bool hover: mousearea.containsMouse
                property string title: modelData.title
                property bool nextSelected: tabView.currentIndex === index + 1
                property bool previousSelected: tabView.currentIndex === index - 1

                z: selected ? 1 : -index
                implicitWidth: Math.min(tabloader.implicitWidth, tabbar.width/repeater.count) + 1
                implicitHeight: tabloader.implicitHeight

                Loader {
                    id: tabloader

                    sourceComponent: loader.item ? loader.item.tab : null
                    anchors.fill: parent

                    property Item control: tabView
                    property int index: tabindex

                    property QtObject tab: QtObject {
                        readonly property alias index: tabitem.tabindex
                        readonly property alias selected: tabitem.selected
                        readonly property alias title: tabitem.title
                        readonly property alias nextSelected: tabitem.nextSelected
                        readonly property alias previsousSelected: tabitem.previousSelected
                        readonly property alias hovered: tabitem.hover
                        readonly property bool activeFocus: tabbar.activeFocus
                    }
                }

                MouseArea {
                    id: mousearea
                    objectName: "mousearea"
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: {
                        tabView.currentIndex = index;
                        tabbar.nextItemInFocusChain(true).forceActiveFocus();
                    }
                }
                Accessible.role: Accessible.PageTab
                Accessible.name: modelData.title
            }
        }
    }
}
