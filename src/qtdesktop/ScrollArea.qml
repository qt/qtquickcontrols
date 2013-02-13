/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
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

import QtQuick 2.0
import QtDesktop 1.0
import QtDesktop.Private 1.0

/*!
    \qmltype ScrollArea
    \inqmlmodule QtDesktop 1.0
    \ingroup navigation
    \brief The ScrollArea class provides a scrolling view onto another Item.

    A ScrollArea can be used either instead of a \l Flickable or to decorate an
    existing Flickable. Depending on the platform it will add scroll bars and
    a content frame.

    Only one Item can be a direct child of the ScrollArea and the child is implicitly anchored
    to fill the scroll view.

    Example:
    \code
    ScrollArea {
        Image { imageSource: "largeImage.png" }
    }
    \endcode

    In the previous example the Image item will implicitly get scroll behavior as if it was
    used within a \l Flickable. The width and height of the child item will be used to
    define the size of the content area.

    Example:
    \code
    ScrollArea {
        ListView {
            ...
        }
    }
    \endcode

    In this case the content size of the ScrollArea will simply mirror that of its contained
    \l flickableItem.

*/

FocusScope {
    id: root
    width: 100
    height: 100

    /*!
        This property tells the scroll area if it should render
        a frame around it's content.

        The default value is \c false
    */
    property bool frame: false

    /*!
        This property controls if there should be a highlight
        around the frame when the ScrollArea has input focus.

        The default value is \c false

        \note This property is only applicable on some platforms, such
        as Mac OS.
    */
    property bool highlightOnFocus: false

    /*!
        \qmlproperty Item ScrollArea::viewport

        The viewport determines the current "window" on to the contentItem.
        In other words it clips it and the size of the viewport tells you
        how much of the content area is visible.
    */
    property alias viewport: viewportItem

    /*!
        \qmlproperty Item ScrollArea::flickableItem

        The flickableItem of the ScrollArea. If the contentItem provided
        to the ScrollArea is a Flickable, it will be the \l contentItem.
    */
    readonly property alias flickableItem: internal.flickableItem

    /*!
        The contentItem of the ScrollArea. This is set by the user.

        Note that the definition of contentItem is somewhat different to that
        of a Flickable, where the contentItem is implicitly created.
    */
    default property Item contentItem

    /*! \internal */
    property Item __scroller: scroller
    /*! \internal */
    property int __scrollBarTopMargin: 0
    /*! \internal */
    property alias horizontalScrollBar: scroller.horizontalScrollBar
    /*! \internal */
    property alias verticalScrollBar: scroller.verticalScrollBar

    /*! \internal */
    onContentItemChanged: {

        if (contentItem.hasOwnProperty("contentY") && // Check if flickable
                contentItem.hasOwnProperty("contentHeight")) {
            internal.flickableItem = contentItem // "Use content if it is a flickable
        } else {
            internal.flickableItem = flickableComponent.createObject(this)
            contentItem.parent = flickableItem.contentItem
        }
        internal.flickableItem.parent = viewportItem
        internal.flickableItem.anchors.fill = viewportItem
    }


    children: Item {
        id: internal

        property Flickable flickableItem

        Binding {
            target: flickableItem
            property: "contentHeight"
            when: contentItem !== flickableItem
            value: contentItem ? contentItem.height : 0
        }

        Binding {
            target: flickableItem
            when: contentItem !== flickableItem
            property: "contentWidth"
            value: contentItem ? contentItem.width : 0
        }

        Connections {
            target: flickableItem

            onContentYChanged:  {
                scroller.blockUpdates = true
                scroller.verticalScrollBar.value = flickableItem.contentY
                scroller.blockUpdates = false
            }

            onContentXChanged:  {
                scroller.blockUpdates = true
                scroller.horizontalScrollBar.value = flickableItem.contentX
                scroller.blockUpdates = false
            }

        }

        anchors.fill: parent

        Component {
            id: flickableComponent
            Flickable {}
        }

        WheelArea {
            parent: flickableItem

            // ### Note this is needed due to broken mousewheel behavior in Flickable.

            anchors.fill: parent

            property int acceleration: 40
            property int flickThreshold: 20
            property double speedThreshold: 3
            property double ignored: 0.001 // ## flick() does not work with 0 yVelocity
            property int maxFlick: 400

            horizontalMaximumValue: flickableItem ? flickableItem.contentWidth - viewport.width : 0
            verticalMaximumValue: flickableItem ? flickableItem.contentHeight - viewport.height : 0

            onVerticalValueChanged: {
                if (flickableItem.contentY < flickThreshold && verticalDelta > speedThreshold) {
                    flickableItem.flick(ignored, Math.min(maxFlick, acceleration * verticalDelta))
                } else if (flickableItem.contentY > flickableItem.contentHeight
                           - flickThreshold - viewport.height && verticalDelta < -speedThreshold) {
                    flickableItem.flick(ignored, Math.max(-maxFlick, acceleration * verticalDelta))
                } else {
                    flickableItem.contentY = verticalValue
                }
            }

            onHorizontalValueChanged: flickableItem.contentX = horizontalValue
        }

        ScrollAreaHelper {
            id: scroller
            anchors.fill: parent
            property int frameWidth: frame ? styleitem.pixelMetric("defaultframewidth") : 0
            property bool outerFrame: !frame || !styleitem.styleHint("frameOnlyAroundContents")
            property int scrollBarSpacing: outerFrame ? 0 : styleitem.pixelMetric("scrollbarspacing")
            property int verticalScrollbarOffset: verticalScrollBar.visible && !verticalScrollBar.isTransient ?
                                                      verticalScrollBar.width + scrollBarSpacing : 0
            property int horizontalScrollbarOffset: horizontalScrollBar.visible && !horizontalScrollBar.isTransient ?
                                                        horizontalScrollBar.height + scrollBarSpacing : 0

            StyleItem {
                id: styleitem
                elementType: "frame"
                sunken: true
                visible: frame
                anchors.fill: parent
                anchors.rightMargin: scroller.outerFrame ? 0 : scroller.verticalScrollbarOffset
                anchors.bottomMargin: scroller.outerFrame ? 0 : scroller.horizontalScrollbarOffset
            }

            Item {
                id: viewportItem
                anchors.fill: styleitem
                anchors.margins: scroller.frameWidth
                anchors.rightMargin: scroller.frameWidth + (scroller.outerFrame ? scroller.verticalScrollbarOffset : 0)
                anchors.bottomMargin: scroller.frameWidth + (scroller.outerFrame ? scroller.horizontalScrollbarOffset : 0)
                clip: true
            }
        }
        FocusFrame { visible: highlightOnFocus && area.activeFocus }
    }
}
