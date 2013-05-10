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
import QtQuick.Controls.Private 1.0

/*!
    \qmltype TabViewStyle
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \since QtQuick.Controls.Styles 1.0
    \brief Provides custom styling for TabView

\qml
    TabView {
        id: frame
        anchors.fill: parent
        anchors.margins: 4
        Tab { title: "Tab 1" }
        Tab { title: "Tab 2" }
        Tab { title: "Tab 3" }

        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                color: tab.selected ? "steelblue" :"lightsteelblue"
                border.color:  "steelblue"
                implicitWidth: Math.max(text.width + 4, 80)
                implicitHeight: 20
                radius: 2
                Text {
                    id: text
                    anchors.centerIn: parent
                    text: tab.title
                    color: tab.selected ? "white" : "black"
                }
            }
            frame: Rectangle { color: "steelblue" }
        }
    }
\endqml

*/

Style {

    /*! The \l ScrollView attached to this style. */
    readonly property TabView control: __control

    /*! This property holds the horizontal alignment of
        the tab buttons. Supported values are:
        \list
        \li Qt.AlignLeft (default)
        \li Qt.AlignHCenter
        \li Qt.AlignRight
        \endlist
    */
    property int tabsAlignment: Qt.AlignLeft

    /*! This property holds the left padding of the tab bar.  */
    property int tabsLeftPadding: 0

    /*! This property holds the right padding of the tab bar.  */
    property int tabsRightPadding: 0

    /*! This property holds the amount of overlap there are between
      individual tab buttons. */
    property int tabOverlap: 1

    /*! This property holds the amount of overlap there are between
      individual tab buttons and the frame. */
    property int frameOverlap: 2

    /*! This defines the tab frame. */
    property Component frame: Rectangle {
        color: "#dcdcdc"
        border.color: "#aaa"

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "#66ffffff"
            anchors.margins: 1
        }
    }

    /*! This defines the tab. You can access the tab state through the
        \c tab property, with the following properties:

        \table
            \li readonly property int index - This is the current tab index.
            \li readonly property bool selected - This is the active tab.
            \li readonly property string title - Tab title text.
            \li readonly property bool nextSelected = The next tab is selected.
            \li readonly property bool previsousSelected - The previous tab is selected.
            \li readonly property bool hovered - The tab is currently under the mouse.
            \li readonly property bool activeFocus - The tab button has keyboard focus.
        \endtable
    */
    property Component tab: Item {
        scale: control.tabPosition === Qt.TopEdge ? 1 : -1

        implicitWidth: Math.round(textitem.implicitWidth + 20)
        implicitHeight: Math.round(textitem.implicitHeight + 10)

        clip: true
        Item {
            anchors.fill: parent
            anchors.bottomMargin: tab.selected ? 0 : 2
            clip: true
            BorderImage {
                anchors.fill: parent
                source: tab.selected ? "images/tab_selected.png" : "images/tab.png"
                border.top: 6
                border.bottom: 6
                border.left: 6
                border.right: 6
                anchors.topMargin: tab.selected ? 0 : 1
            }
            BorderImage {
                anchors.fill: parent
                anchors.topMargin: -2
                anchors.leftMargin: -2
                anchors.rightMargin: -1
                source: "images/focusframe.png"
                visible: tab.activeFocus && tab.selected
                border.left: 4
                border.right: 4
                border.top: 4
                border.bottom: 4
            }
        }
        Text {
            id: textitem
            anchors.centerIn: parent
            text: tab.title
            renderType: Text.NativeRendering
            scale: control.tabPosition === Qt.TopEdge ? 1 : -1
            color: __syspal.text
        }
    }
}
