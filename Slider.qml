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
import "./styles"  // StylingLoader
import Qt.labs.components 1.0 as QtComponents // RangeModel and ImplicitlySizeItem
import "./styles/default" as DefaultStyles

Item {
    id: slider
    property string orientation: "horizontal"  // "horizontal" or "vertical"

    property color progressColor: "#9cf"
    property color backgroundColor: "#fff"
    property alias containsMouse: mouseArea.containsMouse

    property alias value: valueModel.value
    signal valueChanged(real value)
    onValueChanged: print(value)    // debug

    property alias minimumValue: valueModel.minimumValue
    property alias maximumValue: valueModel.maximumValue
    property alias stepSize: valueModel.steps   //mm The RangleModel's step property actually behave like a stepSize (which is a good thing)


    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight

    //    property bool indicatorVisible: true
    //    property string indicatorLabel:

    property Component groove: defaultStyle.groove
    property Component handle: defaultStyle.handle

    property alias pressed: mouseArea.pressed
    property real zeroPosition: valueModel.positionAtZero   // needed by styling, should be read-only, see QTBUG-15257
    property real handlePosition: valueModel.position       // needed by styling, should be read-only

    width: { orientation == "vertical" ? preferredHeight : preferredWidth}
    height: { orientation == "vertical" ? preferredWidth: preferredHeight}

    QtComponents.RangeModel {
        // This model describes the range of values the slider can take
        // (minimum/maximum) and helps mapping between logical value and
        // the graphical position of the handle inside the component
        // (positionAtMinimum/positionAtMaximum)
        id: valueModel
        steps: 1    //mm this is really stepSize    (N.B. mouse areas drag handling works funny at the ends for large stepSize values. RangeModel bug?)
        positionAtMinimum: handleLoader.shaftRadius
        positionAtMaximum: grooveLoader.grooveLength-handleLoader.shaftRadius
        onValueChanged: slider.valueChanged(value)
        onPositionChanged: handleLoader.x = valueModel.position    // update handle's position
    }

    Item { // Rotation container. As far as the styling is concerned, the slider is always horizontal (except if it has a shadow)
        anchors.centerIn: parent
        rotation: orientation == "vertical" ? -90 : 0
        width: orientation == "vertical" ? slider.height : slider.width
        height: orientation == "vertical" ? slider.width : slider.height

        MouseArea {
            id: mouseArea
            hoverEnabled: true
            // snapToStep means that the handle
            // should snap to steps _while_ dragging. This property is hidden
            // inside here as we see this as a style decition:
            //        property bool snapToStep: false   //mm Think RangeModel needs the snap support built-in

            anchors.fill: parent
            onPressed: valueModel.position = mouse.x

            drag.target: handleLoader  //mm See QTBUG-15231
            drag.axis: Drag.XAxis
            drag.minimumX: handleLoader.shaftRadius
            drag.maximumX: width - handleLoader.shaftRadius
        }

        Loader {
            id: grooveLoader;
            sourceComponent: groove
            anchors.fill:parent
            property real grooveLength: item.width
        }

        Loader {
            id: handleLoader

            anchors.fill: undefined     // override default (in part needed because of QTBUG-14873)
            anchors.verticalCenter: parent.verticalCenter
            onLoaded: handleLoader.x = valueModel.position // update handle's initial position //mm Don't think the RangeModel is reporting the correct initial value
            onXChanged: valueModel.position = x;

            sourceComponent: handle
            property real shaftRadius: item.height/4

            transform: Translate {
                x: -handleLoader.width/2
                y: 0
            }
        }
    }
    DefaultStyles.SliderStyle { id: defaultStyle }
}




