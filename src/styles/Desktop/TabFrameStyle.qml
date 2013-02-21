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
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import QtQuick.Controls.Styles 1.0

Style {
    id: root

    property int leftMargin: 0
    property int rightMargin: 0
    property StyleItem __barstyle: StyleItem { elementType: "tabbar" ; visible: false }
    property string tabBarAlignment: __barstyle.styleHint("tabbaralignment");
    property int tabOverlap: __barstyle.pixelMetric("taboverlap");
    property int tabBaseOverlap: __barstyle.pixelMetric("tabbaseoverlap");

    property Component frame: StyleItem {
        id: styleitem
        anchors.fill: parent
        anchors.topMargin: 1//stack.baseOverlap
        z: style == "oxygen" ? 1 : 0
        elementType: "tabframe"
        hints: position
        value: tabbarItem && tabsVisible && tabbarItem.tab(current) ? tabbarItem.tab(current).x : 0
        minimum: tabbarItem && tabsVisible && tabbarItem.tab(current) ? tabbarItem.tab(current).width : 0
        maximum: tabbarItem && tabsVisible ? tabbarItem.width : width
        Component.onCompleted: {
            stack.frameWidth = styleitem.pixelMetric("defaultframewidth");
            stack.style = style;
            stack.baseOverlap = root.tabBaseOverlap;
        }
    }

    property Component tab: Item {
        property string tabpos: control.count === 1 ? "only" : index === 0 ? "beginning" : index === control.count - 1 ? "end" : "middle"
        property string selectedpos: nextSelected ? "next" : previousSelected ? "previous" : ""
        property int tabHSpace: __barstyle.pixelMetric("tabhspace");
        property int tabVSpace: __barstyle.pixelMetric("tabvspace");
        implicitWidth: Math.max(50, textitem.width) + tabHSpace + 2
        implicitHeight: Math.max(styleitem.font.pixelSize + tabVSpace + 6, 0)

        StyleItem {
            id: styleitem

            elementType: "tab"

            anchors.fill: parent
            anchors.leftMargin: (selected && style == "mac") ? -1 : 0

            hints: [control.position, tabpos, selectedpos]

            selected: tab.selected
            text:  title
            hover: tab.hover
            hasFocus: tab.focus && selected
            anchors.margins: paintMargins

            Text {
                id: textitem
                visible: false
                text: styleitem.text
            }
        }
    }
}
