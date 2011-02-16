/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components API Conformance Test Suite.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import QtQuick 1.0
import QtQuickTest 1.0

ComponentTestCase {
    name: "TextField"

    SpecTextField {
        id: testSubject
    }

    function test_font() {
        var message =
            "When defining the font, TextField should pick a system font of the same family.";
        obj.font = "Helvetica";
        verify(obj.font.family.match("^Helvetica"), message);
    }

    function test_cursorPosition() {
        var message =
            "When setting some text, the cursor should be positioned at the end of this text.";
        obj.text = "Test123";
        compare(obj.cursorPosition, 7, message);

        message =
            "Defining the cursor position to a number smaller than the text size should " +
            "always be considered valid.";
        obj.cursorPosition = 5;
        compare(obj.cursorPosition, 5, message);

        message =
            "If the the cursor position is set to a value longer then the current text size, " +
            "the cursorPosition should keep the current value.";
        obj.cursorPosition = 20;
        compare(obj.cursorPosition, 5, message);

        var message =
            "Cursor position should be added by one after each character input.";
        obj.forceActiveFocus();
        var pos = obj.cursorPosition;
        keyClick(Qt.Key_T);
        keyClick(Qt.Key_E);
        keyClick(Qt.Key_S);
        keyClick(Qt.Key_T);
        compare(obj.cursorPosition, pos + 4, message);
    }

    function test_readOnly() {
        var message =
            "Setting readOnly to true should prevent any modification in the text property.";
        obj.text = "Test123";
        obj.readOnly = true;
        obj.text = "123Test";
        expectFail("", message); // XXX: See QTBUG-15257
        compare(obj.text, "Test123", message);
        obj.text = "";
        compare(obj.text, "Test123", message);

        message =
            "Setting readOnly to false should allow modifications in the text property.";
        obj.readOnly = false;
        obj.text = "123Test";
        compare(obj.text, "123Test", message);
    }

    function test_select() {}
    function test_selectWord() {}
    function test_selectAll() {}
    function test_selectionStart() {}
    function test_selectionEnd() {}
    function test_selectedText() {
        var message =
            "Calling select() method using a valid text range should set selectedText to the " +
            "text within this range. selectionStart and selectionEnd should also be " +
            "updated properly.";
        obj.text = "Test 1234";
        obj.select(0, 4);
        compare(obj.selectedText, "Test", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, 4, message);
        obj.select(5, 9);
        compare(obj.selectedText, "1234", message);
        compare(obj.selectionStart, 5, message);
        compare(obj.selectionEnd, 9, message);
        obj.select(0, 9);
        compare(obj.selectedText, "Test 1234", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, 9, message);
        obj.select(5, 5);
        compare(obj.selectedText, "", message);
        compare(obj.selectionStart, 5, message);
        compare(obj.selectionEnd, 5, message);
        obj.select(0, 0);
        compare(obj.selectedText, "", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, 0, message);

        message =
            "Using select() with an invalid range (i.e beyond the text size) should keep " +
            "the previous valid selectedText and range. In other words, should do nothing.";
        obj.text = "Test 1234";
        obj.select(0, 20);
        compare(obj.selectedText, "", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, 0, message);
        obj.select(0, 4);
        obj.select(0, 50);
        compare(obj.selectedText, "Test", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, 4, message);

        message =
            "Using selectAll() should select the entiry text, ranging from zero to length.";
        obj.text = "Test 1234";
        obj.selectAll();
        compare(obj.selectedText, "Test 1234", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, obj.text.length, message);

        message =
            "selectWord() will select the first word nearest to the cursor position. If " +
            "a word is partially selected, it should select this word. If more than one word are " +
            "selected, it should select the last word (because in this situation, the cursor is " + 
            "positioned in the end of the selection).";
        obj.text = "Test 1234 ABC";
        obj.cursorPosition = 0;
        obj.selectWord();
        compare(obj.selectedText, "Test", message);
        obj.select(5, 7);
        obj.selectWord();
        compare(obj.selectedText, "1234", message);
        obj.selectAll();
        obj.selectWord();
        compare(obj.selectedText, "ABC", message);

        message =
            "If text property is changed when some text is selected, selection should reset " +
            "to nothing.";
        obj.text = "Test 123";
        obj.selectAll();
        obj.text = "ABC";
        compare(obj.selectedText, "", message);
        compare(obj.selectionStart, 0, message);
        compare(obj.selectionEnd, 0, message);

        message =
            "Moving the cursor by pressing arrow keys should remove text selection.";
        obj.forceActiveFocus();
        obj.text = "Test 123";
        obj.selectAll();
        keyClick(Qt.Key_Left);
        compare(obj.selectedText, "", message);
    }

    function test_text() {
        var message =
            "Focused TextInput should handle key input and change the contents of text " +
            "property accordingly. This test is closely related with focus and might fail " +
            "if forceActiveFocus() is not working properly.";
        obj.forceActiveFocus();
        obj.text = "";
        keyClick(Qt.Key_T);
        keyClick(Qt.Key_E);
        keyClick(Qt.Key_S);
        keyClick(Qt.Key_T);
        compare(obj.text, "test", message);
        keyClick(Qt.Key_Backspace);
        compare(obj.text, "tes", message);
        obj.text = "";
        compare(obj.text, "", message);
    }

    function test_copy() {}
    function test_cut() {}
    function test_paste() {
        var message =
            "Cutting a selected text should remove the text from TextInput and store " +
            "the clipboard.";
        obj.text = "Test 123";
        obj.selectAll();
        obj.cut();
        compare(obj.text, "", message);

        var message =
            "This test verifies the if pasting the clipboard content on an empty " +
            "TextInput works.";
        obj.paste();
        compare(obj.text, "Test 123", message);

        var message =
            "Copy should copy the selected area to clipboard without removing from " +
            "TextInput. By pasting when some text is selected, should overwrite it's " +
            "contents.";
        obj.select(0, 4);
        obj.copy();
        obj.select(4, 8);
        obj.paste();
        compare(obj.text, "TestTest", message);

        var message =
            "Pasting the clipboard contents when the cursor is positionated on the end " +
            "of the TextInput should append to the current content. It assumes that the " +
            "previous tests sets the position of the cursor to the end of the line.";
        obj.paste();
        compare(obj.text, "TestTestTest", message);
    }

    function test_positionAt() {}
    function test_positionToRectangle() {
        var message =
            "Testing if positionToRectangle() and positionAt() are coherent, since this " +
            "functional test will not rely on position coordinates and font metrics.";
        obj.text = "Test 123";
        var rect = obj.positionToRectangle(0);
        compare(obj.positionAt(rect.x, rect.y), 0, message);
        var rect = obj.positionToRectangle(5);
        compare(obj.positionAt(rect.x, rect.y), 5, message);
        var rect = obj.positionToRectangle(8);
        compare(obj.positionAt(rect.x, rect.y), 8, message);
    }

    function test_echoMode() {
        var message =
            "Since we can't really verify if by setting an echoMode something is being " +
            "reflected on the UI, this test verifies if all echoMode's are supported.";
        obj.echoMode = TextInput.Password;
        compare(obj.echoMode, TextInput.Password, message);
        obj.echoMode = TextInput.NoEcho;
        compare(obj.echoMode, TextInput.NoEcho, message);
        obj.echoMode = TextInput.PasswordEchoOnEdit;
        compare(obj.echoMode, TextInput.PasswordEchoOnEdit, message);
        obj.echoMode = TextInput.Normal;
        compare(obj.echoMode, TextInput.Normal, message);
    }

    function test_placeholderText() {
        var message =
            "Since we can't really verify if by setting an echoMode something is being " +
            "reflected on the UI, this test verifies if all echoMode's are supported.";
        obj.echoMode = TextInput.Password;
        compare(obj.echoMode, TextInput.Password, message);
        obj.echoMode = TextInput.NoEcho;
        compare(obj.echoMode, TextInput.NoEcho, message);
        obj.echoMode = TextInput.PasswordEchoOnEdit;
        compare(obj.echoMode, TextInput.PasswordEchoOnEdit, message);
        obj.echoMode = TextInput.Normal;
        compare(obj.echoMode, TextInput.Normal, message);
    }

    IntValidator {
        id: validator

        bottom: 0
        top: 400
    }

    function test_acceptableInput() {}
    function test_validator() {
        var message =
            "Setting a validator should immediately validate the current text.";
        compare(obj.acceptableInput, true, message);
        obj.validator = validator;

        var message =
            "All changes on text property or the validator parameters should " +
            "reflect on acceptableInput.";
        compare(obj.acceptableInput, false, message);
        obj.text = "test123";
        compare(obj.acceptableInput, false, message);
        obj.text = "123";
        compare(obj.acceptableInput, true, message);
        validator.top = 100;
        compare(obj.acceptableInput, false, message);

        var message =
            "Removing the validator should set the acceptableInput to true.";
        obj.validator = null;
        compare(obj.acceptableInput, true, message);
    }

    function test_inputMask() {
        var message =
            "Setting a input mask with some existing text should validated the text.";
        obj.text = "Test123";
        obj.inputMask = "aaaaaaa";
        compare(obj.text, "Test", message);
        obj.inputMask = "aaaaaaa";
        compare(obj.text, "Test", message);
        obj.inputMask = "0000000";
        compare(obj.text, "", message);

        var message =
            "Text input should respect the existing mask.";
        obj.text = "";
        obj.inputMask = "AAAA";
        obj.forceActiveFocus();
        keyClick(Qt.Key_T);
        keyClick(Qt.Key_1);
        keyClick(Qt.Key_E);
        keyClick(Qt.Key_2);
        keyClick(Qt.Key_S);
        keyClick(Qt.Key_3);
        keyClick(Qt.Key_T);
        keyClick(Qt.Key_4);
        compare(obj.text, "test", message);
    }
}
