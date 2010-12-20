import QtQuick 1.0

// KNOWN ISSUES
// 1) With !desktopBehavior and TextEdit dragging a highlight is interrupted by the PressAndHold signal firing

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
            textEditor.forceActiveFocus();    //mm see QTBUG-16157
            if(desktopBehavior) {
                textEditor.cursorPosition = characterPositionAt(mouse);
                pressedPos = textEditor.cursorPosition;
            }
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
                if(pos > selectionStart && pos < selectionEnd) {    // clicked  on selected text
                    copyPastePopup.showing = true;


//                    print('Copied "' + textEditor.selectedText + '"')
//                    textEditor.copy();
                } else if(selectionStart != selectionEnd) { // clicked outside selection
                    textEditor.select(textEditor.selectionEnd, textEditor.selectionEnd);   // clear selection
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

        ModalPopupBehavior {
            id: modalPopup
            popup: loader.item
            positionBy: copyPastePopup

            ListModel {
                id: buttonModel
                ListElement { text: "Copy" }
                ListElement { text: "Cut" }
                ListElement { text: "Paste" }
            }

            Loader {
                id: loader
                sourceComponent: copyPasteButtons
                onLoaded: if(status == Loader.Ready) { item.model = buttonModel }
            }
        }
    }

}















