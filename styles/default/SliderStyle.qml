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

    property Component groove: Component {
        id:defaultBackground
        Item {
            Rectangle {
                color:backgroundColor
                anchors.fill: sliderbackground
                anchors.margins: 1
                radius: 2
            }
            BorderImage {
                id: sliderbackground
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                border.top: 2
                border.bottom: 2
                border.left: 12
                border.right: 12
                source: "../../images/slider.png"
            }
            Rectangle {
                color: progressColor
                height: 8
                radius: 2
                anchors.verticalCenter: parent.verticalCenter
                x: Math.min(2+zeroPosition, handlePosition) // see QTBUG-15250
                width: Math.max(zeroPosition, handlePosition) - x
            }
        }
    }

    property Component handle: Component {
        Item{
            width: handleImage.width
            height: handleImage.height
            anchors.verticalCenter: parent.verticalCenter

            //mm Animation clash with slider's positioning of the hand. What to do?
            //            Behavior on x { NumberAnimation { easing: Easing.Linear; duration: styledItem.mouseArea.drag.active ? 0 : 100 } }
            //            Behavior on y { NumberAnimation { easing: Easing.Linear; duration: styledItem.mouseArea.drag.active ? 0 : 100 } }
            Image {
                id: handleImage
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 5
                    color: backgroundColor
                    radius: Math.floor(parent.width/2)
                    z: -1   // behind the image
                }
                anchors.centerIn: parent;
                source: "../../images/handle.png"
                smooth: true
            }

            Rectangle {
                anchors.bottom: handleImage.top
                anchors.horizontalCenter: handleImage.horizontalCenter
                width: valueText.width+20
                height: valueText.height+20
                color: "gray"
                opacity: pressed ? 0.9 : 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
                radius: 5

                Text {
                    id: valueText
                    anchors.margins: 10
                    anchors.centerIn: parent
                    text: value
                }
            }
        }
    }
}
