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
    property int minimumHeight: 25

    property int leftMargin: 0
    property int rightMargin: 0
    property int topMargin: 0
    property int bottomMargin: 0

    property Component background: Component {
        Item{
            Rectangle{
                anchors.fill:parent
                width: parent.width-2
                height: parent.height-2
                color: backgroundColor
                radius: 5
            }
            BorderImage {
                anchors.fill:parent
                source:"../../images/progressbar_groove.png"
                border.left:10; border.right:10
                border.top:10; border.bottom:10
            }
        }
    }

    property Component progress: Component {    // progress bar, known duration
        BorderImage { // green progress indication
            opacity: styledItem.enabled ? 1: 0.7
            source: complete > 0.95 ?
                    "../../images/progressbar_indeterminate.png" : "../../images/progressbar_fill.png"
            border.left:complete > 0.1 ? 6: 2;
            border.right:complete > 0.1 ? 6: 2
            border.top:10; border.bottom:10
            clip:true
            Image {
                visible:styledItem.enabled
                id: overlay
                NumberAnimation on x {
                    running: styledItem.enabled;
                    loops:Animation.Infinite;
                    from:0;
                    to:-overlay.sourceSize.width;
                    duration:2000
                }
                width:styledItem.width + sourceSize.width
                height:styledItem.height
                fillMode:Image.TileHorizontally
                source: "../../images/progressbar_overlay.png"
            }
        }
    }

    property Component indeterminateProgress: Component {   // progress bar, unknown duration
        Item {
            id: bar
            anchors.fill:parent
            onWidthChanged:indicator.x = width-indicator.width
            BorderImage {
                id:indicator
                opacity: styledItem.enabled ? 1: 0.7
                Behavior on x {
                    NumberAnimation{easing.type:Easing.Linear; duration:1000}
                }
                onXChanged: {
                    var w = bar.width - indicator.width
                    if (x == w) x = 0
                    else if (x==0) x = w
                }
                width: 80
                height: parent.height
                source:"../../images/progressbar_indeterminate.png"
                border.left:10 ; border.right:10
                border.top:10 ; border.bottom:10
                clip:true
                Item {
                    visible:styledItem.enabled
                    anchors.left:parent.left
                    Image {
                    id: overlay
                    NumberAnimation on x {
                        running: styledItem.enabled;
                        loops:Animation.Infinite;
                        from:0;
                        to:-overlay.sourceSize.width;
                        duration:2000
                    }
                    width:styledItem.width + sourceSize.width
                    height:styledItem.height
                    fillMode:Image.TileHorizontally
                    source: "../../images/progressbar_overlay.png"
                }
            }
            }
        }
    }
}
