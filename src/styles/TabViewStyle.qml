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
import QtQuick.Controls.Styles 1.0

/*!
    \qmltype TabViewStyle
    \internal
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \brief provides custom styling for TabView
*/

Style {

    /*! This property holds the base alignment of the tab bar.
      The default value is "left". Supporeted alignments are
      "left", "center" or "right".
    */
    property string tabBarAlignment: "left"

    /*! This property holds the left margin of the tab bar.
      It will only affect tabs \l tabBarAligment set to "right".
    */
    property int leftMargin: 0

    /*! This property holds the right margin of the tab bar.
      It will only affect tabs \l tabBarAligment set to "right".
    */
    property int rightMargin: 0

    /*! This property holds the amount of overlap there are between
      individual tab buttons. The default value is 0
    */
    property int tabOverlap: 0

    property int tabvshift : 0
    property int tabBaseOverlap: 0

    property Component frame: Item {
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: -10
            color: "lightgray"
            border.color: "gray"
        }
    }

    property Component tab: Item {
        implicitWidth: textitem.implicitWidth + 20
        implicitHeight: textitem.implicitHeight + 4

        Rectangle {
            anchors.fill: parent
            gradient: Gradient{
                GradientStop { color: tab.selected ? "lightgray" : "white" ; position: 0}
                GradientStop { color: tab.selected ? "lightgray" : "lightgray" ; position: 1}
            }
            border.color: "#aaa"

        }

        Text {
            id: textitem
            anchors.centerIn: parent
            text: tab.title
            renderType: Text.NativeRendering
        }
    }

}
