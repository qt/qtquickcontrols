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
import "../plugin"
import "./styles/default" as DefaultStyles

Item {
    id: slider

    // COMMON API
    property int orientation: Qt.Horizontal
    property alias minimumValue: range.minimumValue
    property alias maximumValue: range.maximumValue
    property alias inverted: range.inverted
    property bool updateValueWhileDragging: true
    property alias pressed: mouseArea.pressed
    property alias stepSize: range.stepSize

    // NOTE: this property is in/out, the user can set it, create bindings to it, and
    // at the same time the slider wants to update. There's no way in QML to do this kind
    // of updates AND allow the user bind it (without a Binding object). That's the
    // reason this is an alias to a C++ property in range model.
    property alias value: range.value

    // CONVENIENCE TO BE USED BY STYLES
    SystemPalette {
        id: palette
    }
    property color progressColor: palette.highlight
    property color backgroundColor: palette.window

    property int leftMargin: defaultStyle.leftMargin
    property int rightMargin: defaultStyle.rightMargin

    // EXTENSIONS
    // Indicate that we want animations in the Slider, people customizing should
    // look at it to decide whether or not active animations.
    property bool animated: true
    property bool activeFocusOnPress: true

    // Value indicator displays the current value near the slider
    property bool valueIndicatorVisible: true
    property int valueIndicatorMargin: 10
    property string valueIndicatorPosition: _isVertical ? "Left" : "Top"

    // Reimplement this function to control how the value is shown in the
    // indicator.
    function formatValue(v) {
        return Math.round(v);
    }

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    // Hooks for customizing the pieces of the slider
    property Component groove: defaultStyle.groove
    property Component handle: defaultStyle.handle
    property Component valueIndicator: defaultStyle.valueIndicator

    // PRIVATE/CONVENIENCE
    property bool _isVertical: orientation == Qt.Vertical

    width: _isVertical ? minimumHeight : minimumWidth
    height: _isVertical ? minimumWidth : minimumHeight

    DefaultStyles.SliderStyle { id: defaultStyle }

    // This is a template slider, so every piece can be modified by passing a
    // different Component. The main elements in the implementation are
    //
    // - the 'range' does the calculations to map position to/from value,
    //   it also serves as a data storage for both properties;
    //
    // - the 'fakeHandle' is what the mouse area drags on the screen, it feeds
    //   the 'range' position and also reads it when convenient;
    //
    // - the real 'handle' it is the visual representation of the handle, that
    //   just follows the 'fakeHandle' position.
    //
    // When the 'updateValueWhileDragging' is false and we are dragging, we stop
    // feeding the range with position information, delaying until the next
    // mouse release.
    //
    // Everything is encapsulated in a contents Item, so for the
    // vertical slider, we just swap the height/width, make it
    // horizontal, and then use rotation to make it vertical again.

    Item {
        id: contents

        width: _isVertical ? slider.height : slider.width
        height: _isVertical ? slider.width : slider.height
        rotation: _isVertical ? -90 : 0

        anchors.centerIn: slider

        RangeModel {
            id: range
            minimumValue: 0
            maximumValue: 100
            value: 0
            stepSize: 1.0
            inverted: false

            positionAtMinimum: leftMargin
            positionAtMaximum: contents.width - rightMargin
        }

        Loader {
            id: grooveLoader
            anchors.fill: parent
            sourceComponent: groove

            property real handlePosition : handleLoader.x
            function positionForValue(value) {
                return range.positionForValue(value) - leftMargin;
            }
        }

        Loader {
            id: handleLoader
            transform: Translate { x: - handleLoader.width / 2 }

            anchors.verticalCenter: grooveLoader.verticalCenter

            sourceComponent: handle

            x: fakeHandle.x
            Behavior on x {
                id: behavior
                enabled: !mouseArea.drag.active && slider.animated

                PropertyAnimation {
                    duration: behavior.enabled ? 150 : 0
                    easing.type: Easing.OutSine
                }
            }
        }

        Item {
            id: fakeHandle
            width: handleLoader.width
            height: handleLoader.height
            transform: Translate { x: - handleLoader.width / 2 }
        }

        MouseArea {
            id: mouseArea

            anchors.centerIn: parent
            anchors.horizontalCenterOffset: (slider.leftMargin - slider.rightMargin) / 2

            width: parent.width + handleLoader.width - slider.rightMargin - slider.leftMargin
            height: parent.height

            drag.target: fakeHandle
            drag.axis: Drag.XAxis
            drag.minimumX: range.positionAtMinimum
            drag.maximumX: range.positionAtMaximum

            onPressed: {
                if (activeFocusOnPress)
                    slider.focus = true;

                // Clamp the value
                var newX = Math.max(mouse.x, drag.minimumX);
                newX = Math.min(newX, drag.maximumX);

                // Debounce the press: a press event inside the handler will not
                // change its position, the user needs to drag it.
                if (Math.abs(newX - fakeHandle.x) > handleLoader.width / 2)
                    range.position = newX;
            }

            onReleased: {
                // If we don't update while dragging, this is the only
                // moment that the range is updated.
                if (!slider.updateValueWhileDragging)
                    range.position = fakeHandle.x;
            }
        }

        Loader {
            id: valueIndicatorLoader

            transform: Translate { x: - handleLoader.width / 2 }
            rotation: _isVertical ? 90 : 0
            visible: valueIndicatorVisible

            // Properties available for the delegate component. Note that the indicatorText
            // shows the value for the position the handle is, which is not necessarily the
            // available as the current slider.value, since updateValueWhileDragging can
            // be set to 'false'.
            property string indicatorText: slider.formatValue(range.valueForPosition(handleLoader.x))
            property bool dragging: mouseArea.drag.active

            sourceComponent: valueIndicator

            state: {
                if (!_isVertical)
                    return slider.valueIndicatorPosition;

                if (valueIndicatorPosition == "Right")
                    return "Bottom";
                if (valueIndicatorPosition == "Top")
                    return "Right";
                if (valueIndicatorPosition == "Bottom")
                    return "Left";

                return "Top";
            }

            anchors.margins: valueIndicatorMargin

            states: [
                State {
                    name: "Top"
                    AnchorChanges {
                        target: valueIndicatorLoader
                        anchors.bottom: handleLoader.top
                        anchors.horizontalCenter: handleLoader.horizontalCenter
                    }
                },
                State {
                    name: "Bottom"
                    AnchorChanges {
                        target: valueIndicatorLoader
                        anchors.top: handleLoader.bottom
                        anchors.horizontalCenter: handleLoader.horizontalCenter
                    }
                },
                State {
                    name: "Right"
                    AnchorChanges {
                        target: valueIndicatorLoader
                        anchors.left: handleLoader.right
                        anchors.verticalCenter: handleLoader.verticalCenter
                    }
                },
                State {
                    name: "Left"
                    AnchorChanges {
                        target: valueIndicatorLoader
                        anchors.right: handleLoader.left
                        anchors.verticalCenter: handleLoader.verticalCenter
                    }
                }
            ]
        }
    }

    // Range position normally follow fakeHandle, except when
    // 'updateValueWhileDragging' is false. In this case it will only follow
    // if the user is not pressing the handle.
    Binding {
        when: updateValueWhileDragging || !mouseArea.pressed
        target: range
        property: "position"
        value: fakeHandle.x
    }

    // During the drag, we simply ignore position set from the range, this
    // means that setting a value while dragging will not "interrupt" the
    // dragging activity.
    Binding {
        when: !mouseArea.drag.active
        target: fakeHandle
        property: "x"
        value: range.position
    }
}
