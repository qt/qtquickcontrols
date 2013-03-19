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
import "Styles/Settings.js" as Settings

/*!
    \qmltype TabView
    \inqmlmodule QtQuick.Controls 1.0
    \ingroup views
    \brief A control that allows the user to select one of multiple stacked items.

*/

FocusScope {
    id: root
    implicitWidth: 150
    implicitHeight: 150

    /*! The current tab index */
    property int currentIndex: 0

    /*! The current tab count */
    property int count: 0

    /*! The visibility of the tab frame around contents */
    property bool frameVisible: true

    /*! The visibility of the tab bar */
    property bool tabsVisible: true

    /*!
        \qmlproperty enumeration TabView::tabPosition

        \list
        \li Qt.TopEdge (default)
        \li Qt.BottomEdge
        \endlist
    */
    property int tabPosition: Qt.TopEdge

    /*! \internal */
    default property alias data: stack.data

    /*! Adds a new tab page with title with and optional Component.
        \return the newly added tab
    */
    function addTab(title, component) {
        var tab = tabcomp.createObject(this);
        tab.sourceComponent = component
        __tabs.push(tab)
        tab.parent = stack
        tab.title = title
        __setOpacities()
        return tab
    }

    /*! Inserts a new tab with title at index, with an optional Component.
        \return the newly added tab
    */
    function insertTab(index, title, component) {
        var tab = tabcomp.createObject(this);
        tab.sourceComponent = component
        tab.parent = stack
        tab.title = title
        __tabs.splice(index, 0, tab);
        __setOpacities()
        return tab
    }

    /*! Removes and destroys a tab at the given index */
    function removeTab(index) {
        var tab = __tabs[index]
        __tabs.splice(index, 1);
        tab.destroy()
        if (currentIndex > 0)
            currentIndex--
        __setOpacities()
    }

    /*! Returns the \l Tab item at index */
    function tabAt(index) {
        return __tabs[index]
    }

    /*! \internal */
    property var __tabs: new Array()

    /*! \internal */
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/TabViewStyle.qml", root)

    /*! \internal */
    property var __styleItem: loader.item

    /*! \internal */
    onCurrentIndexChanged: __setOpacities()

    /*! \internal */
    function __setOpacities() {
        for (var i = 0; i < __tabs.length; ++i) {
            var child = __tabs[i];
            child.visible = (i == currentIndex ? true : false)
        }
        count = __tabs.length
    }

    activeFocusOnTab: false

    Component {
        id: tabcomp
        Tab {}
    }

    TabBar {
        id: tabbarItem
        tabView: root
        style: loader.item
        anchors.top: parent.top
        anchors.left: root.left
        anchors.right: root.right
    }

    Loader {
        id: loader
        z: tabbarItem.z - 1
        sourceComponent: style
        property var control: root
    }

    Loader {
        id: frameLoader
        z: tabbarItem.z - 1

        anchors.fill: parent
        anchors.topMargin: tabbarItem && tabsVisible && tabPosition == Qt.TopEdge ? Math.max(0, tabbarItem.height - stack.baseOverlap) : 0
        anchors.bottomMargin: tabbarItem && tabsVisible && tabPosition == Qt.BottomEdge ? Math.max(0, tabbarItem.height - stack.baseOverlap) : 0
        sourceComponent: frameVisible && loader.item ? loader.item.frame : null
        property var control: root

        Item {
            id: stack

            anchors.fill: parent
            anchors.margins: (frameVisible ? frameWidth : 0)
            anchors.topMargin: anchors.margins + (style =="mac" ? 6 : 0)
            anchors.bottomMargin: anchors.margins + (style =="mac" ? 6 : 0)

            property int frameWidth
            property string style
            property int baseOverlap

            /*! \internal */
            Component.onCompleted: {
                for (var i = 0 ; i < stack.children.length ; ++i) {
                    if (stack.children[i].Accessible.role === Accessible.PageTab)
                        __tabs.push(stack.children[i])
                }
                __setOpacities()
            }
        }
        onLoaded: { item.z = -1 }
    }

    states: [
        State {
            name: "Bottom"
            when: tabPosition == Qt.BottomEdge && tabbarItem != undefined
            PropertyChanges {
                target: tabbarItem
                anchors.topMargin: tabbarItem.height
            }
            AnchorChanges {
                target: tabbarItem
                anchors.top: undefined
                anchors.bottom: root.bottom
            }
        }
    ]
}
