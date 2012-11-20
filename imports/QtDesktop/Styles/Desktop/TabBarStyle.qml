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

Item {
    property int __overlap : styleitem.pixelMetric("tabvshift");
    property string position: tabFrame ? tabFrame.position : "North"
    property string tabBarAlignment: styleitem.styleHint("tabbaralignment");
    property int tabOverlap: styleitem.pixelMetric("taboverlap");
    property int tabBaseOverlap: styleitem.pixelMetric("tabbaseoverlap");
    property int tabHSpace: styleitem.pixelMetric("tabhspace");
    property int tabVSpace: styleitem.pixelMetric("tabvspace");

    property Component tab: StyleItem {
        id: styleitem
        elementType: "tab"
        anchors.fill: parent

        implicitWidth: Math.max(50, textitem.width) + styleitem.pixelMetric("tabhspace") + 2
        implicitHeight: Math.max(styleitem.font.pixelSize + styleitem.pixelMetric("tabvspace") + 6, 0)

        selected: control.selected
        info: tabbar.position
        text:  tabFrame.tabs[index].title
        hover: control.hover
        hasFocus: tabbar.focus && selected
        activeControl: tabFrame.count === 1 ? "only" : index === 0 ? "beginning" : index === tabFrame.count - 1 ? "end" : "middle"
        anchors.margins: paintMargins
        Text {
            id: textitem
            visible: false
            text: styleitem.text
        }
    }
}
