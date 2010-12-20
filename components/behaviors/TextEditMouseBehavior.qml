import QtQuick 1.0

Item {
    id: mouseBehavior

    property TextInput textInput
    property TextEdit textEdit
    property bool desktopBehavior: true
    property alias containsMouse: mouseArea.containsMouse

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
                textEditor.cursorPosition = characterPositionAt(mouse);
            }
        }

        onClicked: {
            if(!desktopBehavior) {
                var pos = characterPositionAt(mouse);
                var selectionStart = Math.min(textEditor.selectionStart, textEditor.selectionEnd);
                var selectionEnd = Math.max(textEditor.selectionStart, textEditor.selectionEnd);
                if(pos > selectionStart && pos < selectionEnd) {    // clicked  on selected text
                    copyPastePopup.show = true;


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


    Loader {
        id: copyPastePopup
        property bool show: false
        sourceComponent: show ? copyPastePopupComponent : undefined

        onLoaded: {
            var mappedPos = mapToItem(null, textEditor.x, textEditor.y);
            item.x = mappedPos.x + mouseArea.mouseX - item.width/2;
            item.y = mappedPos.y - item.height;
        }
    }

    Component {
        id: copyPastePopupComponent
        Rectangle {
            color: "darkgray"
            width: row.width
            height: row.height

            Component.onCompleted: {
                var p = parent;
                while (p.parent != undefined)
                    p = p.parent
                parent = p;
            }
            Row {
                id: row
                spacing: 10
                Text { text: "Copy"; color: "white" }
                Text { text: "Cut"; color: "white" }
                Text { text: "Paste"; color: "white" }
            }
        }
    }

}















