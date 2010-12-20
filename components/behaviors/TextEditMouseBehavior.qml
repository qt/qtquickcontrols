import QtQuick 1.0

Item {
    id: mouseBehavior

    property Item textEditor
    property bool desktopBehavior: true
    property alias containsMouse: mouseArea.containsMouse

    // Implementation

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

        //mm see QTBUG-15814
        onPressed: {
            textEditor.forceActiveFocus();    //mm see QTBUG-16157
            if(desktopBehavior) {
                textEditor.cursorPosition = textEditor.positionAt(mouse.x-textEditor.x);
                pressedPos = textEditor.cursorPosition;
            }
        }

        onPressAndHold: {
            if(!desktopBehavior) {
                textEditor.cursorPosition = textEditor.positionAt(mouse.x-textEditor.x);
            }
        }

        onClicked: {
            if(!desktopBehavior) {
                var pos = textEditor.positionAt(mouse.x-textEditor.x);
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

            if(desktopBehavior) {
                textEditor.select(pressedPos, textEditor.positionAt(mouse.x-textEditor.x));
            } else {
                if(mouse.wasHeld) {
                    textEditor.cursorPosition = textEditor.positionAt(mouse.x-textEditor.x);
                } else if(selectedText.length > 0) {
                    var pos = textEditor.positionAt(mouse.x-textEditor.x);
                    if(pos > textEditor.selectionStart + (textEditor.selectionEnd-textEditor.selectionStart)/2)
                        textEditor.select(textEditor.selectionStart, pos);
                    else
                        textEditor.select(textEditor.selectionEnd, pos);
                }
            }
        }

        onDoubleClicked: {
            textEditor.cursorPosition = textEditor.positionAt(mouse.x-textEditor.x);
            textEditor.selectWord(); // select word at cursor position
        }

//        onTrippleClicked: if(desktopBehavior) textEditor.selectAll();
    }


    Loader {
        id: copyPastePopup
        property bool show: false
        sourceComponent: show ? copyPastePopupComponent : undefined

        onLoaded: {
            var lineEditMappedPos = mapToItem(null, lineEdit.x, lineEdit.y);
            item.x = lineEditMappedPos.x + mouseArea.mouseX - item.width/2;
            item.y = lineEditMappedPos.y - item.height;
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















