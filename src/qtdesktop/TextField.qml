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
import "Styles"
import "Styles/Settings.js" as Settings

/*!
    \qmltype TextField
    \inqmlmodule QtDesktop 1.0
    \ingroup controls
    \brief TextField displays a single line of editable plain text

    TextField is used to accept a line of text input. Input constraints
    can be placed on a TextField item (for example, through a \l validator or \l inputMask),
    and setting \l echoMode to an appropriate value enables TextField to be used for
    a password input field.

    \sa TextArea, TextInput
*/

FocusScope {
    id: textfield

    /*!
        \qmlproperty bool TextField::acceptableInput

        This property is always true unless a validator or input mask has been set.
        If a validator or input mask has been set, this property will only be true
        if the current text is acceptable to the validator or input mask as a final
        string (not as an intermediate string).
    */
    property alias acceptableInput: textInput.acceptableInput // read only

    /*!
        \qmlproperty bool TextField::activeFocusOnPress

        Whether the TextField should gain active focus on a mouse press. By default this is
        set to true.
    */
    property alias activeFocusOnPress: textInput.activeFocusOnPress

    /*!
        \qmlproperty bool TextField::autoScroll

        Whether the TextField should scroll when the text is longer than the width. By default this is
        set to true.
    */
    property alias autoScroll: textInput.autoScroll

    /*!
        \qmlproperty bool TextField::canPaste

        Returns true if the TextField is writable and the content of the clipboard is
        suitable for pasting into the TextField.
    */
    property alias canPaste: textInput.canPaste

    /*!
        \qmlproperty bool TextField::canRedo

        Returns true if the TextField is writable and there are \l {undo}{undone}
        operations that can be redone.
    */
    property alias canRedo: textInput.canRedo

    /*!
        \qmlproperty bool TextField::canUndo

        Returns true if the TextField is writable and there are previous operations
        that can be undone.
    */
    property alias canUndo: textInput.canUndo

    /*!
        \qmlproperty color TextField::color

        The text color.
    */
    property alias color: textInput.color

    /*!
        \qmlproperty bool TextField::containsMouse
        This property holds whether the mouse is currently inside the TextField.
    */
    property alias containsMouse: mouseArea.containsMouse

    /*!
        \qmlproperty real TextField::contentHeight

        Returns the height of the text, including the height past the height
        that is covered if the text does not fit within the set height.
    */
    property alias contentHeight: textInput.contentHeight

    /*!
        \qmlproperty real TextField::contentWidth

        Returns the width of the text, including the width past the width
        which is covered due to insufficient wrapping if \l wrapMode is set.
    */
    property alias contentWidth: textInput.contentWidth

    /*!
        \qmlproperty Component TextField::cursorDelegate
        The delegate for the cursor in the TextField.

        If you set a cursorDelegate for a TextField, this delegate will be used for
        drawing the cursor instead of the standard cursor. An instance of the
        delegate will be created and managed by the TextField when a cursor is
        needed, and the x property of delegate instance will be set so as
        to be one pixel before the top left of the current character.

        Note that the root item of the delegate component must be a QQuickItem or
        QQuickItem derived item.
    */
    property alias cursorDelegate: textInput.cursorDelegate

    /*!
        \qmlproperty int TextField::cursorPosition
        The position of the cursor in the TextField.
    */
    property alias cursorPosition: textInput.cursorPosition

    /*!
        \qmlproperty rectangle TextField::cursorRectangle

        The rectangle where the standard text cursor is rendered within the text input.  Read only.

        The position and height of a custom cursorDelegate are updated to follow the cursorRectangle
        automatically when it changes.  The width of the delegate is unaffected by changes in the
        cursor rectangle.
    */
    property alias cursorRectangle: textInput.cursorRectangle

    /*!
        \qmlproperty bool TextField::cursorVisible
        Set to true when the TextField shows a cursor.

        This property is set and unset when the TextField gets active focus, so that other
        properties can be bound to whether the cursor is currently showing. As it
        gets set and unset automatically, when you set the value yourself you must
        keep in mind that your value may be overwritten.

        It can be set directly in script, for example if a KeyProxy might
        forward keys to it and you desire it to look active when this happens
        (but without actually giving it active focus).

        It should not be set directly on the item, like in the below QML,
        as the specified value will be overridden an lost on focus changes.

        \code
        TextField {
            text: "Text"
            cursorVisible: false
        }
        \endcode

        In the above snippet the cursor will still become visible when the
        TextField gains active focus.
    */
    property alias cursorVisible: textInput.cursorVisible

    /*!
       \qmlproperty string TextField::displayText

       This is the text displayed in the TextField.

       If \l echoMode is set to TextInput::Normal, this holds the
       same value as the TextField::text property. Otherwise,
       this property holds the text visible to the user, while
       the \l text property holds the actual entered text.
    */
    property alias displayText: textInput.displayText

    /*!
        \qmlproperty enumeration TextField::echoMode

        Specifies how the text should be displayed in the TextField.
        \list
        \li TextInput.Normal - Displays the text as it is. (Default)
        \li TextInput.Password - Displays asterisks instead of characters.
        \li TextInput.NoEcho - Displays nothing.
        \li TextInput.PasswordEchoOnEdit - Displays characters as they are entered
        while editing, otherwise displays asterisks.
        \endlist
    */
    property alias echoMode: textInput.echoMode

    /*!
        \qmlproperty font TextField::font

        The font of the TextField.
    */
    property alias font: textInput.font

    /*!
        \qmlproperty enumeration TextField::horizontalAlignment
        \qmlproperty enumeration TextField::effectiveHorizontalAlignment
        \qmlproperty enumeration TextField::verticalAlignment

        Sets the alignment of the text within the TextField item's width and height.
        By default, the horizontal text alignment follows the natural alignment of the text,
        for example text that is read from left to right will be aligned to the left.

        The valid values for \c horizontalAlignment are \c TextInput.AlignLeft, \c TextInput.AlignRight and
        \c TextInput.AlignHCenter.

        Valid values for \c verticalAlignment are \c TextInput.AlignTop,
        \c TextInput.AlignBottom \c TextInput.AlignVCenter (default).

        When using the attached property LayoutMirroring::enabled to mirror application
        layouts, the horizontal alignment of text will also be mirrored. However, the property
        \c horizontalAlignment will remain unchanged. To query the effective horizontal alignment
        of TextField, use the read-only property \c effectiveHorizontalAlignment.
    */
    property alias horizontalAlignment: textInput.horizontalAlignment
    property alias effectiveHorizontalAlignment: textInput.effectiveHorizontalAlignment
    property alias verticalAlignment: textInput.verticalAlignment

    /*!
        \qmlproperty string TextField::inputMask

        Allows you to set an input mask on the TextField, restricting the allowable
        text inputs. See QLineEdit::inputMask for further details, as the exact
        same mask strings are used by TextField.

        \sa acceptableInput, validator
    */
    property alias inputMask: textInput.inputMask

    /*!
        \qmlproperty bool TextField::inputMethodComposing

        This property holds whether the TextField has partial text input from an
        input method.

        While it is composing an input method may rely on mouse or key events from
        the TextField to edit or commit the partial text. This property can be
        used to determine when to disable event handlers that may interfere with
        the correct operation of an input method.
    */
    property alias inputMethodComposing: textInput.inputMethodComposing

    /*!
        \qmlproperty enumeration TextField::inputMethodHints

        Provides hints to the input method about the expected content of the text field and how it
        should operate.

        The value is a bit-wise combination of flags, or Qt.ImhNone if no hints are set.

        Flags that alter behavior are:

        \list
        \li Qt.ImhHiddenText - Characters should be hidden, as is typically used when entering passwords.
                This is automatically set when setting echoMode to \c TextInput.Password.
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
    property alias inputMethodHints: textInput.inputMethodHints

    /*!
        \qmlproperty int TextField::length

        Returns the total number of characters in the TextField item.

        If the TextField has an inputMask the length will include mask characters and may differ
        from the length of the string returned by the \l text property.

        This property can be faster than querying the length the \l text property as it doesn't
        require any copying or conversion of the TextField's internal string data.
    */
    property alias length: textInput.length

    /*!
        \qmlproperty int TextField::maximumLength
        The maximum permitted length of the text in the TextField.

        If the text is too long, it is truncated at the limit.

        By default, this property contains a value of 32767.
    */
    property alias maximumLength: textInput.maximumLength

    /*!
        \qmlproperty enumeration TextField::mouseSelectionMode

        Specifies how text should be selected using a mouse.

        \list
        \li TextInput.SelectCharacters - The selection is updated with individual characters. (Default)
        \li TextInput.SelectWords - The selection is updated with whole words.
        \endlist

        This property only applies when \l selectByMouse is true.
    */
    property alias mouseSelectionMode: textInput.mouseSelectionMode

    /*!
       \qmlproperty string TextField::passwordCharacter

       This is the character displayed when echoMode is set to Password or
       PasswordEchoOnEdit. By default it is an asterisk.

       If this property is set to a string with more than one character,
       the first character is used. If the string is empty, the value
       is ignored and the property is not set.
    */
    property alias passwordCharacter: textInput.passwordCharacter

    /*!
        \qmlproperty bool TextField::persistentSelection

        Whether the TextField should keep its selection when it loses active focus to another
        item in the scene. By default this is set to false;
    */
    property alias persistentSelection: textInput.persistentSelection

    /*!
        \qmlproperty string TextField::placeholderText

        The text that is shown in the text field when the text field is empty
        and has no focus.
    */
    property alias placeholderText: placeholderTextComponent.text

    /*!
        \qmlproperty bool TextField::readOnly

        Sets whether user input can modify the contents of the TextField.

        If readOnly is set to true, then user input will not affect the text
        property. Any bindings or attempts to set the text property will still
        work.
    */
    property alias readOnly: textInput.readOnly

    /*!
        \qmlproperty enumeration TextField::renderType

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
    property alias renderType: textInput.renderType

    /*!
        \qmlproperty bool TextField::selectByMouse

        Defaults to true.

        If true, the user can use the mouse to select text in some
        platform-specific way. Note that for some platforms this may
        not be an appropriate interaction (eg. may conflict with how
        the text needs to behave inside a Flickable.
    */
    property alias selectByMouse: textInput.selectByMouse

    /*!
        \qmlproperty string TextField::selectedText

        This read-only property provides the text currently selected in the
        text input.

        It is equivalent to the following snippet, but is faster and easier
        to use.

        \js
        myTextField.text.toString().substring(myTextField.selectionStart, myTextField.selectionEnd);
        \endjs
    */
    property alias selectedText: textInput.selectedText

    /*!
        \qmlproperty color TextField::selectedTextColor

        The highlighted text color, used in selections.
    */
    property alias selectedTextColor: textInput.selectedTextColor

    /*!
        \qmlproperty color TextField::selectionColor

        The text highlight color, used behind selections.
    */
    property alias selectionColor: textInput.selectionColor

    /*!
        \qmlproperty int TextField::selectionEnd

        The cursor position after the last character in the current selection.

        This property is read-only. To change the selection, use select(start,end),
        selectAll(), or selectWord().

        \sa selectionStart, cursorPosition, selectedText
    */
    property alias selectionEnd: textInput.selectionEnd

    /*!
        \qmlproperty int TextField::selectionStart

        The cursor position before the first character in the current selection.

        This property is read-only. To change the selection, use select(start,end),
        selectAll(), or selectWord().

        \sa selectionEnd, cursorPosition, selectedText
    */
    property alias selectionStart: textInput.selectionStart

    /*!
        \qmlproperty string TextField::text

        The text in the TextField.
    */
    property alias text: textInput.text

    /*!
        \qmlproperty Validator TextField::validator

        Allows you to set a validator on the TextField. When a validator is set
        the TextField will only accept input which leaves the text property in
        an acceptable or intermediate state. The accepted signal will only be sent
        if the text is in an acceptable state when enter is pressed.

        Currently supported validators are IntValidator, DoubleValidator and
        RegExpValidator. An example of using validators is shown below, which allows
        input of integers between 11 and 31 into the text input:

        \code
        import QtQuick 2.0
        import QtDesktop 1.0

        TextField {
            validator: IntValidator {bottom: 11; top: 31;}
            focus: true
        }
        \endcode

        \sa acceptableInput, inputMask
    */
    property alias validator: textInput.validator

    /*!
        \qmlproperty enumeration TextField::wrapMode

        Set this property to wrap the text to the TextField item's width.
        The text will only wrap if an explicit width has been set.

        \list
        \li TextInput.NoWrap - no wrapping will be performed. If the text contains insufficient newlines, then implicitWidth will exceed a set width.
        \li TextInput.WordWrap - wrapping is done on word boundaries only. If a word is too long, implicitWidth will exceed a set width.
        \li TextInput.WrapAnywhere - wrapping is done at any point on a line, even if it occurs in the middle of a word.
        \li TextInput.Wrap - if possible, wrapping occurs at a word boundary; otherwise it will occur at the appropriate point on the line, even in the middle of a word.
        \endlist

        The default is TextInput.NoWrap. If you set a width, consider using TextInput.Wrap.
    */
    property alias wrapMode: textInput.wrapMode

    /*! \internal */
    property Component style: Qt.createComponent(Settings.THEME_PATH + "/TextFieldStyle.qml", textInput)

    /*! \internal */
    property var styleHints:[]

    /*!
        \qmlsignal TextField::accepted()

        This signal is emitted when the Return or Enter key is pressed.
        Note that if there is a \l validator or \l inputMask set on the text
        field, the signal will only be emitted if the input is in an acceptable
        state.
    */
    signal accepted()

    /*!
        \qmlmethod TextField::copy()

        Copies the currently selected text to the system clipboard.
    */
    function copy() {
        textInput.copy()
    }

    /*!
        \qmlmethod TextField::cut()

        Moves the currently selected text to the system clipboard.
    */
    function cut() {
        textInput.cut()
    }

    /*!
        \qmlmethod TextField::deselect()

        Removes active text selection.
    */
    function deselect() {
        textInput.deselect();
    }

    /*!
        \qmlmethod string TextField::getText(int start, int end)

        Removes the section of text that is between the \a start and \a end positions from the TextField.
    */
    function getText(start, end) {
        return textInput.getText(start, end);
    }

    /*!
        \qmlmethod TextField::insert(int position, string text)

        Inserts \a text into the TextField at position.
    */
    function insert(position, text) {
        textInput.insert(position, text);
    }

    /*!
        \qmlmethod bool TextField::isRightToLeft(int start, int end)

        Returns true if the natural reading direction of the editor text
        found between positions \a start and \a end is right to left.
    */
    function isRightToLeft(start, end) {
        return textInput.isRightToLeft(start, end);
    }

    /*!
        \qmlmethod TextField::paste()

        Replaces the currently selected text by the contents of the system clipboard.
    */
    function paste() {
        textInput.paste()
    }

    /*!
        \qmlmethod int TextField::positionAt(real x, real y, CursorPosition position = CursorBetweenCharacters)

        This function returns the character position at
        x and y pixels from the top left of the TextField. Position 0 is before the
        first character, position 1 is after the first character but before the second,
        and so on until position text.length, which is after all characters.

        This means that for all x values before the first character this function returns 0,
        and for all x values after the last character this function returns text.length.  If
        the y value is above the text the position will be that of the nearest character on
        the first line line and if it is below the text the position of the nearest character
        on the last line will be returned.

        The cursor position type specifies how the cursor position should be resolved.

        \list
        \li TextInput.CursorBetweenCharacters - Returns the position between characters that is nearest x.
        \li TextInput.CursorOnCharacter - Returns the position before the character that is nearest x.
        \endlist
    */
    function positionAt(x, y, cursor) {
        var p = mapToItem(textInput, x, y);
        return textInput.positionAt(p.x, p.y, cursor);
    }

    /*!
        \qmlmethod rect TextField::positionToRectangle(int pos)

        This function takes a character position and returns the rectangle that the
        cursor would occupy, if it was placed at that character position.

        This is similar to setting the cursorPosition, and then querying the cursor
        rectangle, but the cursorPosition is not changed.
    */
    function positionToRectangle(pos) {
        var p = mapToItem(textInput, pos.x, pos.y);
        return textInput.positionToRectangle(p);
    }

    /*!
        \qmlmethod TextField::redo()

        Redoes the last operation if redo is \l {canRedo}{available}.
    */
    function redo() {
        textInput.redo();
    }

    /*!
        \qmlmethod TextField::select(int start, int end)

        Causes the text from \a start to \a end to be selected.

        If either start or end is out of range, the selection is not changed.

        After calling this, selectionStart will become the lesser
        and selectionEnd will become the greater (regardless of the order passed
        to this method).

        \sa selectionStart, selectionEnd
    */
    function select(start, end) {
        textInput.select(start, end)
    }

    /*!
        \qmlmethod TextField::selectAll()

        Causes all text to be selected.
    */
    function selectAll() {
        textInput.selectAll()
    }

    /*!
        \qmlmethod TextField::selectWord()

        Causes the word closest to the current cursor position to be selected.
    */
    function selectWord() {
        textInput.selectWord()
    }

    /*!
        \qmlmethod TextField::undo()

        Undoes the last operation if undo is \l {canUndo}{available}. Deselects any
        current selection, and updates the selection start to the current cursor
        position.
    */
    function undo() {
        textInput.undo();
    }

    // Implementation
    implicitWidth: loader.implicitWidth
    implicitHeight: loader.implicitHeight

    Accessible.name: text
    Accessible.role: Accessible.EditableText
    Accessible.description: placeholderText

    Loader {
        id: loader
        sourceComponent: style
        anchors.fill: parent
        property Item control: textfield
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: textfield.forceActiveFocus()
    }

    /*! \internal */
    onFocusChanged: {
        if (textfield.activeFocus)
            textInput.forceActiveFocus();
    }

    TextInput { // see QTBUG-14936
        id: textInput
        selectByMouse: true
        selectionColor: loader.item ? loader.item.selectionColor : "black"
        selectedTextColor: loader.item ? loader.item.selectedTextColor : "black"

        property Item styleItem: loader.item
        font: styleItem ? styleItem.font : font
        anchors.leftMargin: styleItem ? styleItem.leftMargin : 0
        anchors.topMargin: styleItem ? styleItem.topMargin : 0
        anchors.rightMargin: styleItem ? styleItem.rightMargin : 0
        anchors.bottomMargin: styleItem ? styleItem.bottomMargin : 0

        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter

        color: loader.item ? loader.item.foregroundColor : "darkgray"
        clip: true
        renderType: Text.NativeRendering

        onAccepted: textfield.accepted()
    }

    Text {
        id: placeholderTextComponent
        anchors.fill: textInput
        font: textInput.font
        horizontalAlignment: textInput.horizontalAlignment
        verticalAlignment: textInput.verticalAlignment
        opacity: !textInput.text.length && !textInput.activeFocus ? 1 : 0
        color: loader.item ? loader.item.placeholderTextColor : "darkgray"
        clip: true
        elide: Text.ElideRight
//        renderType: Text.NativeRendering
        Behavior on opacity { NumberAnimation { duration: 90 } }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        acceptedButtons: Qt.NoButton
    }
}
