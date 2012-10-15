/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
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
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
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
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 1.1
import "custom" as Components


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
    onTabFrameChanged:parent = tabFrame
    visible: tabFrame ? tabFrame.tabsVisible : true
    property int __overlap : styleitem.pixelMetric("tabvshift");
    property string position: tabFrame ? tabFrame.position : "North"
    property string tabBarAlignment: styleitem.styleHint("tabbaralignment");
    property int tabOverlap: styleitem.pixelMetric("taboverlap");
    property int tabBaseOverlap: styleitem.pixelMetric("tabbaseoverlap");
    property int tabHSpace: styleitem.pixelMetric("tabhspace");
    property int tabVSpace: styleitem.pixelMetric("tabvspace");

    function tab(index) {
        for (var i = 0; i < tabrow.children.length; ++i) {
            if (tabrow.children[i].tabindex == index) {
                return tabrow.children[i]
            }
        }
        return null;
    }

    StyleItem {
        visible:false
        id:styleitem
        elementType: "tab"
        text: "generic"
    }

    Row {
        id: tabrow
        property int paintMargins: 1
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
            id:repeater
            focus:true
            model: tabFrame ? tabFrame.tabs.length : null
            delegate: Item {
                id:tab
                focus:true
                property int tabindex: index
                property bool selected : tabFrame.current == index
                z: selected ? 1 : -1
                width: Math.min(implicitWidth, tabbar.width/tabs.length)

                implicitWidth: Math.max(textitem.paintedWidth, style.implicitWidth)
                implicitHeight: Math.max(textitem.paintedHeight, style.implicitHeight)

                StyleItem {
                    id: style
                    elementType: "tab"
                    selected: tab.selected
                    info: tabbar.position
                    text:  tabFrame.tabs[index].title
                    hover: mousearea.containsMouse
                    hasFocus: tabbar.focus && selected
                    property bool first: index === 0
                    paintMargins: tabrow.paintMargins
                    activeControl: tabFrame.count === 1 ? "only" : index === 0 ? "beginning" :
                            index === tabFrame.count-1 ? "end" : "middle"
                    anchors.fill: parent
                    anchors.margins: -paintMargins
                    contentWidth: textitem.width + tabHSpace + 2
                    contentHeight: Math.max(style.fontHeight + tabVSpace + 6, 0)
                    Text {
                        id: textitem
                        // Used for size hint
                        visible: false
                        text:  tabFrame.tabs[index].title
                    }
                }
                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: tabFrame.current = index
                }
            }
        }
    }
}
