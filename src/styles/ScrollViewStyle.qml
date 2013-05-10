/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0

/*!
    \qmltype ScrollViewStyle
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \since QtQuick.Controls.Styles 1.0
    \brief Provides custom styling for ScrollView
*/
Style {
    id: root

    /*! The \l ScrollView attached to this style. */
    readonly property ScrollView control: __control

    /*! This property controls the frame border padding of the scrollView. */
    property Margins padding: Margins {left: 1; top: 1; right: 1; bottom: 1}

    /*! This Component paints the corner area between scroll bars */
    property Component corner: Rectangle { color: "#ccc" }

    /*! This component determines if the flickable should reposition itself at the
    mouse location when clicked. */
    property bool scrollToClickedPosition: true

    /*! This Component paints the frame around scroll bars. */
    property Component frame: Rectangle {
        color: "white"
        border.color: "#999"
        border.width: 1
        radius: 1
        visible: control.frameVisible
    }

    /*! This is the minimum extent of the scroll bar handle.

        The default value is \c 30.
    */

    property int minimumHandleLength: 30

    /*! This property controls the edge overlap
        between the handle and the increment/decrement buttons.

        The default value is \c 30.
    */

    property int handleOverlap: 1

    /*! This component controls the appearance of the
        scroll bar background.

        \list
        \li property bool hovered
        \li property bool horizontal
        \endlist
    */

    property Component scrollBarBackground: Item {
        implicitWidth: 16
        implicitHeight: 16
        clip: true
        Rectangle {
            anchors.fill: parent
            color: "#ddd"
            border.color: "#aaa"
            anchors.rightMargin: horizontal ? -2 : -1
            anchors.leftMargin: horizontal ? -2 : 0
            anchors.topMargin: horizontal ? 0 : -2
            anchors.bottomMargin: horizontal ? -1 : -2
        }
    }

    /*! This component controls the appearance of the
        scroll bar handle.

        \list
        \li property bool hovered
        \li property bool pressed
        \li property bool horizontal
        \endlist
    */

    property Component handle: BorderImage{
        opacity: pressed ? 0.5 : hovered ? 1 : 0.8
        source: "images/scrollbar-handle-" + (horizontal ? "horizontal" : "vertical") + ".png"
        border.left: 2
        border.top: 2
        border.right: 2
        border.bottom: 2
    }

    /*! This component controls the appearance of the
        scroll bar increment button.

        You can access the following state properties:

        \list
        \li property bool hovered
        \li property bool pressed
        \li property bool horizontal
        \endlist
    */
    property Component incrementControl: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: -1
            anchors.rightMargin: -1
            border.color: "#aaa"
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                border.color: "#88ffffff"
            }
            Image {
                source: horizontal ? "images/arrow-right.png" : "images/arrow-down.png"
                anchors.centerIn: parent
                opacity: control.enabled ? 0.7 : 0.5
            }
            gradient: Gradient {
                GradientStop {color: pressed ? "lightgray" : "white" ; position: 0}
                GradientStop {color: pressed ? "lightgray" : "lightgray" ; position: 1}
            }
        }
    }

    /*! This component controls the appearance of the
        scroll bar decrement button.

        \list
        \li property bool hovered
        \li property bool pressed
        \li property bool horizontal
        \endlist
    */
    property Component decrementControl: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        Rectangle {
            anchors.fill: parent
            anchors.topMargin: horizontal ? 0 : -1
            anchors.leftMargin:  horizontal ? -1 : 0
            anchors.bottomMargin: horizontal ? -1 : 0
            anchors.rightMargin: horizontal ? 0 : -1
            color: "lightgray"
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                border.color: "#88ffffff"
            }
            Image {
                source: horizontal ? "images/arrow-left.png" : "images/arrow-up.png"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: horizontal ? 0 : -1
                anchors.horizontalCenterOffset: horizontal ? -1 : 0
                opacity: control.enabled ? 0.7 : 0.5
            }
            gradient: Gradient {
                GradientStop {color: pressed ? "lightgray" : "white" ; position: 0}
                GradientStop {color: pressed ? "lightgray" : "lightgray" ; position: 1}
            }
            border.color: "#aaa"
        }
    }

    /*! \internal */
    property Component __scrollbar: Item {
        id: panel
        property string activeControl: ""
        property bool scrollToClickPosition: true
        property var controlStateRef: controlState

        implicitWidth: controlState.horizontal ? 200 : bg.implicitWidth
        implicitHeight: controlState.horizontal ? bg.implicitHeight : 200

        function pixelMetric(arg) {
            if (arg === "scrollbarExtent")
                return (controlState.horizontal ? bg.height : bg.width);
            return 0;
        }

        function styleHint(arg) {
            return false;
        }

        function hitTest(argX, argY) {
            if (itemIsHit(handleControl, argX, argY))
                return "handle"
            else if (itemIsHit(incrementLoader, argX, argY))
                return "up";
            else if (itemIsHit(decrementLoader, argX, argY))
                return "down";
            else if (itemIsHit(bg, argX, argY)) {
                if (controlState.horizontal && argX < handleControl.x || !controlState.horizontal && argY < handleControl.y)
                    return "upPage"
                else
                    return "downPage"
            }

            return "none";
        }

        function subControlRect(arg) {
            if (arg === "handle") {
                return Qt.rect(handleControl.x, handleControl.y, handleControl.width, handleControl.height);
            } else if (arg === "groove") {
                if (controlState.horizontal) {
                    return Qt.rect(incrementLoader.width - handleOverlap,
                                   0,
                                   __control.width - (incrementLoader.width + decrementLoader.width - handleOverlap * 2),
                                   __control.height);
                } else {
                    return Qt.rect(0,
                                   incrementLoader.height - handleOverlap,
                                   __control.width,
                                   __control.height - (incrementLoader.height + decrementLoader.height - handleOverlap * 2));
                }
            }
            return Qt.rect(0,0,0,0);
        }

        function itemIsHit(argItem, argX, argY) {
            var pos = argItem.mapFromItem(__control, argX, argY);
            return (pos.x >= 0 && pos.x <= argItem.width && pos.y >= 0 && pos.y <= argItem.height);
        }

        Loader {
            id: incrementLoader
            anchors.top: parent.top
            anchors.left: parent.left
            sourceComponent: decrementControl
            property bool hovered: activeControl === "up"
            property bool pressed: controlState.upPressed
            property bool horizontal: controlState.horizontal
        }

        Loader {
            id: bg
            anchors.top: controlState.horizontal ? undefined : incrementLoader.bottom
            anchors.bottom: controlState.horizontal ? undefined : decrementLoader.top
            anchors.left:  controlState.horizontal ? incrementLoader.right : undefined
            anchors.right: controlState.horizontal ? decrementLoader.left : undefined
            sourceComponent: scrollBarBackground
            property bool horizontal: controlState.horizontal
            property bool hovered: activeControl !== "none"
        }

        Loader {
            id: decrementLoader
            anchors.bottom: controlState.horizontal ? undefined : parent.bottom
            anchors.right: controlState.horizontal ? parent.right : undefined
            sourceComponent: incrementControl
            property bool hovered: activeControl === "down"
            property bool pressed: controlState.downPressed
            property bool horizontal: controlState.horizontal
        }

        property var flickableItem: control.flickableItem
        property int extent: Math.max(minimumHandleLength, controlState.horizontal ?
                                          (flickableItem ? flickableItem.width/flickableItem.contentWidth : 0 ) * bg.width :
                                          (flickableItem ? flickableItem.height/flickableItem.contentHeight : 0) * bg.height)

        Loader {
            id: handleControl
            height: controlState.horizontal ? implicitHeight : extent
            width: controlState.horizontal ? extent : implicitWidth
            anchors.top: bg.top
            anchors.left: bg.left
            anchors.topMargin: controlState.horizontal ? 0 : -handleOverlap + (__control.value / __control.maximumValue) * (bg.height + 2 * handleOverlap- height)
            anchors.leftMargin: controlState.horizontal ? -handleOverlap + (__control.value / __control.maximumValue) * (bg.width + 2 * handleOverlap - width) : 0
            sourceComponent: handle
            property bool hovered: activeControl === "handle"
            property bool pressed: controlState.handlePressed
            property bool horizontal: controlState.horizontal
        }
    }

    /*! \internal */
    property bool __externalScrollBars: false
    /*! \internal */
    property int __scrollBarSpacing: 4
}
