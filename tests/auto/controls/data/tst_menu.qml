/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtTest 1.0
import QtQuick.Controls 1.2

TestCase {
    id: testcase
    name: "Tests_Menu"
    when: windowShown
    width: 300; height: 300

    property var itemsText: [ "apple", "banana", "clementine", "dragon fruit" ]

    property var menu
    property var menuItem

    SignalSpy {
        id: menuSpy
        target: testcase.menu
        signalName: "__selectedIndexChanged"
    }

    SignalSpy {
        id: menuItemSpy
        target: testcase.menuItem
        signalName: "triggered"
    }

    Component {
        id: creationComponent
        Menu {
            MenuItem { text: "apple" }
            MenuItem { text: "banana" }
            MenuItem { text: "clementine" }
            MenuItem { text: "dragon fruit" }
        }
    }

    function init() {
        menu = creationComponent.createObject(testcase)
    }

    function cleanup() {
        menuSpy.clear()
        menuItemSpy.clear()
        if (menu !== 0)
            menu.destroy()
    }

    function test_creation() {
        compare(menu.items.length, testcase.itemsText.length)
        for (var i = 0; i < menu.items.length; i++)
            compare(menu.items[i].text, testcase.itemsText[i])
    }

    Component {
        id: modelCreationComponent
        Menu {
            id: modelMenu
            Instantiator {
                model: itemsText
                MenuItem {
                    text: modelData
                }
                onObjectAdded: modelMenu.insertItem(index, object)
            }

        }
    }

    function test_modelCreation() {
        var menu = modelCreationComponent.createObject(testcase)
        compare(menu.items.length, testcase.itemsText.length)
        for (var i = 0; i < menu.items.length; i++)
            compare(menu.items[i].text, testcase.itemsText[i])
        menu.destroy()
    }

    function test_trigger() {
        menuItem = menu.items[2]
        menuItem.trigger()

        compare(menuItemSpy.count, 1)
        compare(menuSpy.count, 1)
        compare(menu.__selectedIndex, 2)
    }

    function test_check() {
        for (var i = 0; i < menu.items.length; i++)
            menu.items[i].checkable = true

        menuItem = menu.items[2]
        compare(menuItem.checkable, true)
        compare(menuItem.checked, false)
        menuItem.trigger()

        for (i = 0; i < menu.items.length; i++)
            compare(menu.items[i].checked, i === 2)

        menuItem = menu.items[3]
        compare(menuItem.checkable, true)
        compare(menuItem.checked, false)
        menuItem.trigger()

        for (i = 0; i < menu.items.length; i++)
            compare(menu.items[i].checked, i === 2 || i === 3)

        compare(menuItemSpy.count, 2)
        compare(menuSpy.count, 2)
        compare(menu.__selectedIndex, 3)
    }

    ExclusiveGroup { id: eg }

    function test_exclusive() {
        for (var i = 0; i < menu.items.length; i++) {
            menu.items[i].checkable = true
            menu.items[i].exclusiveGroup = eg
        }

        menuItem = menu.items[2]
        compare(menuItem.checkable, true)
        compare(menuItem.checked, false)
        menuItem.trigger()

        for (i = 0; i < menu.items.length; i++)
            compare(menu.items[i].checked, i === 2)

        menuItem = menu.items[3]
        compare(menuItem.checkable, true)
        compare(menuItem.checked, false)
        menuItem.trigger()

        for (i = 0; i < menu.items.length; i++)
            compare(menu.items[i].checked, i === 3)

        compare(menuItemSpy.count, 2)
        compare(menuSpy.count, 2)
        compare(menu.__selectedIndex, 3)
    }

    function test___selectedIndex() {
        for (var i = 0; i < menu.items.length; i++)
            menu.items[i].checkable = true

        menu.__selectedIndex = 3
        compare(menu.__selectedIndex, 3)
        verify(!menu.items[menu.__selectedIndex].checked)

        menu.items[2].trigger()
        compare(menu.__selectedIndex, 2)
        verify(menu.items[menu.__selectedIndex].checked)
    }

    function test_dynamicItems() {
        menu.clear()
        compare(menu.items.length, 0)
        var n = 6
        var separatorIdx = 4
        var submenuIdx = 5
        for (var i = 0; i < n; ++i) {
            if (i === separatorIdx)
                var item = menu.addSeparator()
            else if (i === submenuIdx)
                item = menu.addMenu("Submenu")
            else
                item = menu.addItem("Item " + i)
        }
        compare(menu.items.length, n)

        for (i = 0; i < n; ++i) {
            item = menu.items[i]
            compare(item.type, i === submenuIdx ? MenuItemType.Menu :
                               i === separatorIdx ? MenuItemType.Separator :
                                                    MenuItemType.Item)
            if (i === submenuIdx)
                compare(item.title, "Submenu")
            else if (i !== separatorIdx)
                compare(item.text, "Item " + i)
        }
    }
}
