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



    Item {
        id: foo

        ModalPopupBehavior {
            x: 10
            id: copyPastePopup
            popup: redRect

            Rectangle {
                id: redRect
                color: "red"
                width: 100
                height: 200
            }
        }
    }


//    MouseArea {
//        id: copyPastePopup
//        property bool showing: false

//        property Item rootItem
//        Component.onCompleted: {
//            rootItem = parent;
//            while (rootItem.parent != undefined) {
//                rootItem = rootItem.parent;
//            }
//        }

//        onPressed: {
//            showing = false; // hide
//            mouse.accepted = false;  // let pointer event throught
//        }

//        opacity: 0  // hidden initially
//        anchors.fill: parent

//        Rectangle { color: "red"; anchors.fill: parent; opacity: 0.5 }

//        states: State { name: "visible"
//            when: copyPastePopup.showing == true
//            ParentChange { target: copyPastePopup; parent: copyPastePopup.rootItem }
//            PropertyChanges { target: copyPastePopup; opacity: 1 }
//        }
//    }




//    Loader {
//        id: copyPastePopup
//        property bool show: false
//        sourceComponent: show ? copyPastePopupComponent : undefined

//        onLoaded: if(status == Loader.Ready) {
//            var mappedPos = mapToItem(null, textEditor.x, textEditor.y);
//            item.x = mappedPos.x + mouseArea.mouseX - item.width/2;
//            item.y = mappedPos.y - item.height;
//        }
//    }

//    Component {
//        id: copyPastePopupComponent
//        Item {
//            width: buttonLoader.width
//            height: buttonLoader.height

//            Component.onCompleted: {
//                var p = parent;
//                while (p.parent != undefined)
//                    p = p.parent
//                parent = p;
//            }

//            ListModel {
//                id: buttonModel
//                ListElement { text: "Copy" }
//                ListElement { text: "Cut" }
//                ListElement { text: "Paste" }
//            }

//            Loader {
//                id: buttonLoader
//                sourceComponent: copyPasteButtons
//                onLoaded: if(status == Loader.Ready) { print("loaded:" + status); item.model = buttonModel }
//            }
//        }
//    }
}















