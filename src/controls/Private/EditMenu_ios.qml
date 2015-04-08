/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Private 1.0

Item {
    anchors.fill: parent
    property bool __showMenuFromTouchAndHold: false

    property Component defaultMenu: Menu {
        MenuItem {
            text: qsTr("Cut")
            visible: !input.readOnly && selectionStart !== selectionEnd
            onTriggered: {
                cut();
                select(input.cursorPosition, input.cursorPosition);
            }
        }
        MenuItem {
            text: qsTr("Copy")
            visible: selectionStart !== selectionEnd
            onTriggered: {
                copy();
                select(input.cursorPosition, input.cursorPosition);
            }
        }
        MenuItem {
            text: qsTr("Paste")
            visible: input.canPaste
            onTriggered: paste();
        }
        MenuItem {
            text: qsTr("Delete")
            visible: !input.readOnly && selectionStart !== selectionEnd
            onTriggered: remove(selectionStart, selectionEnd)
        }
        MenuItem {
            text: qsTr("Select")
            visible: selectionStart === selectionEnd && input.length > 0
            onTriggered: selectWord();
        }
        MenuItem {
            text: qsTr("Select All")
            visible: !(selectionStart === 0 && selectionEnd === length)
            onTriggered: selectAll();
        }
    }

    Connections {
        target: mouseArea

        function clearFocusFromOtherItems()
        {
            var selectionItem = TextSingleton.selectionItem;
            if (!selectionItem)
                return;
            var otherPos = selectionItem.cursorPosition;
            selectionItem.select(otherPos, otherPos)
        }

        onClicked: {
            if (control.menu && getMenuInstance().__popupVisible) {
                select(input.cursorPosition, input.cursorPosition);
            } else {
                input.activate();
                clearFocusFromOtherItems();
            }

            if (input.activeFocus) {
                var pos = input.positionAt(mouse.x, mouse.y)
                input.moveHandles(pos, pos)
            }
        }

        onPressAndHold: {
            var pos = input.positionAt(mouseArea.mouseX, mouseArea.mouseY);
            input.select(pos, pos);
            var hasSelection = selectionStart != selectionEnd;
            if (!control.menu || (input.length > 0 && (!input.activeFocus || hasSelection))) {
                selectWord();
            } else {
                // We don't select anything at this point, the
                // menu will instead offer to select a word.
                __showMenuFromTouchAndHold = true;
                menuTimer.start();
                clearFocusFromOtherItems();
            }
        }

        onReleased: __showMenuFromTouchAndHold = false
        onCanceled: __showMenuFromTouchAndHold = false
    }

    Connections {
        target: cursorHandle ? cursorHandle : null
        ignoreUnknownSignals: true
        onPressedChanged: menuTimer.start()
    }

    Connections {
        target: selectionHandle ? selectionHandle : null
        ignoreUnknownSignals: true
        onPressedChanged: menuTimer.start()
    }

    Connections {
        target: flickable
        ignoreUnknownSignals: true
        onMovingChanged: menuTimer.start()
    }

    Connections {
        id: selectionConnections
        target: input
        ignoreUnknownSignals: true
        onSelectionStartChanged: menuTimer.start()
        onSelectionEndChanged: menuTimer.start()
        onActiveFocusChanged: menuTimer.start()
    }

    Timer {
        // We use a timer so that we end up with one update when multiple connections fire at the same time.
        // Basically we wan't the menu to be open if the user does a press and hold, or if we have a selection.
        // The exceptions are if the user is moving selection handles or otherwise touching the screen (e.g flicking).
        // What is currently missing are showing a magnifyer to place the cursor, and to reshow the edit menu when
        // flicking stops.
        id: menuTimer
        interval: 1
        onTriggered: {
            if (!control.menu)
                return;

            if ((__showMenuFromTouchAndHold || selectionStart !== selectionEnd)
                    && control.activeFocus
                    && (!cursorHandle.pressed && !selectionHandle.pressed)
                    && (!flickable || !flickable.moving)
                    && (cursorHandle.delegate)) {
                var p1 = input.positionToRectangle(input.selectionStart);
                var p2 = input.positionToRectangle(input.selectionEnd);
                var topLeft = input.mapToItem(null, p1.x, p1.y);
                var size = Qt.size(p2.x - p1.x + p1.width, p2.y - p1.y + p1.height)
                var targetRect = Qt.rect(topLeft.x, topLeft.y, size.width, size.height);
                getMenuInstance().__dismissMenu();
                getMenuInstance().__popup(targetRect, -1, MenuPrivate.EditMenu);
            } else {
                getMenuInstance().__dismissMenu();
            }
        }
    }
}
