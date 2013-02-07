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
import QtDesktop.Private 1.0
/*!
    \qmltype TextArea
    \inqmlmodule QtDesktop 1.0
    \brief TextArea displays multiple lines of editable formatted text.

    It can display both plain and rich text. For example:

    \qml
    TextArea {
        width: 240
        text: "<b>Hello</b> <i>World!</i>"
        focus: true
    }
    \endqml

    Setting \l {Item::focus}{focus} to \c true enables the TextEdit item to receive keyboard focus.

    Clipboard support is provided by the cut(), copy(), and paste() functions, and the selection can
    be handled in a traditional "mouse" mechanism by setting selectByMouse, or handled completely
    from QML by manipulating selectionStart and selectionEnd, or using selectAll() or selectWord().

    You can translate between cursor positions (characters from the start of the document) and pixel
    points using positionAt() and positionToRectangle().

    \sa TextField, TextEdit
*/

ScrollArea {
    id: area

    /*!
        \qmlproperty bool TextArea::::activeFocusOnPress

        Whether the TextEdit should gain active focus on a mouse press. By default this is
        set to true.
    */
    property alias activeFocusOnPress: edit.activeFocusOnPress

    /*!
        \qmlproperty url TextArea::::baseUrl

        This property specifies a base URL which is used to resolve relative URLs
        within the text.

        The default value is the url of the QML file instantiating the TextEdit item.
    */
    property alias baseUrl: edit.baseUrl

    /*!
        \qmlproperty bool TextArea::::canPaste

        Returns true if the TextEdit is writable and the content of the clipboard is
        suitable for pasting into the TextEdit.
    */
    property alias canPaste: edit.canPaste

    /*!
        \qmlproperty bool TextArea::::canRedo

        Returns true if the TextEdit is writable and there are \l {undo}{undone}
        operations that can be redone.
    */
    property alias canRedo: edit.canRedo

    /*!
        \qmlproperty bool TextArea::::canUndo

        Returns true if the TextEdit is writable and there are previous operations
        that can be undone.
    */
    property alias canUndo: edit.canUndo

    /*!
        \qmlproperty color TextArea::::color

        The text color.

        \qml
        // green text using hexadecimal notation
        TextEdit { color: "#00FF00" }
        \endqml

        \qml
        // steelblue text using SVG color name
        TextEdit { color: "steelblue" }
        \endqml
    */
    property alias color: edit.color

    /*!
        \qmlproperty Component TextArea::cursorDelegate
        The delegate for the cursor in the TextEdit.

        If you set a cursorDelegate for a TextEdit, this delegate will be used for
        drawing the cursor instead of the standard cursor. An instance of the
        delegate will be created and managed by the text edit when a cursor is
        needed, and the x and y properties of delegate instance will be set so as
        to be one pixel before the top left of the current character.

        Note that the root item of the delegate component must be a QQuickItem or
        QQuickItem derived item.
    */
    property alias cursorDelegate: edit.cursorDelegate

    /*!
        \qmlproperty int TextArea::cursorPosition
        The position of the cursor in the TextEdit.
    */
    property alias cursorPosition: edit.cursorPosition

    /*!
        \qmlproperty rectangle TextArea::cursorRectangle

        The rectangle where the standard text cursor is rendered
        within the text edit. Read-only.

        The position and height of a custom cursorDelegate are updated to follow the cursorRectangle
        automatically when it changes.  The width of the delegate is unaffected by changes in the
        cursor rectangle.
    */
    property alias cursorRectangle: edit.cursorRectangle

    /*!
        \qmlproperty bool TextArea::cursorVisible
        The document margins of the TextEdit.
    */
    property alias cursorVisible: edit.cursorVisible

    /*!
        \qmlproperty bool TextArea::documentMargins
        If true the text edit shows a cursor.

        This property is set and unset when the text edit gets active focus, but it can also
        be set directly (useful, for example, if a KeyProxy might forward keys to it).
    */

    property int documentMargins: 4

    /*!
        \qmlproperty font TextArea::font

        The font of the TextArea.
    */
    property alias font: edit.font

    /*!
        \qmlproperty enumeration TextArea::horizontalAlignment
        \qmlproperty enumeration TextArea::verticalAlignment
        \qmlproperty enumeration TextArea::effectiveHorizontalAlignment

        Sets the horizontal and vertical alignment of the text within the TextEdit item's
        width and height. By default, the text alignment follows the natural alignment
        of the text, for example text that is read from left to right will be aligned to
        the left.

        Valid values for \c horizontalAlignment are:
        \list
        \li TextEdit.AlignLeft (default)
        \li TextEdit.AlignRight
        \li TextEdit.AlignHCenter
        \li TextEdit.AlignJustify
        \endlist

        Valid values for \c verticalAlignment are:
        \list
        \li TextEdit.AlignTop (default)
        \li TextEdit.AlignBottom
        \li TextEdit.AlignVCenter
        \endlist

        When using the attached property LayoutMirroring::enabled to mirror application
        layouts, the horizontal alignment of text will also be mirrored. However, the property
        \c horizontalAlignment will remain unchanged. To query the effective horizontal alignment
        of TextEdit, use the read-only property \c effectiveHorizontalAlignment.
    */
    property alias horizontalAlignment: edit.horizontalAlignment
    property alias verticalAlignment: edit.verticalAlignment
    property alias effectiveHorizontalAlignment: edit.effectiveHorizontalAlignment

    /*!
        \qmlproperty bool TextArea::inputMethodComposing


        This property holds whether the TextEdit has partial text input from an
        input method.

        While it is composing an input method may rely on mouse or key events from
        the TextEdit to edit or commit the partial text.  This property can be used
        to determine when to disable events handlers that may interfere with the
        correct operation of an input method.
    */
    property alias inputMethodComposing: edit.inputMethodComposing

    /*!
        \qmlproperty enumeration TextArea::inputMethodHints

        Provides hints to the input method about the expected content of the text edit and how it
        should operate.

        The value is a bit-wise combination of flags or Qt.ImhNone if no hints are set.

        Flags that alter behavior are:

        \list
        \li Qt.ImhHiddenText - Characters should be hidden, as is typically used when entering passwords.
        \li Qt.ImhSensitiveData - Typed text should not be stored by the active input method
                in any persistent storage like predictive user dictionary.
        \li Qt.ImhNoAutoUppercase - The input method should not try to automatically switch to upper case
                when a sentence ends.
        \li Qt.ImhPreferNumbers - Numbers are preferred (but not required).
        \li Qt.ImhPreferUppercase - Upper case letters are preferred (but not required).
        \li Qt.ImhPreferLowercase - Lower case letters are preferred (but not required).
        \li Qt.ImhNoPredictiveText - Do not use predictive text (i.e. dictionary lookup) while typing.

        \li Qt.ImhDate - The text editor functions as a date field.
        \li Qt.ImhTime - The text editor functions as a time field.
        \endlist

        Flags that restrict input (exclusive flags) are:

        \list
        \li Qt.ImhDigitsOnly - Only digits are allowed.
        \li Qt.ImhFormattedNumbersOnly - Only number input is allowed. This includes decimal point and minus sign.
        \li Qt.ImhUppercaseOnly - Only upper case letter input is allowed.
        \li Qt.ImhLowercaseOnly - Only lower case letter input is allowed.
        \li Qt.ImhDialableCharactersOnly - Only characters suitable for phone dialing are allowed.
        \li Qt.ImhEmailCharactersOnly - Only characters suitable for email addresses are allowed.
        \li Qt.ImhUrlCharactersOnly - Only characters suitable for URLs are allowed.
        \endlist

        Masks:

        \list
        \li Qt.ImhExclusiveInputMask - This mask yields nonzero if any of the exclusive flags are used.
        \endlist
    */
    property alias inputMethodHints: edit.inputMethodHints

    /*!
        \qmlproperty int TextArea::length

        Returns the total number of plain text characters in the TextEdit item.

        As this number doesn't include any formatting markup it may not be the same as the
        length of the string returned by the \l text property.

        This property can be faster than querying the length the \l text property as it doesn't
        require any copying or conversion of the TextEdit's internal string data.
    */
    property alias length: edit.length

    /*!
        \qmlproperty int TextArea::lineCount

        Returns the total number of lines in the textEdit item.
    */
    property alias lineCount: edit.lineCount

    /*!
        \qmlproperty enumeration TextArea::mouseSelectionMode

        Specifies how text should be selected using a mouse.

        \list
        \li TextEdit.SelectCharacters - The selection is updated with individual characters. (Default)
        \li TextEdit.SelectWords - The selection is updated with whole words.
        \endlist

        This property only applies when \l selectByMouse is true.
    */
    property alias mouseSelectionMode: edit.mouseSelectionMode

    /*!
        \qmlproperty bool TextArea::persistentSelection

        Whether the TextEdit should keep the selection visible when it loses active focus to another
        item in the scene. By default this is set to true;
    */
    property alias persistentSelection: edit.persistentSelection

    /*!
        \qmlproperty bool TextArea::readOnly

        Whether the user can interact with the TextEdit item. If this
        property is set to true the text cannot be edited by user interaction.

        By default this property is false.
    */
    property alias readOnly: edit.readOnly

    /*!
        \qmlproperty enumeration TextArea::renderType

        Override the default rendering type for this component.

        Supported render types are:
        \list
        \li Text.QtRendering - the default
        \li Text.NativeRendering
        \endlist

        Select Text.NativeRendering if you prefer text to look native on the target platform and do
        not require advanced features such as transformation of the text. Using such features in
        combination with the NativeRendering render type will lend poor and sometimes pixelated
        results.
    */
    property alias renderType: edit.renderType

    /*!
        \qmlproperty bool TextArea::selectByMouse

        Defaults to false.

        If true, the user can use the mouse to select text in some
        platform-specific way. Note that for some platforms this may
        not be an appropriate interaction (eg. may conflict with how
        the text needs to behave inside a Flickable.
    */
    property alias selectByMouse: edit.selectByMouse

    /*!
        \qmlproperty string TextArea::selectedText

        This read-only property provides the text currently selected in the
        text edit.

        It is equivalent to the following snippet, but is faster and easier
        to use.
        \code
        //myTextEdit is the id of the TextEdit
        myTextEdit.text.toString().substring(myTextEdit.selectionStart, myTextEdit.selectionEnd);
        \endcode
    */
    property alias selectedText: edit.selectedText

    /*!
        \qmlproperty color TextArea::selectedTextColor

        The selected text color, used in selections.
    */
    property alias selectedTextColor: edit.selectedTextColor

    /*!
        \qmlproperty color TextArea::selectionColor

        The text highlight color, used behind selections.
    */
    property alias selectionColor: edit.selectionColor

    /*!
        \qmlproperty int TextArea::selectionEnd

        The cursor position after the last character in the current selection.

        This property is read-only. To change the selection, use select(start,end),
        selectAll(), or selectWord().

        \sa selectionStart, cursorPosition, selectedText
    */
    property alias selectionEnd: edit.selectionEnd

    /*!
        \qmlproperty int TextArea::selectionStart

        The cursor position before the first character in the current selection.

        This property is read-only. To change the selection, use select(start,end),
        selectAll(), or selectWord().

        \sa selectionEnd, cursorPosition, selectedText
    */
    property alias selectionStart: edit.selectionStart

    /*!
        \qmlproperty bool TextArea::tabChangesFocus

        This property holds whether Tab changes focus or is accepted as input.

        Defaults to false.
    */
    property bool tabChangesFocus: false

    /*!
        \qmlproperty string TextArea::text

        The text to display.  If the text format is AutoText the text edit will
        automatically determine whether the text should be treated as
        rich text.  This determination is made using Qt::mightBeRichText().
    */
    property alias text: edit.text

    /*!
        \qmlproperty enumeration TextArea::textFormat

        The way the text property should be displayed.

        \list
        \li TextEdit.AutoText
        \li TextEdit.PlainText
        \li TextEdit.RichText
        \endlist

        The default is TextEdit.PlainText.  If the text format is TextEdit.AutoText the text edit
        will automatically determine whether the text should be treated as
        rich text.  This determination is made using Qt::mightBeRichText().
    */
    property alias textFormat: edit.textFormat

    /*!
       \qmlproperty real TextArea::textMargin

       The margin, in pixels, around the text in the TextEdit.
    */
    property alias textMargin: edit.textMargin

    /*!
        \qmlproperty enumeration TextArea::wrapMode

        Set this property to wrap the text to the TextEdit item's width.
        The text will only wrap if an explicit width has been set.

        \list
        \li TextEdit.NoWrap - no wrapping will be performed. If the text contains insufficient newlines, then implicitWidth will exceed a set width.
        \li TextEdit.WordWrap - wrapping is done on word boundaries only. If a word is too long, implicitWidth will exceed a set width.
        \li TextEdit.WrapAnywhere - wrapping is done at any point on a line, even if it occurs in the middle of a word.
        \li TextEdit.Wrap - if possible, wrapping occurs at a word boundary; otherwise it will occur at the appropriate point on the line, even in the middle of a word.
        \endlist

        The default is TextEdit.NoWrap. If you set a width, consider using TextEdit.Wrap.
    */
    property alias wrapMode: edit.wrapMode

    /*!
        \qmlsignal TextArea::linkActivated(string link)

        This signal is emitted when the user clicks on a link embedded in the text.
        The link must be in rich text or HTML format and the
        \a link string provides access to the particular link.
    */
    signal linkActivated(string link)

    /*!
        \qmlmethod TextArea::append(string)

        Appends \a string as a new line to the end of the text area.
    */
    function append (string) {
        text += "\n" + string
        verticalScrollBar.value = verticalScrollBar.maximumValue
    }

    /*!
        \qmlmethod TextArea::copy()

        Copies the currently selected text to the system clipboard.
    */
    function copy() {
        edit.copy();
    }

    /*!
        \qmlmethod TextArea::cut()

        Moves the currently selected text to the system clipboard.
    */
    function cut() {
        edit.cut();
    }

    /*!
        \qmlmethod TextArea::deselect()

        Removes active text selection.
    */
    function deselect() {
        edit.deselect();
    }

    /*!
        \qmlmethod string TextArea::getFormattedText(int start, int end)

        Returns the section of text that is between the \a start and \a end positions.

        The returned text will be formatted according the \l textFormat property.
    */
    function getFormattedText(start, end) {
        return edit.getFormattedText(start, end);
    }

    /*!
        \qmlmethod string TextArea::getText(int start, int end)

        Returns the section of text that is between the \a start and \a end positions.

        The returned text does not include any rich text formatting.
    */
    function getText(start, end) {
        return edit.getText(start, end);
    }

    /*!
        \qmlmethod TextArea::insert(int position, string text)

        Inserts \a text into the TextArea at position.
    */
    function insert(position, text) {
        edit.insert(position, text);
    }

    /*!
        \qmlmethod TextArea::isRightToLeft(int start, int end)

        Returns true if the natural reading direction of the editor text
        found between positions \a start and \a end is right to left.
    */
    function isRightToLeft(start, end) {
        return edit.isRightToLeft(start, end);
    }

    /*!
        \qmlmethod TextArea::moveCursorSelection(int position, SelectionMode mode = TextEdit.SelectCharacters)

        Moves the cursor to \a position and updates the selection according to the optional \a mode
        parameter. (To only move the cursor, set the \l cursorPosition property.)

        When this method is called it additionally sets either the
        selectionStart or the selectionEnd (whichever was at the previous cursor position)
        to the specified position. This allows you to easily extend and contract the selected
        text range.

        The selection mode specifies whether the selection is updated on a per character or a per word
        basis.  If not specified the selection mode will default to TextEdit.SelectCharacters.

        \list
        \li TextEdit.SelectCharacters - Sets either the selectionStart or selectionEnd (whichever was at
        the previous cursor position) to the specified position.
        \li TextEdit.SelectWords - Sets the selectionStart and selectionEnd to include all
        words between the specified position and the previous cursor position.  Words partially in the
        range are included.
        \endlist

        For example, take this sequence of calls:

        \code
            cursorPosition = 5
            moveCursorSelection(9, TextEdit.SelectCharacters)
            moveCursorSelection(7, TextEdit.SelectCharacters)
        \endcode

        This moves the cursor to position 5, extend the selection end from 5 to 9
        and then retract the selection end from 9 to 7, leaving the text from position 5 to 7
        selected (the 6th and 7th characters).

        The same sequence with TextEdit.SelectWords will extend the selection start to a word boundary
        before or on position 5 and extend the selection end to a word boundary on or past position 9.
    */
    function moveCursorSelection(position, mode) {
        edit.moveCursorSelection(position, mode);
    }

    /*!
        \qmlmethod TextArea::paste()

        Replaces the currently selected text by the contents of the system clipboard.
    */
    function paste() {
        edit.paste();
    }

    /*!
        \qmlmethod int TextArea::positionAt(int x, int y)

        Returns the text position closest to pixel position (\a x, \a y).

        Position 0 is before the first character, position 1 is after the first character
        but before the second, and so on until position \l {text}.length, which is after all characters.
    */
    function positionAt(x, y) {
        return edit.positionAt(x, y);
    }

    /*!
        \qmlmethod rectangle TextArea::positionToRectangle(position)

        Returns the rectangle at the given \a position in the text. The x, y,
        and height properties correspond to the cursor that would describe
        that position.
    */
    function positionToRectangle(position) {
        return edit.positionToRectangle(position);
    }

    /*!
        \qmlmethod TextArea::redo()

        Redoes the last operation if redo is \l {canRedo}{available}.
    */
    function redo() {
        edit.redo();
    }

    /*!
        \qmlmethod string TextArea::remove(int start, int end)

        Removes the section of text that is between the \a start and \a end positions from the TextArea.
    */
    function remove(start, end) {
        return edit.remove(start, end);
    }

    /*!
        \qmlmethod TextArea::select(int start, int end)

        Causes the text from \a start to \a end to be selected.

        If either start or end is out of range, the selection is not changed.

        After calling this, selectionStart will become the lesser
        and selectionEnd will become the greater (regardless of the order passed
        to this method).

        \sa selectionStart, selectionEnd
    */
    function select(start, end) {
        edit.select(start, end);
    }

    /*!
        \qmlmethod TextArea::selectAll()

        Causes all text to be selected.
    */
    function selectAll() {
        edit.selectAll();
    }

    /*!
        \qmlmethod TextArea::selectWord()

        Causes the word closest to the current cursor position to be selected.
    */
    function selectWord() {
        edit.selectWord();
    }

    /*!
        \qmlmethod TextArea::undo()

        Undoes the last operation if undo is \l {canUndo}{available}. Deselects any
        current selection, and updates the selection start to the current cursor
        position.
    */
    function undo() {
        edit.undo();
    }

    /*!
        \qmlproperty color ScrollArea:backgroundColor

        This property sets the background color of the viewport.

        The default value is the base color of the SystemPalette.

    */
    property alias backgroundColor: colorRect.color

    width: 280
    height: 120

    flickableItem.contentWidth: edit.paintedWidth + (2 * documentMargins)

    frame: true

    Accessible.role: Accessible.EditableText

    // FIXME: probably implement text interface
    Accessible.name: text

    TextEdit {
        id: edit

        SystemPalette {
            id: palette
            colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
        }

        Rectangle {
            id: colorRect
            parent: viewport
            anchors.fill: parent
            color: palette.base
            z: -1
        }


        renderType: Text.NativeRendering

        color: palette.text
        selectionColor: palette.highlight
        selectedTextColor: palette.highlightedText
        wrapMode: TextEdit.WordWrap
        width: area.viewport.width - (2 * documentMargins)
        x: documentMargins
        y: documentMargins

        selectByMouse: true
        readOnly: false

        KeyNavigation.priority: KeyNavigation.BeforeItem
        KeyNavigation.tab: area.tabChangesFocus ? area.KeyNavigation.tab : null
        KeyNavigation.backtab: area.tabChangesFocus ? area.KeyNavigation.backtab : null

        onContentSizeChanged: { area.flickableItem.contentWidth = paintedWidth + (2 * documentMargins) }

        // keep textcursor within scrollarea
        onCursorPositionChanged: {
            if (cursorRectangle.y >= flickableItem.contentY + viewport.height - 1.5*cursorRectangle.height - documentMargins)
                flickableItem.contentY = cursorRectangle.y - viewport.height + 1.5*cursorRectangle.height + documentMargins
            else if (cursorRectangle.y < flickableItem.contentY)
                flickableItem.contentY = cursorRectangle.y

            if (cursorRectangle.x >= flickableItem.contentX + viewport.width - documentMargins) {
                flickableItem.contentX = cursorRectangle.x - viewport.width + documentMargins
            } else if (cursorRectangle.x < flickableItem.contentX)
                flickableItem.contentX = cursorRectangle.x
        }
        onLinkActivated: area.linkActivated(link)

        MouseArea {
            parent: area.viewport
            anchors.fill: parent
            cursorShape: Qt.IBeamCursor
            acceptedButtons: Qt.NoButton
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_PageUp) {
            verticalValue = verticalValue - area.height
        } else if (event.key == Qt.Key_PageDown)
            verticalValue = verticalValue + area.height
    }

}
