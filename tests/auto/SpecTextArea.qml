/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components API Conformance Test Suite.
**
** No Commercial Usage
** This file contains pre-release code and may not be distributed.
** You may use this file in accordance with the terms and conditions contained
** in the Technology Preview License Agreement accompanying this package.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import QtQuick 1.0
import "../../components"

QtObject {
    property Component raw:
    Component {
        TextArea {
        }
    }

    property Component api:
    Component {
        QtObject {
            property QtObject font
            property int cursorPosition
            property int horizontalAlignment
            property int verticalAlignment
            property bool readOnly
            property string selectedText
            property int selectionEnd
            property int selectionStart
            property string text
            property int textFormat
            property int wrapMode

            function copy() {}
            function paste() {}
            function cut() {}
            function select(start, end) {}
            function selectAll() {}
            function selectWord() {}
            function positionAt(x, y) {}
            function positionToRectangle(pos) {}
        }
    }

    property Component defaults:
    Component {
        TextArea {
           readOnly: false
           text: ""
           cursorPosition: 0
           wrapMode: TextEdit.Wrap
        }
    }

    property Component basic:
    Component {
        TextArea {
            width: 200
            height: 200
            text: "Test TextArea"
        }
    }
}
