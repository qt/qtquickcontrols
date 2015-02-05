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

Item {
    id: container
    width: 300; height: 300

TestCase {
    id: testCase
    name: "Tests_TextField"
    when: windowShown
    width: 400
    height: 400

    function test_text() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', testCase, '')

        compare(textfield.text, "")
        textfield.text = "hello world"
        compare(textfield.text, "hello world")
        textfield.destroy()
    }

    function test_maximumLength() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', testCase, '')

        textfield.text = "hello world"
        textfield.maximumLength = 5
        compare(textfield.text, "hello")
        textfield.destroy()
    }

    function test_length() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', testCase, '')

        textfield.text = "hello world"
        compare(textfield.length, 11)
        textfield.destroy()
    }


    function test_readonly() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        compare(textfield.readOnly, false)
        textfield.text = "hello"
        textfield.readOnly = true
        keyPress(Qt.Key_9)
        compare(textfield.text,"hello")
        textfield.destroy()
    }

    function test_inputMask() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container , '')
        textfield.forceActiveFocus()

        // +/- not required, 1 digit required, 1 aphabetic character required and 2 digits not required
        textfield.inputMask = "#9A00"

        keyPress(Qt.Key_Minus)
        compare(textfield.text,"-")
        compare(textfield.acceptableInput, false)

        keyPress(Qt.Key_9)
        compare(textfield.text,"-9")
        compare(textfield.acceptableInput, false)

        keyPress(Qt.Key_B)
        compare(textfield.text,"-9b")
        compare(textfield.acceptableInput, true)

        keyPress(Qt.Key_1)
        compare(textfield.text,"-9b1")
        compare(textfield.acceptableInput, true)

        keyPress(Qt.Key_1)
        compare(textfield.text,"-9b11")
        compare(textfield.acceptableInput, true)

        keyPress(Qt.Key_Backspace)
        keyPress(Qt.Key_Backspace)
        keyPress(Qt.Key_Backspace)
        compare(textfield.text,"-9")
        compare(textfield.acceptableInput, false)

        keyPress(Qt.Key_3)
        compare(textfield.acceptableInput, false)
        compare(textfield.text,"-93")
        textfield.destroy()
    }

    function test_validator() {
        var textfield = Qt.createQmlObject('import QtQuick 2.2; import QtQuick.Controls 1.2; TextField {validator: RegExpValidator { regExp: /(red|blue|green)?/; }}', testCase, '')

        textfield.text = "blu"
        compare(textfield.acceptableInput, false)

        textfield.text = "blue"
        compare(textfield.acceptableInput, true)

        textfield.text = "bluee"
        compare(textfield.acceptableInput, false)
        textfield.destroy()
    }

    function test_selectAll() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.selectAll();

        keyPress(Qt.Key_Delete)
        compare(textfield.text, "")
        textfield.destroy()
    }

    function test_remove() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"

        textfield.remove(0, 5);
        compare(textfield.text, "is my text")
        textfield.remove(2, 5);
        compare(textfield.text, "is text")
        textfield.remove(2, 7);
        compare(textfield.text, "is")

        textfield.destroy()
    }

    function test_select() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.select(5, 8);

        compare(textfield.selectionEnd, 8)
        compare(textfield.selectionStart, 5)
        compare(textfield.selectedText, "is ")
        keyPress(Qt.Key_Delete)
        compare(textfield.text, "this my text")
        textfield.destroy()
    }

    function test_cursorPosition() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        compare(textfield.cursorPosition, 0)
        keyPress(Qt.Key_M)
        compare(textfield.cursorPosition, 1)
        keyPress(Qt.Key_Y)
        compare(textfield.cursorPosition, 2)

        textfield.cursorPosition = 1
        keyPress(Qt.Key_A)
        compare(textfield.text, "may")
        textfield.destroy()
    }

    function test_selectWord() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.selectWord();
        compare(textfield.selectedText, "text")
        textfield.cursorPosition = 2
        textfield.selectWord();
        compare(textfield.selectedText, "this")
        textfield.destroy()
    }

    function test_copyPaste() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', testCase, '')
        textfield.text = "this is my text"
        textfield.select(0, 5)
        textfield.copy()
        textfield.cursorPosition = 0
        textfield.paste()
        compare(textfield.text, "this this is my text")
        textfield.destroy()
    }

    function test_getText() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        var gettext = textfield.getText(0, 4)
        compare(gettext, "this")
        textfield.destroy()
    }

    function test_insert() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.insert(8, "not ")
        compare(textfield.text, "this is not my text")
        textfield.destroy()
    }

    function test_deselect() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.selectWord();
        textfield.deselect()
        compare(textfield.selectedText, "")
        textfield.destroy()
    }

    function test_undo() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.insert(8, "not ")
        compare(textfield.canUndo, true)
        textfield.undo()
        compare(textfield.text, "this is my text")
        textfield.destroy()
    }

    function test_redo() {
        var textfield = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {}', container, '')
        textfield.forceActiveFocus()

        textfield.text = "this is my text"
        textfield.insert(8, "not ")
        textfield.undo()
        compare(textfield.canRedo, true)
        textfield.redo()
        compare(textfield.text, "this is not my text")
        textfield.destroy()
    }

    function test_activeFocusOnPress(){
        var control = Qt.createQmlObject('import QtQuick.Controls 1.2; TextField {x: 20; y: 20; width: 100; height: 50}', container, '')
        control.activeFocusOnPress = false
        verify(!control.activeFocus)
        mouseClick(control, 30, 30)
        verify(!control.activeFocus)
        control.activeFocusOnPress = true
        verify(!control.activeFocus)
        mouseClick(control, 30, 30)
        verify(control.activeFocus)
        control.destroy()
    }

    function test_setFontsize(){
        var control = Qt.createQmlObject('import QtQuick.Controls 1.2; import QtQuick.Controls.Styles 1.1; TextField {style:TextFieldStyle{}}', container, '')
        var width = control.width;
        var height = control.height;
        control.font.pixelSize = 40
        verify(control.width > width) // ensure that the text field resizes
        verify(control.height > height)
        control.destroy()
    }

    function test_activeFocusOnTab() {
        // Set TextField readonly so the tab/backtab can be tested toward the navigation
        var test_control = 'import QtQuick 2.2; \
        import QtQuick.Controls 1.2;            \
        Item {                                  \
            width: 200;                         \
            height: 200;                        \
            property alias control1: _control1; \
            property alias control2: _control2; \
            property alias control3: _control3; \
            TextField  {                         \
                y: 20;                          \
                id: _control1;                  \
                activeFocusOnTab: true;         \
                text: "control1";               \
                readOnly: true                  \
            }                                   \
            TextField  {                         \
                y: 70;                          \
                id: _control2;                  \
                activeFocusOnTab: false;        \
                text: "control2";               \
                readOnly: true                  \
            }                                   \
            TextField  {                         \
                y: 120;                         \
                id: _control3;                  \
                activeFocusOnTab: true;         \
                text: "control3";               \
                readOnly: true                  \
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

    function test_editingFinished() {
        var component = Qt.createComponent("textfield/tf_editingfinished.qml")
        compare(component.status, Component.Ready)
        var test =  component.createObject(container);
        verify(test !== null, "test control created is null")
        var control1 = test.control1
        verify(control1 !== null)
        var control2 = test.control2
        verify(control2 !== null)

        control1.forceActiveFocus()
        verify(control1.activeFocus)
        verify(!control2.activeFocus)

        verify(control1.myeditingfinished === false)
        verify(control2.myeditingfinished === false)

        keyPress(Qt.Key_Tab)
        verify(!control1.activeFocus)
        verify(control2.activeFocus)
        verify(control1.myeditingfinished === true)

        keyPress(Qt.Key_Enter)
        verify(!control1.activeFocus)
        verify(control2.activeFocus)
        verify(control2.myeditingfinished === true)

        test.destroy()
    }

    function test_keys() {
        var component = Qt.createComponent("textfield/tf_keys.qml")
        compare(component.status, Component.Ready)
        var test =  component.createObject(container);
        verify(test !== null, "test control created is null")
        var control1 = test.control1
        verify(control1 !== null)

        control1.forceActiveFocus()
        verify(control1.activeFocus)

        verify(control1.gotit === false)
        verify(control1.text === "")

        keyPress(Qt.Key_A)
        verify(control1.activeFocus)
        verify(control1.gotit === false)
        verify(control1.text === "a")

        keyPress(Qt.Key_B)
        verify(control1.activeFocus)
        verify(control1.gotit === true)
        verify(control1.text === "a")

        keyPress(Qt.Key_B)
        verify(control1.activeFocus)
        verify(control1.gotit === true)
        verify(control1.text === "ab")

        test.destroy()
    }

    function test_passwordCharacter() {
        var textfield = Qt.createQmlObject('import QtQuick 2.2; \
            import QtQuick.Controls 1.3;                        \
            import QtQuick.Controls.Styles 1.1;                 \
            TextField {                                         \
                style: TextFieldStyle {                         \
                    passwordCharacter: "+"                      \
                }                                               \
                echoMode: TextInput.Password                    \
        }', container, '')
        textfield.forceActiveFocus()

        textfield.text = "foo"
        compare(textfield.displayText, "+++")
    }
}
}
