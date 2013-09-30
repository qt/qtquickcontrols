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
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Private 1.0

/*!
    \qmltype Menu
    \inqmlmodule QtQuick.Controls
    \since 5.1
    \ingroup menus
    \brief Provides a menu component for use in menu bars, as context menu,
    and other popup menus.

    \code
    Menu {
        title: "Edit"

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
            title: "More Stuff"

            MenuItem {
                text: "Do Nothing"
            }
        }
    }
    \endcode

    The main uses for menus:
    \list
    \li
       as a \e top-level menu in a \l MenuBar
    \li
       as a \e submenu inside another menu
    \li
       as a standalone or \e context menu
    \endlist

    Note that some properties, such as \c enabled, \c text, or \c iconSource,
    only make sense in a particular use case of the menu.

    \sa MenuBar, MenuItem, MenuSeparator
*/

MenuPrivate {
    id: root

    /*! \internal
      \omit
      Documented in qqquickmenu.cpp.
      \endomit
    */
    function addMenu(title) {
        return root.insertMenu(items.length, title)
    }

    /*! \internal
      \omit
      Documented in qquickmenu.cpp.
      \endomit
    */
    function insertMenu(index, title) {
        if (!__selfComponent)
            __selfComponent = Qt.createComponent("Menu.qml", root)
        var submenu = __selfComponent.createObject(__selfComponent, { "title": title })
        root.insertItem(index, submenu)
        return submenu
    }

    /*! \internal */
    property Component __selfComponent: null

    /*! \internal */
    property Component style: Qt.createComponent(Settings.style + "/MenuStyle.qml", root)

    /*! \internal */
    property var __parentContentItem: __parentMenu.__contentItem
    /*! \internal */
    property int __currentIndex: -1
    /*! \internal */
    on__MenuClosed: __currentIndex = -1

    /*! \internal */
    __contentItem: Loader {
        sourceComponent: __menuComponent
        active: !root.__isNative && root.__popupVisible
        focus: true
        Keys.forwardTo: item ? [item, root.__parentContentItem] : []
        property bool altPressed: root.__parentContentItem ? root.__parentContentItem.altPressed : false
    }

    /*! \internal */
    property Component __menuComponent: Loader {
        id: menuFrameLoader

        readonly property Style __style: styleLoader.item
        readonly property Component menuItemStyle: __style ? __style.menuItem : null

        readonly property var control: root
        property alias contentWidth: content.width
        property alias contentHeight: content.height

        readonly property int subMenuXPos: width + (item && item["subMenuOverlap"] || 0)

        visible: status === Loader.Ready
        sourceComponent: __style ? __style.frame : undefined

        Loader {
            id: styleLoader
            active: !root.isNative
            sourceComponent: root.style
            property alias __control: menuFrameLoader
            onStatusChanged: {
                if (status === Loader.Error)
                    console.error("Failed to load Style for", root)
            }
        }

        focus: true
        property var mnemonicsMap: ({})

        Keys.onPressed: {
            var item = null
            if (!(event.modifiers & Qt.AltModifier)
                && (item = mnemonicsMap[event.text.toUpperCase()])) {
                if (item.isSubmenu) {
                    root.__currentIndex = item.menuItemIndex
                    item.showSubMenu(true)
                    item.menuItem.__currentIndex = 0
                } else {
                    triggerAndDismiss(item)
                }
                event.accepted = true
            } else {
                event.accepted = false
            }
        }

        Keys.onEscapePressed: root.__dismissMenu()

        Keys.onDownPressed: {
            if (root.__currentIndex < 0)
                root.__currentIndex = -1

            for (var i = root.__currentIndex + 1;
                 i < root.items.length && !canBeHovered(i); i++)
                ;
            event.accepted = true
        }

        Keys.onUpPressed: {
            for (var i = root.__currentIndex - 1;
                 i >= 0 && !canBeHovered(i); i--)
                ;
            event.accepted = true
        }

        function canBeHovered(index) {
            var item = content.menuItemAt(index)
            if (item && !item["isSeparator"] && item.enabled) {
                root.__currentIndex = index
                return true
            }
            return false
        }

        Keys.onLeftPressed: {
            if ((event.accepted = root.__parentMenu.hasOwnProperty("title")))
                __closeMenu()
        }

        Keys.onRightPressed: {
            var item = content.menuItemAt(root.__currentIndex)
            if ((event.accepted = (item && item.isSubmenu))) {
                item.showSubMenu(true)
                item.menuItem.__currentIndex = 0
            }
        }

        Keys.onSpacePressed: triggerCurrent()
        Keys.onReturnPressed: triggerCurrent()
        Keys.onEnterPressed: triggerCurrent()

        function triggerCurrent() {
            var item = content.menuItemAt(root.__currentIndex)
            if (item)
                content.triggered(item)
        }

        function triggerAndDismiss(item) {
            if (item && !item.isSeparator) {
                root.__dismissMenu()
                if (!item.isSubmenu)
                    item.menuItem.trigger()
            }
        }

        Binding {
            // Make sure the styled frame is in the background
            target: item
            property: "z"
            value: content.z - 1
        }

        ColumnMenuContent {
            id: content
            menuItemDelegate: menuItemComponent
            scrollerStyle: __style ? __style.scrollerStyle : undefined
            itemsModel: root.items
            margin: menuFrameLoader.item ? menuFrameLoader.item.margin : 0
            minWidth: root.__minimumWidth
            maxHeight: menuFrameLoader.item ? menuFrameLoader.item.maxHeight : 0
            onTriggered: triggerAndDismiss(item)
        }

        Component {
            id: menuItemComponent
            Loader {
                id: menuItemLoader

                property var menuItem: modelData
                readonly property bool isSeparator: !!menuItem && menuItem.type === MenuItemType.Separator
                readonly property bool isSubmenu: !!menuItem && menuItem.type === MenuItemType.Menu
                property bool selected: !(isSeparator || !!scrollerDirection) && root.__currentIndex === index
                property string text: isSubmenu ? menuItem.title : !(isSeparator || !!scrollerDirection) ? menuItem.text : ""
                property bool showUnderlined: __contentItem.altPressed
                readonly property var scrollerDirection: menuItem["scrollerDirection"]

                property int menuItemIndex: index

                sourceComponent: menuFrameLoader.menuItemStyle
                enabled: visible && !isSeparator && !!menuItem && menuItem.enabled
                visible: menuItem.visible
                active: visible

                function showSubMenu(immediately) {
                    if (immediately) {
                        if (root.__currentIndex === menuItemIndex)
                            menuItem.__popup(menuFrameLoader.subMenuXPos, 0, -1)
                    } else {
                        openMenuTimer.start()
                    }
                }

                Timer {
                    id: openMenuTimer
                    interval: 50
                    onTriggered: menuItemLoader.showSubMenu(true)
                }

                function closeSubMenu() { closeMenuTimer.start() }

                Timer {
                    id: closeMenuTimer
                    interval: 1
                    onTriggered: {
                        if (root.__currentIndex !== menuItemIndex)
                            menuItem.__closeMenu()
                    }
                }

                onLoaded: {
                    menuItem.__visualItem = menuItemLoader

                    if (content.width < item.implicitWidth)
                        content.width = item.implicitWidth

                    var title = text
                    var ampersandPos = title.indexOf("&")
                    if (ampersandPos !== -1)
                        menuFrameLoader.mnemonicsMap[title[ampersandPos + 1].toUpperCase()] = menuItemLoader
                }

                Binding {
                    target: menuItemLoader.item
                    property: "width"
                    value: Math.max(root.__minimumWidth, content.width)
                }
            }
        }
    }
}
