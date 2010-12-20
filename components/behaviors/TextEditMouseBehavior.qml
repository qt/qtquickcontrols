import QtQuick 1.0

// KNOWN ISSUES
// 1) Can't tell if the Paste button should be shown or not, see QTBUG-16190
// 2) Hard to tell if the Select button should be shown (part of QTBUG-16190?)
// 3) Dragging the end of the selection past the beginning (or vise vesa) result in somewhat wrong selection
// 4) Positioning of copy/paste/etc buttons doesn't take the window into account (can result in clipped buttons)

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
        property bool hadFocusBeforePress

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
            textEditor.forceActiveFocus();    //mm see QTBUG-16157
            if(desktopBehavior) {
                textEditor.cursorPosition = characterPositionAt(mouse);
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

        onClicked: {
            if(!desktopBehavior) {
                var pos = characterPositionAt(mouse);
                var selectionStart = Math.min(textEditor.selectionStart, textEditor.selectionEnd);
                var selectionEnd = Math.max(textEditor.selectionStart, textEditor.selectionEnd);

                if(pos > selectionStart && pos < selectionEnd) {    // clicked on selected text
                    copyPastePopup.showing = true;
                } else if(selectionStart != selectionEnd) { // clicked outside selection
                    textEditor.select(textEditor.selectionEnd, textEditor.selectionEnd);   // clear selection
                } else {    // clicked while there's no selection
//                  var endOfWordRegEx = /b/;
//mm crash!         var endOfWordPosition = textEditor.text.indexOf(endOfWordRegEx, pos);

                    textEditor.cursorPosition = pos;    //mm temp workaround
                    var endOfWordPosition = textEditor.cursorPosition;

                    if(textEditor.cursorPosition == endOfWordPosition) {
                        if(hadFocusBeforePress && textEditor.cursorPosition == pressedPos) {
                            copyPastePopup.showing = true;
                        }
                    } else {
                        textEditor.cursorPosition = endOfWordPosition;
                    }
                }

            }
        }

        onPositionChanged: {
            if(!pressed)
                return;

            var pos = characterPositionAt(mouse);
            if(desktopBehavior) {
                textEditor.select(pressedPos, pos);
            } else {
                if(mouse.wasHeld) {
                    textEditor.cursorPosition = pos;
                } else if(selectedText.length > 0) {
                    if(pos > textEditor.selectionStart + (textEditor.selectionEnd-textEditor.selectionStart)/2)
                        textEditor.select(textEditor.selectionStart, pos);
                    else
                        textEditor.select(textEditor.selectionEnd, pos);
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

        var selectionStartPos = Math.min(textEditor.selectionStart, textEditor.selectionEnd);
        var selectionEndPos = Math.max(textEditor.selectionStart, textEditor.selectionEnd);

        var selectionStartRect = textEditor.positionToRectangle(selectionStartPos);
        var mappedStartPoint = mapFromItem(textEditor, selectionStartRect.x, selectionStartRect.y);
        mappedStartPoint.x = Math.max(mappedStartPoint.x, 0);
        mappedStartPoint.y = Math.max(mappedStartPoint.y, 0);

        var selectioEndRect = textEditor.positionToRectangle(selectionEndPos);
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
        onShowingChanged: {
            if(showing) {
                var popoutPoint = selectionPopoutPoint();
                copyPastePopup.x = popoutPoint.x - modalPopup.popup.width/2
                copyPastePopup.y = popoutPoint.y - modalPopup.popup.height
            }
        }

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

        ModalPopupBehavior {
            id: modalPopup
            popup: loader.item
            positionBy: copyPastePopup
            consumeCancelClick: true

            Loader {
                id: loader
                sourceComponent: copyPasteButtons
                onLoaded: if(status == Loader.Ready) { item.model = popupButtonModel }

                Connections {
                    target: loader.item
                    onClicked: {
                        if(index == 0) textEditor.copy();
                        if(index == 1) textEditor.cut();
                        if(index == 2) textEditor.paste();
                        if(index == 3) textEditor.selectWord();
                        if(index == 4) textEditor.selectAll();
                        copyPastePopup.showing = false;
                    }
                }
            }
        }
    }
}














