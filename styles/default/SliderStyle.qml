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
    property Component background: defaultBackground
    property Component content: defaultContent
    property Component handle: defaultHandle

    property list<Component> elements: [
        Component {
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
                    visible: showProgress
                    color: progressColor
                    anchors.left: sliderbackground.left
                    anchors.top: sliderbackground.top
                    anchors.bottom: sliderbackground.bottom
                    width: handlePixmap.x + handlePixmap.width/2
                    opacity: 0.4
                    anchors.margins: 1
                    radius: 2
                }
            }
        },
        Component {
            id: defaultContent
            Item {
            }
        },
        Component {
            id: defaultHandle
            Item {
                width: 27
                height: 27
                Rectangle{
                    color: backgroundColor
                    width: 27
                    height: 27
                    anchors.centerIn: handle2
                    radius: 19
                    anchors.margins: 5
                    smooth: true
                }
                Image { anchors.centerIn: parent; id: handle2; source: "../../images/handle.png" }
            }
        }
    ]
}
