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
import Qt.labs.components 1.0 as QtComponents
import "./styles/default" as DefaultStyles

Item {
    id: slider
    property bool vertical: false

    property color progressColor: "#9cf"
    property color backgroundColor: "#fff"
    property bool  showProgress: true
    property alias hover: grooveMouseArea.containsMouse

    property alias value: valueModel.value
    property alias minimumValue: valueModel.minimumValue
    property alias maximumValue: valueModel.maximumValue
    property alias progress: receivedModel.value
    property alias steps: valueModel.steps

    property int indicatorPosition: vertical ? QtComponents.Orientation.Left : QtComponents.Orientation.Top
    property bool indicatorVisible: true
    property string indicatorLabel: Math.round(valueModel.value * Math.pow(10, 1))/Math.pow(10, 1)

    property Component handle: defaultStyle.handle
    property Component background: defaultStyle.background
    property Component content: defaultStyle.content

    signal valueChanged(real value)
    signal pressed
    signal released

    width: 200  //mm Need to get this from the styling
    height: 28

    QtComponents.RangeModel {
        // This model describes the range of values the slider can take
        // (minimum/maximum) and helps mapping between logical value and
        // the graphical position of the handle inside the component
        // (positionAtMinimum/positionAtMaximum)
        id: valueModel
        steps: 1
        positionAtMinimum: 0
        positionAtMaximum: slider.vertical ? groove.height : groove.width
        onValueChanged: slider.valueChanged(value)
    }

    QtComponents.RangeModel {   // For "YouTube-style loading" progress
        // This model describes the progress/download percentage
        id: receivedModel
        steps: valueModel.steps
        positionAtMinimum: valueModel.positionAtMinimum
        positionAtMaximum: valueModel.positionAtMaximum
        minimumValue: valueModel.minimumValue
        maximumValue: valueModel.maximumValue
    }

    MouseArea {
        id: grooveMouseArea
        hoverEnabled: true
        // RestrictedDragging means that the handle
        // should snap to steps _while_ dragging. This property is hidden
        // inside here as we see this as a style decition:
        property bool restrictedDragging: false

        anchors.verticalCenter: groove.verticalCenter
        anchors.horizontalCenter: groove.horizontalCenter
        width: handlePixmap.width + (vertical ? 0 : groove.width)
        height: handlePixmap.height + (vertical ? groove.height : 0)
        onPressed: {
            //style.feedback("pressFeedback");
            positionHandle(mouseX, mouseY);
            slider.pressed();
        }
        onPositionChanged: {
            // FIXME: handle min interval/value change
            //style.feedback("moveFeedback");
            if (pressed) {
                positionHandle(mouseX, mouseY);
            }
        }
        onReleased: {
            if (vertical) {
                handlePixmap.y = valueModel.position - (handlePixmap.height / 2)
            } else {
                handlePixmap.x = valueModel.position - (handlePixmap.width / 2)
            }
            slider.released();
            // enable? style.feedback("releaseFeedback");
        }
        function positionHandle(mouseX, mouseY) {
            if (vertical) {
                valueModel.position = mouseY - (handlePixmap.height/2);
                handlePixmap.y = restrictedDragging ?
                            valueModel.position - (handlePixmap.height / 2) : conformToRange(mouseY);
            } else {
                valueModel.position = mouseX - (handlePixmap.width/2);
                handlePixmap.x = restrictedDragging ?
                            valueModel.position - (handlePixmap.width / 2) : conformToRange(mouseX);
            }
        }

        function conformToRange(v) {
            return Math.min(valueModel.positionAtMaximum - (handlePixmap.width/2),
                            Math.max(valueModel.positionAtMinimum - (handlePixmap.width/2),
                                     v - handlePixmap.width));
        }
    }

    // Background
    Loader {
        id: groove
        sourceComponent: background
        anchors.fill: parent
    }

    Loader {
        id: elapsed
        visible: showProgress
        sourceComponent: content
        anchors.top: groove.top
        anchors.left: groove.left
        anchors.bottom: vertical ? handlePixmap.verticalCenter : groove.bottom
        anchors.right: vertical ? groove.right : handlePixmap.horizontalCenter
    }

    // Handle
    Loader {
        id: handlePixmap
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: handle
    }

    DefaultStyles.SliderStyle { id: defaultStyle }
}
