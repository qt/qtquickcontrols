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
import QtDesktop.Styles 1.0
import "Styles/Settings.js" as Settings

/*!
    \qmltype Menu
    \inqmlmodule QtDesktop 1.0
    \inherits MenuItem
    \brief Menu provides a menu component for use in menu bars, context menus, and other popup menus.

    \code
    Menu {
        text: "Edit"

        MenuItem {
            text: "Cut"
            shortcut: "Ctrl+X"
            onTriggered: ...
        }

        MenuItem {
            text: "Copy"
            shortcut: "Ctrl+C"
            onTriggered: ...
        }

        MenuItem {
            text: "Paste"
            shortcut: "Ctrl+V"
            onTriggered: ...
        }

        MenuSeparator { }

        Menu {
            text: "More Stuff"

            MenuItem {
                text: "Do Nothing"
            }
        }
    }
    \endcode

    \sa MenuBar, MenuItem, MenuSeparator
*/
MenuPrivate {
    id: root

    property Component style: Qt.createComponent(Settings.THEME_PATH + "/MenuStyle.qml", root)

    //! internal
    property var menuBar: null
    //! internal
    property int currentIndex: -1

    //! internal
    menuContentItem: Loader {
        sourceComponent: menuComponent
        active: !root.isNative && root.popupVisible
        focus: true
    }

    //! internal
    property Component menuComponent: Loader {
        id: menuFrameLoader

        property Style __style: styleLoader.item
        property Component menuItemStyle: __style ? __style.menuItem : null

        property var control: root
        property alias contentWidth: column.width
        property alias contentHeight: column.height

        property int subMenuXPos: width + (item && item["subMenuOverlap"] || 0)

        visible: control.popupVisible && status === Loader.Ready
        sourceComponent: __style ? __style.frame : undefined

        Loader {
            id: styleLoader
            active: !root.isNative
            sourceComponent: root.style
            onStatusChanged: {
                if (status === Loader.Error)
                    console.error("Failed to load Style for", root)
            }
        }

        focus: true
        Keys.forwardTo: menuBar ? [menuBar] : []
        Keys.onEscapePressed: root.dismissMenu()

        Keys.onDownPressed: {
            if (root.currentIndex < 0) {
                root.currentIndex = 0
                return
            }

            for (var i = root.currentIndex + 1;
                 i < root.menuItems.length && !canBeHovered(i); i++)
                ;
        }

        Keys.onUpPressed: {
            for (var i = root.currentIndex - 1;
                 i >= 0 && !canBeHovered(i); i--)
                ;
        }

        function canBeHovered(index) {
            var item = itemsRepeater.itemAt(index)
            if (!item["isSeparator"] && item.enabled) {
                root.currentIndex = index
                return true
            }
            return false
        }

        Keys.onLeftPressed: {
            if (root.parentMenu)
                closeMenu()
        }

        Keys.onRightPressed: {
            var item = itemsRepeater.itemAt(root.currentIndex)
            if (item && item.hasSubmenu) {
                item.menuItem.showPopup(menuFrameLoader.subMenuXPos, 0, -1, item)
                item.menuItem.currentIndex = 0
            }
        }

        Keys.onSpacePressed: menuFrameLoader.triggerAndDismiss()
        Keys.onReturnPressed: menuFrameLoader.triggerAndDismiss()
        Keys.onEnterPressed: menuFrameLoader.triggerAndDismiss()

        function triggerAndDismiss() {
            var item = itemsRepeater.itemAt(root.currentIndex)
            if (item && !item.isSeparator) {
                root.selectedIndex = root.currentIndex
                item.menuItem.trigger()
                root.dismissMenu()
            }
        }

        Binding {
            // Make sure the styled frame is in the background
            target: menuFrameLoader.item
            property: "z"
            value: menuMouseArea.z - 1
        }

        MouseArea {
            id: menuMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onExited: root.currentIndex = -1 // TODO Test for any submenu open

            // Each menu item has its own mouse area, and for events to be
            // propagated to the menu mouse area, they need to be embedded.
            Column {
                id: column

                Repeater {
                    id: itemsRepeater
                    model: root.menuItems

                    Loader {
                        id: menuItemLoader

                        property var menuItem: modelData
                        property int contentWidth: column.width
                        property int contentHeight: column.height
                        property bool isSeparator: menuItem ? !menuItem.hasOwnProperty("text") : false
                        property bool hasSubmenu: menuItem ? !!menuItem["menuItems"] : false
                        property bool selected: !isSeparator && root.currentIndex === index

                        sourceComponent: menuFrameLoader.menuItemStyle
                        enabled: !isSeparator && !!menuItem && menuItem.enabled

                        MouseArea {
                            id: itemMouseArea
                            width: menuFrameLoader.width
                            height: parent.height
                            y: menuItemLoader.item ? menuItemLoader.item.y : 0 // Adjust mouse area for style offset
                            hoverEnabled: true

                            onClicked: {
                                if (hasSubmenu)
                                    menuItem.closeMenu()
                                menuFrameLoader.triggerAndDismiss()
                            }

                            onEntered: {
                                if (menuItemLoader.hasSubmenu && !menuItem.popupVisible)
                                    openMenuTimer.start()
                            }

                            onExited: {
                                if (!pressed && menuItemLoader.hasSubmenu)
                                    closeMenuTimer.start()
                            }

                            onPositionChanged: root.currentIndex = index

                            Connections {
                                target: menuMouseArea
                                onEntered: {
                                    if (!itemMouseArea.containsMouse && menuItemLoader.hasSubmenu)
                                        closeMenuTimer.start()
                                }
                            }
                        }

                        Timer {
                            id: openMenuTimer
                            interval: 50
                            onTriggered: {
                                if (itemMouseArea.containsMouse)
                                    menuItem.showPopup(menuFrameLoader.subMenuXPos, 0, -1, menuItemLoader)
                            }
                        }

                        Timer {
                            id: closeMenuTimer
                            interval: 1
                            onTriggered: {
                                if (menuMouseArea.containsMouse && !itemMouseArea.pressed && !itemMouseArea.containsMouse)
                                    menuItem.closeMenu()
                            }
                        }

                        Binding {
                            target: menuItem
                            property: "__visualItem"
                            value: menuItemLoader
                        }
                    }
                }

                onWidthChanged: {
                    for (var i = 0; i < children.length; i++) {
                        var item = children[i]["item"]
                        if (item)
                            item.implicitWidth = Math.max(root.minimumWidth, implicitWidth)
                    }
                }
            }
        }
    }
}
