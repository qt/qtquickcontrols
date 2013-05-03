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
    \qmltype ScrollBarStyle
    \internal
    \inqmlmodule QtQuick.Controls.Styles 1.0
    \brief provides custom styling for scroll bars

    The ScrollBar style can only be set as part of a
    a \l ScrollViewStyle.
*/
Style {
    id: styleitem

    /*! This is the current orientation of the scroll bar. */
    readonly property bool horizontal: control.orientation === Qt.Horizontal

    /*! This property determines if the scrollBar should directly move to
        the offset that is clicked by the user or if it should simply increment
        or decrement it's position.

        The default value is \cfalse.
    */
    property bool scrollToClickPosition: true

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
    */
    property Component background: Item {
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
    */
    property Component handle: Item {
        implicitWidth: 16
        implicitHeight: 16
        Rectangle {
            anchors.fill: parent
            color: mouseOver ? "#ddd" : "lightgray"
            border.color: "#aaa"
            anchors.rightMargin: horizontal ? 0 : -1
            anchors.bottomMargin: horizontal ? -1 : 0
            Rectangle {
                anchors.fill: parent
                anchors.margins: 1
                color: "transparent"
                border.color: "#44ffffff"
            }
        }
    }

    /*! This component controls the appearance of the
        scroll bar increment button.
    */
    property Component incrementControl: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        Rectangle {
            anchors.fill: parent
            anchors.bottomMargin: -1
            anchors.rightMargin: -1
            border.color: "#aaa"
            Image {
                source: horizontal ? "images/arrow-right.png" : "images/arrow-down.png"
                anchors.centerIn: parent
                opacity: 0.7
            }
            gradient: Gradient {
                GradientStop {color: control.downPressed ? "lightgray" : "white" ; position: 0}
                GradientStop {color: control.downPressed ? "lightgray" : "lightgray" ; position: 1}
            }
        }
    }

    /*! This component controls the appearance of the
        scroll bar decrement button.
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
            Image {
                source: horizontal ? "images/arrow-left.png" : "images/arrow-up.png"
                anchors.centerIn: parent
                anchors.verticalCenterOffset: horizontal ? 0 : -1
                anchors.horizontalCenterOffset: horizontal ? -1 : 0
                opacity: 0.7
            }
            gradient: Gradient {
                GradientStop {color: control.upPressed ? "lightgray" : "white" ; position: 0}
                GradientStop {color: control.upPressed ? "lightgray" : "lightgray" ; position: 1}
            }
            border.color: "#aaa"
        }
    }

    /*! \internal */
    property Component panel: Item {

        property string activeControl: ""

        implicitWidth: horizontal ? 200 : bg.implicitWidth
        implicitHeight: horizontal ? bg.implicitHeight : 200

        function pixelMetric(arg) {
            if (arg === "scrollbarExtent")
                return (styleitem.horizontal ? bg.height : bg.width);
            return 0;
        }

        function styleHint(arg) {
            return false;
        }

        function hitTest(argX, argY) {
            if (itemIsHit(handleControl, argX, argY))
                return "handle"
            else if (itemIsHit(upControl, argX, argY))
                return "up";
            else if (itemIsHit(downControl, argX, argY))
                return "down";
            else if (itemIsHit(bg, argX, argY)) {
                if (styleitem.horizontal && argX < handleControl.x || !styleitem.horizontal && argY < handleControl.y)
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
                if (styleitem.horizontal) {
                    return Qt.rect(upControl.width - styleitem.handleOverlap,
                                   0,
                                   control.width - (upControl.width + downControl.width - styleitem.handleOverlap * 2),
                                   control.height);
                } else {
                    return Qt.rect(0,
                                   upControl.height - styleitem.handleOverlap,
                                   control.width,
                                   control.height - (upControl.height + downControl.height - styleitem.handleOverlap * 2));
                }
            }
            return Qt.rect(0,0,0,0);
        }

        function itemIsHit(argItem, argX, argY) {
            var pos = argItem.mapFromItem(control, argX, argY);
            return (pos.x >= 0 && pos.x <= argItem.width && pos.y >= 0 && pos.y <= argItem.height);
        }

        Loader {
            id: upControl
            anchors.top: parent.top
            anchors.left: parent.left
            sourceComponent: decrementControl
            property bool mouseOver: activeControl === "up"
            property bool pressed: control.upPressed
        }

        Loader {
            id: bg
            anchors.top: horizontal ? undefined : upControl.bottom
            anchors.bottom: horizontal ? undefined : downControl.top
            anchors.left:  horizontal ? upControl.right : undefined
            anchors.right: horizontal ? downControl.left : undefined
            sourceComponent: background
        }

        Loader {
            id: downControl
            anchors.bottom: horizontal ? undefined : parent.bottom
            anchors.right: horizontal ? parent.right : undefined
            sourceComponent: incrementControl
            property bool mouseOver: activeControl === "down"
            property bool pressed: control.downPressed
        }

        Loader{
            id: handleControl
            property bool mouseOver: activeControl === "handle"
            property var flickableItem: control.parent.parent.flickableItem
            property int extent: Math.max(minimumHandleLength, horizontal ?
                                              (flickableItem.width/flickableItem.contentWidth) * bg.width :
                                              (flickableItem.height/flickableItem.contentHeight) * bg.height)
            height: horizontal ? implicitHeight : extent
            width: horizontal ? extent : implicitWidth
            anchors.top: bg.top
            anchors.left: bg.left
            anchors.topMargin: horizontal ? 0 : -handleOverlap + (control.value / control.maximumValue) * (bg.height + 2 * handleOverlap- height)
            anchors.leftMargin: horizontal ? -handleOverlap + (control.value / control.maximumValue) * (bg.width + 2 * handleOverlap - width) : 0
            sourceComponent: handle
        }
    }
}
