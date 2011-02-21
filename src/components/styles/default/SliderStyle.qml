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

import QtQuick 1.0

QtObject {

    property int minimumWidth: 200
    property int minimumHeight: 40

    property int leftMargin : 2
    property int topMargin: 0
    property int rightMargin: 2
    property int bottomMargin: 0

    property Component groove: Item {
        opacity: enabled ? 1.0 : 0.7

        Rectangle {
            color: backgroundColor
            anchors.fill: sliderBackground
            anchors.margins: 1
            radius: 2
        }

        Rectangle {
            property real zeroPos :  positionForValue(0)
            property real handlePos: handlePosition
            color: progressColor
            height: 10
            radius: 4
            anchors.verticalCenter: parent.verticalCenter
            x: zeroPos
            width: handlePos - x
        }

        BorderImage {
            id: sliderBackground
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            border.top: 2
            border.bottom: 2
            border.left: 12
            border.right: 12
            source: "images/slider.png"
        }
    }

    property Component handle: Item {
        width: handleImage.width
        height: handleImage.height
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: handleImage
            Rectangle {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -1
                width: parent.width - 7
                height: parent.height - 7
                smooth: true
                color: backgroundColor
                radius: Math.floor(parent.width / 2)
                z: -1   // behind the image
            }
            anchors.centerIn: parent;
            source: "images/handle.png"
            smooth: true
        }
    }

    property Component valueIndicator: Rectangle {
        width: valueText.width + 20
        height: valueText.height + 20
        color: "gray"
        opacity: pressed ? 0.9 : 0
        Behavior on opacity { NumberAnimation { duration: 100 } }
        radius: 5

        Text {
            id: valueText
            anchors.margins: 10
            anchors.centerIn: parent
            text: indicatorText
        }
    }
}
