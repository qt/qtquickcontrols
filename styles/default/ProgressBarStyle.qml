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


    property int preferredWidth: 200
    property int preferredHeight: 16

    property int leftMargin : 2
    property int topMargin: 2
    property int rightMargin: 2
    property int bottomMargin: 1

    property Component background: Component {
        Rectangle { // background
            anchors.fill:parent
            radius: 4
            color: "#E6E6E6"
            border.color: "#555"
        }
    }

    property Component content: Component {
        Item {
            height: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            Item {  // progress bar, known duration
                anchors.fill: parent
                anchors.rightMargin: (endValue == startValue) ? 0 : parent.width - (percentComplete/100)*parent.width
                clip: true  // Clip the rounded rect inside to get a sharp right edge

                Rectangle { // green progress indication
                    width: parent.parent.width; height: parent.height
                    radius: 4; color: "#64AF2D"
                }
            }

            Item { // progress bar, unknown duration
                anchors.fill: parent
                opacity: (endValue == startValue) ? 0.5 : 0
                clip: true  // Clip the repeating diagonal pattern below
                property int posX: 0
                Row { // Draw white diagonal lines moving across the background
                    x: parent.posX
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 7
                    Repeater {
                        model: Math.ceil(parent.parent.width / 9)
                        Rectangle {
                            width: 2; height: 14
                            color: "white"
                            rotation: 45
                            smooth: true
                        }
                    }
                }
                Timer {
                    interval: 50; repeat: true
                    running: parent.opacity > 0
                    onTriggered: if (parent.posX++ > 7) parent.posX = 0
                }
            }

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: valueText.width+10
                height: valueText.height+10
                color: "gray"
                opacity: endValue ? 0.8 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
                radius: 5

                Text {
                    id: valueText
                    anchors.margins: 10
                    anchors.centerIn: parent
                    font.pixelSize: 8
                    text: progressText
                }
            }

        }
    }
}
