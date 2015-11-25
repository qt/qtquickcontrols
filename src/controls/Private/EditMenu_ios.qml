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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls.Private 1.0

Item {
    anchors.fill: parent
    property bool __showMenuFromTouch: false

    property Component defaultMenu: Menu {
        /* iOS plugin will automatically populate edit menus with standard edit actions */
    }

    Connections {
        target: mouseArea

        onClicked: {
            var pos = input.positionAt(mouse.x, mouse.y);
            var posMoved = (pos !== input.cursorPosition);
            var popupVisible = (control.menu && getMenuInstance().__popupVisible);

            if (!input.activeFocus)
                input.activate();
            else if (!popupVisible && !posMoved)
                __showMenuFromTouch = true;

            input.moveHandles(pos, pos)
            menuTimer.start();
        }

        onPressAndHold: {
            __showMenuFromTouch = true;
            menuTimer.start();
        }

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

            if ((__showMenuFromTouch || selectionStart !== selectionEnd)
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
                __showMenuFromTouch = false;
            } else {
                getMenuInstance().__dismissMenu();
            }
        }
    }
}
