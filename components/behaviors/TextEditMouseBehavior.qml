import QtQuick 1.0

// KNOWN ISSUES
// 1) Can't tell if the Paste button should be shown or not, see QTBUG-16190
// 2) Hard to tell if the Select button should be shown (part of QTBUG-16190?)

Item {
    id: mouseBehavior

    property TextInput textInput
    property TextEdit textEdit
    property Flickable flickable
    property bool desktopBehavior: true
    property alias containsMouse: mouseArea.containsMouse

    property Component copyPasteButtons

    // Implementation

    property Item textEditor: Qt.isQtObject(textInput) ? textInput : textEdit

    Connections {
        target: textInput
        onTextChanged: reset()
        onCursorPositionChanged: reset()
        onSelectedTextChanged: reset()
        onActiveFocusChanged: reset()
    }

    function reset() {
        copyPastePopup.showing = false; // hide and restart the visibility timer
        copyPastePopup.showing = selectedText.length > 0;
        copyPastePopup.wasCancelledByClick = false;
        copyPastePopup.wasClosedByCopy = false;
    }

    Component.onCompleted: {
        textEditor.focus = true;
        textEditor.selectByMouse = false;
        textEditor.activeFocusOnPress = false;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: Item {} // work-around for Flickable stealing the mouse, which is expected (?), see QTBUG-15231

        property int pressedPos
        property int selectionStartAtPress
        property int selectionEndAtPress
        property bool hadFocusBeforePress
        property bool draggingStartHandle
        property bool draggingEndHandle

        function characterPositionAt(mouse) {
            var mappedMouse = mapToItem(textEditor, mouse.x, mouse.y);
            if(Qt.isQtObject(textInput)) {
                return textInput.positionAt(mappedMouse.x);
            } else {
                return textEdit.positionAt(mappedMouse.x, mappedMouse.y);
            }
        }

        //mm see QTBUG-15814
        onPressed: {
            hadFocusBeforePress = textEditor.activeFocus;
            selectionStartAtPress = textEditor.selectionStart;
            selectionEndAtPress = textEditor.selectionEnd;

            textEditor.forceActiveFocus();    //mm see QTBUG-16157
            var pos = characterPositionAt(mouse);
            if(desktopBehavior) {
                textEditor.cursorPosition = pos;
            } else {
                draggingStartHandle = false;    // reset both to false, i.e. no dragging of selection endpoints
                draggingEndHandle = false;
                if(textEditor.selectionStart != textEditor.selectionEnd) {
                    draggingEndHandle = (pos > selectionStartAtPress + (selectionEndAtPress-selectionStartAtPress)/2);
                    draggingStartHandle = !draggingEndHandle;
                }
            }

            pressedPos = textEditor.cursorPosition;
        }

        onPressAndHold: {
            if(!desktopBehavior) {
                if(!textEditor.selectedText.length) {   //mm Somehow just having the onPressAndHold impementation interrupts the text selection
                    textEditor.cursorPosition = characterPositionAt(mouse);
                }
            }
        }

        onReleased: {
            if(!desktopBehavior) {
                if(mouse.wasHeld) copyPastePopup.showing = true;
            }
        }

        onClicked: {
            if(!desktopBehavior) {
                if(!hadFocusBeforePress)
                    return;

                var pos = characterPositionAt(mouse);
                if(textEditor.selectedText.length) { // clicked on or outside selection
                    if(copyPastePopup.wasClosedByCopy && pos >= textEditor.selectionStart && pos < textEditor.selectionEnd)
                        copyPastePopup.showing = true;
                    else
                        textEditor.select(textEditor.selectionEnd, textEditor.selectionEnd);   //mm use deselect() from QtQuick 1.1 (see QTBUG-16059)
                } else {    // clicked while there's no selection
                    if(pos == textEditor.cursorPosition) {  // Clicked where the cursor already where
                        copyPastePopup.showing = !copyPastePopup.wasCancelledByClick;
                        copyPastePopup.wasCancelledByClick = false;
                    } else { // Clicked in a new place (where the cursor wasn't)
                        var endOfWordRegEx = /[^\b]\b/g;
                        endOfWordRegEx.lastIndex = pos;
                        var endOfWordPosition = pos;
                        if(endOfWordRegEx.test(textEditor.text))   // updates lastIndex
                            endOfWordPosition = endOfWordRegEx.lastIndex;

                        if(textEditor.cursorPosition != endOfWordPosition) {
                            textEditor.cursorPosition = endOfWordPosition;
                        } else {
                            copyPastePopup.showing = !copyPastePopup.wasCancelledByClick;
                            copyPastePopup.wasCancelledByClick = false;
                        }
                    }
                }
            }

            textEditor.openSoftwareInputPanel()
        }

        onPositionChanged: {
            if(!pressed)
                return;

            var pos = characterPositionAt(mouse);
            if(desktopBehavior) {
                textEditor.select(pressedPos, pos);
            } else {
                if(draggingStartHandle) {
                    textEditor.select(selectionEndAtPress, pos);
                } else if(draggingEndHandle) {
                    textEditor.select(selectionStartAtPress, pos);
                } else if(mouse.wasHeld && textEditor.cursorPosition != pos) {  // there's no selection
                    textEditor.cursorPosition = pos;
                    copyPastePopup.showing = true; // show once not pressed any more
                }
            }
        }

        onDoubleClicked: {
            textEditor.cursorPosition = characterPositionAt(mouse);
            textEditor.selectWord(); // select word at cursor position
        }

//        onTrippleClicked: if(desktopBehavior) textEditor.selectAll();
    }


    function selectionPopoutPoint() {
        var point = {x:0, y:0}

        var selectionStartRect = textEditor.positionToRectangle(textEditor.selectionStart);
        var mappedStartPoint = mapFromItem(textEditor, selectionStartRect.x, selectionStartRect.y);
        mappedStartPoint.x = Math.max(mappedStartPoint.x, 0);
        mappedStartPoint.y = Math.max(mappedStartPoint.y, 0);

        var selectioEndRect = textEditor.positionToRectangle(textEditor.selectionEnd);
        var mappedEndPoint = mapFromItem(textEditor, selectioEndRect.x, selectioEndRect.y);
        mappedEndPoint.x = Math.min(mappedEndPoint.x, textEditor.width);
        mappedEndPoint.y = Math.min(mappedEndPoint.y, textEditor.height);

        var multilineSelection = (selectionStartRect.y != selectioEndRect.y);
        if(!multilineSelection) {
            point.x = mappedStartPoint.x + (mappedEndPoint.x-mappedStartPoint.x)/2
        } else {
            point.x = textEditor.x + textEdit.width/2;
        }

        point.y = mappedStartPoint.y
        return point;
    }

    Item {
        id: copyPastePopup

        property alias showing: modalPopup.showing
        property bool wasCancelledByClick: false
        property bool wasClosedByCopy: false

        property bool showCopyAction: textEditor.selectedText.length > 0
        property bool showCutAction: textEditor.selectedText.length > 0
        property bool showPasteAction: true //textEditor.canPaste  //mm see QTBUG-16190
        property bool showSelectAction: textEditor.text.length > 0 && textEditor.selectedText.length < textEditor.text.length // need canSelectWord, see QTBUG-16190
        property bool showSelectAllAction: textEditor.text.length > 0 && textEditor.selectedText.length < textEditor.text.length

        ListModel {
            id: popupButtonModel
            ListElement { text: "Copy"; opacity: 0 }        // index: 0
            ListElement { text: "Cut"; opacity: 0 }         // index: 1
            ListElement { text: "Paste"; opacity: 1 }       // index: 2
            ListElement { text: "Select"; opacity: 0 }      // index: 3
            ListElement { text: "Select all"; opacity: 0 }  // index: 4
        }

        onShowCopyActionChanged: popupButtonModel.setProperty(0, "opacity", showCopyAction ? 1 : 0);
        onShowCutActionChanged: popupButtonModel.setProperty(1, "opacity", showCutAction ? 1 : 0);
        onShowPasteActionChanged: popupButtonModel.setProperty(2, "opacity", showPasteAction ? 1 : 0);
        onShowSelectActionChanged: popupButtonModel.setProperty(3, "opacity", showSelectAction ? 1 : 0);
        onShowSelectAllActionChanged: popupButtonModel.setProperty(4, "opacity", showSelectAllAction ? 1 : 0);

        Component.onCompleted: {
            showCopyActionChanged();
            showCutActionChanged();
            showPasteActionChanged();
            showSelectActionChanged();
            showSelectAllActionChanged();
        }

        function positionPopout(popup, window) {   // position poput above the text field's cursor
            var popoutPoint = selectionPopoutPoint();
            var mappedPos = mapToItem(window, popoutPoint.x, popoutPoint.y);
            popup.x = Math.max(mappedPos.x - popup.width/2, 0);
            if(popup.x+popup.width > window.width)
                popup.x = window.width-popup.width;

            popup.y = mappedPos.y - popup.height;
            if(popup.y < 0)
                popup.y += popup.height + textEditor.height;
        }

        ModalPopupBehavior {
            id: modalPopup
            consumeCancelClick: false
            whenAlso: !mouseArea.pressed
            delay: 300
            onPrepareToShow: copyPastePopup.positionPopout(popup, window)
            onCancelledByClick: copyPastePopup.wasCancelledByClick = true

            popupComponent: copyPasteButtons
            onPopupChanged: if(popup) popup.model = popupButtonModel

            Connections {
                target: modalPopup.popup
                onClicked: {
                    if(index == 0) {
                        textEditor.copy();
                        copyPastePopup.showing = false;
                        copyPastePopup.wasClosedByCopy = true;
                    }
                    if(index == 1) textEditor.cut();
                    if(index == 2) textEditor.paste();
                    if(index == 3) textEditor.selectWord();
                    if(index == 4) textEditor.selectAll();
                }
            }
        }
    }
}

