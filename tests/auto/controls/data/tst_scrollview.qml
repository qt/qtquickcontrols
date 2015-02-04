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
import QtQuickControlsTests 1.0

Item {
    id: container
    width: 400
    height: 400

TestCase {
    id: testCase
    name: "Tests_ScrollView"
    when:windowShown
    width:400
    height:400


    TextArea { id: textArea }

    Item { id: bigItem  }

    Component {
        id: scrollViewComponent
        ScrollView { }
    }

    function test_scroll() {
        var component = scrollViewComponent
        var scrollView = component.createObject(testCase);
        verify(scrollView !== null, "table created is null")

        scrollView.contentItem = bigItem
        scrollView.visible = true
        verify(scrollView.flickableItem !== null, "flickableItem should not be null")
        verify(scrollView.flickableItem !== scrollView.contentItem)
        verify(scrollView.flickableItem.contentHeight === 0, "ContentHeight not set")

        bigItem.height = 222
        bigItem.width = 333

        verify(scrollView.flickableItem.contentHeight === 222, "ContentHeight not set")
        verify(scrollView.flickableItem.contentWidth === 333, "ContentHeight not set")

        scrollView.flickableItem.contentY = 200
        verify(scrollView.flickableItem.contentY === 200, "ContentY not set")

        scrollView.flickableItem.contentX = 300
        verify(scrollView.flickableItem.contentX === 300, "ContentX not set")
        scrollView.destroy()
    }


    function test_scrollbars() {
        var component = scrollViewComponent
        var scrollView = component.createObject(testCase);
        scrollView.contentItem = bigItem
        scrollView.parent = container

        bigItem.height = 100
        bigItem.width = 100

        verify(!scrollView.__horizontalScrollBar.visible, "Scrollbar showing when contents already fit")
        verify(!scrollView.__verticalScrollBar.visible, "Scrollbar showing when contents already fit")

        bigItem.height = 1000
        bigItem.width = 1000

        verify(scrollView.__horizontalScrollBar.visible, "Scrollbar not showing when contents are too big")
        verify(scrollView.__verticalScrollBar.visible, "Scrollbar not showing when contents are too big")

        //always off
        bigItem.height = 1000
        scrollView.verticalScrollBarPolicy = Qt.ScrollBarAlwaysOff
        verify(!scrollView.__verticalScrollBar.visible, "Scrollbar showing when disabled")
        bigItem.height = 100
        verify(!scrollView.__verticalScrollBar.visible, "Scrollbar showing when disabled")

        //always on
        scrollView.verticalScrollBarPolicy = Qt.ScrollBarAlwaysOn
        bigItem.height = 1000
        verify(scrollView.__verticalScrollBar.visible, "Scrollbar not showing when forced on")
        bigItem.height = 100
        verify(scrollView.__verticalScrollBar.visible, "Scrollbar not showing when forced on")

        scrollView.destroy()
    }

    function test_clickToCenter() {

        var test_control = 'import QtQuick 2.2;                       \
        import QtQuick.Controls 1.2;                                  \
        import QtQuick.Controls.Styles 1.1;                           \
        ScrollView {                                                  \
            id: _control1;                                            \
            width: 100 ; height: 100;                                 \
            Item { width: 200; height: 200 }                          \
            activeFocusOnTab: true;                                   \
            style:ScrollViewStyle{                                    \
                   handle: Item {width: 16 ; height: 16}              \
                   scrollBarBackground: Item {width: 16 ; height: 16} \
                   incrementControl: Item {width: 16 ; height: 16}    \
                   decrementControl: Item {width: 16 ; height: 16}}   }'

        var scrollView = Qt.createQmlObject(test_control, container, '')
        verify(scrollView !== null, "view created is null")
        verify(scrollView.flickableItem.contentY === 0)

        mouseClick(scrollView, scrollView.width -2, scrollView.height/2, Qt.LeftButton)
        verify(Math.round(scrollView.flickableItem.contentY) === 100)

        verify(scrollView.flickableItem.contentX === 0)
        mouseClick(scrollView, scrollView.width/2, scrollView.height - 2, Qt.LeftButton)
        verify(Math.round(scrollView.flickableItem.contentX) === 100)
    }

    function test_viewport() {
        var component = scrollViewComponent
        var scrollView =  component.createObject(testCase);
        verify(scrollView !== null, "table created is null")

        scrollView.forceActiveFocus();
        verify(scrollView.viewport, "Viewport not defined")
        verify(!scrollView.contentItem, "contentItem should be null")
        verify(!scrollView.flickableItem, "flickableItem should be null")
        verify(!scrollView.frameVisible, "Frame should be false")

        scrollView.contentItem = textArea
        verify(scrollView.viewport, "Viewport should be defined")
        verify(scrollView.contentItem, "contentItem should not be null")
        verify(scrollView.flickableItem, "flickableItem should not be null")
        verify(scrollView.flickableItem.contentHeight === textArea.height, "Content height not set")

        var prevViewportWidth  = scrollView.viewport.width
        scrollView.frameVisible = true
        verify(scrollView.frameVisible, "Frame should be true")
        verify(scrollView.viewport.width < prevViewportWidth, "Viewport should be smaller with frame")
        scrollView.destroy()
    }

    function test_activeFocusOnTab() {
        if (Qt.styleHints.tabFocusBehavior != Qt.TabFocusAllControls)
            skip("This function doesn't support NOT iterating all.")

        var test_control = 'import QtQuick 2.2; \
    import QtQuick.Controls 1.2;            \
    Item {                                  \
        width: 200;                         \
        height: 200;                        \
        property alias control1: _control1; \
        property alias control2: _control2; \
        property alias control3: _control3; \
        ScrollView {                        \
            id: _control1;                  \
            activeFocusOnTab: true;         \
        }                                   \
        ScrollView {                        \
            id: _control2;                  \
            activeFocusOnTab: false;        \
        }                                   \
        ScrollView {                        \
            id: _control3;                  \
            activeFocusOnTab: true;         \
        }                                   \
    }                                       '

        var control = Qt.createQmlObject(test_control, container, '')
        control.control1.forceActiveFocus()
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(!control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(control.control3.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)

        control.control2.activeFocusOnTab = true
        control.control3.activeFocusOnTab = false
        keyPress(Qt.Key_Tab)
        verify(!control.control1.activeFocus)
        verify(control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(!control.control1.activeFocus)
        verify(control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        keyPress(Qt.Key_Tab, Qt.ShiftModifier)
        verify(control.control1.activeFocus)
        verify(!control.control2.activeFocus)
        verify(!control.control3.activeFocus)
        control.destroy()
    }
}
}
