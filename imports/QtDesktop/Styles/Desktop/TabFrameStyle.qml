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
    property rect contentRect
    property int margins: frame ? stack.frameWidth : 0
    property int __baseOverlap: frameitem.pixelMetric("tabbaseoverlap") // add paintmargins;
    contentRect: Qt.rect(margins, margins, 8 + margins + (frameitem.style == "mac" ? 6 : 0), margins + (frameitem.style =="mac" ? 6 : 0))

    StyleItem {
        id: frameitem
        anchors.fill: parent
        anchors.topMargin: 1//stack.baseOverlap
        z: style == "oxygen" ? 1 : 0
        elementType: "tabframe"
        info: position
        value: tabbarItem && tabsVisible && tabbarItem.tab(current) ? tabbarItem.tab(current).x : 0
        minimum: tabbarItem && tabsVisible && tabbarItem.tab(current) ? tabbarItem.tab(current).width : 0
        maximum: tabbarItem && tabsVisible ? tabbarItem.tabWidth : width
        Component.onCompleted: {
            stack.frameWidth = pixelMetric("defaultframewidth")
            stack.style = style
            stack.baseOverlap = pixelMetric("tabbaseoverlap")// add paintmargins;
        }
        states: [
            State {
                name: "South"
                when: position == "South" && tabbarItem!= undefined
                PropertyChanges {
                    target: frameitem
                    anchors.topMargin: 0
                    anchors.bottomMargin: 1//stack.baseOverlap
                }
            }
        ]
    }
}
