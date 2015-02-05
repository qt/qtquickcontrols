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
    id: testCase
    name: "Tests_StackView"
    when: windowShown
    visible: true
    width: 400
    height: 400

    Item { id: anItem  }
    TextField { id: textField }
    Component {
        id: pageComponent
        Item {}
    }

    Component {
        id: stackComponent
        StackView { }
    }

    function test_stackview() {
        var component = stackComponent
        var stack = component.createObject(testCase);
        verify (stack !== null, "stackview created is null")
        verify (stack.depth === 0)
        stack.push(anItem)
        verify (stack.depth === 1)
        stack.push(anItem)
        verify (stack.depth === 2)
        stack.pop()
        verify (stack.depth === 1)
        stack.push(pageComponent)
        verify (stack.depth === 2)

        var w = stack.width
        testCase.width = w + 333
        compare(stack.width, w)

        stack.destroy()
    }

    function test_focus() {
        var stack = stackComponent.createObject(testCase, {initialItem: anItem, width: testCase.width, height: testCase.height})
        verify (stack !== null, "stackview created is null")
        compare(stack.currentItem, anItem)

        stack.forceActiveFocus()
        verify(stack.activeFocus)

        stack.push({item: textField, immediate: true})
        compare(stack.currentItem, textField)
        textField.forceActiveFocus()
        verify(textField.activeFocus)

        stack.pop({immediate: true})
        compare(stack.currentItem, anItem)
        verify(stack.activeFocus)
        verify(!textField.activeFocus)

        stack.destroy()
    }
}
