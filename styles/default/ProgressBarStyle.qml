/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project on Qt Labs.
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

import Qt 4.7

QtObject {
    property int minimumWidth: 200
    property int minimumHeight: 16

    property int leftMargin: 4
    property int rightMargin: 4
    property int topMargin: 2
    property int bottomMargin: 2

    property Component background: Component {
        Rectangle { // background
            opacity: enabled ? 1 : 0.7
            radius: 4
            color: backgroundColor
            border.color: "#555"
        }
    }

    property Component progress: Component {    // progress bar, known duration
        Rectangle { // green progress indication
            radius: 4; color: progressColor

            Rectangle { // demonstrating "glow"
                z: -1
                radius: 4
                anchors.fill: parent; anchors.margins: -2;
                color: "white"; opacity: 0.3
            }
        }
    }

    property Component indeterminateProgress: Component {   // progress bar, unknown duration
        Rectangle {
            id: bar
            radius: 4; color: progressColor

            Rectangle { // Ocillating puck, see QTBUG-15654
                width: 60
                height: parent.height
                opacity: 0.5

                NumberAnimation on x {
                    from: 0; to: bar.width-60; //mm Somehow the width of the "bar" is zero!! (post defect)
                    duration: 1000
                    running: true
                    loops: Animation.Infinite
                }
            }
        }
    }
}
