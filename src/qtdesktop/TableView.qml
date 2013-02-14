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
   \qmltype TableView
   \inqmlmodule QtDesktop 1.0
   \ingroup tables
   \brief TableView is an extended ListView that provides column and header support.


 This component provides an item-view with resizable
 header sections.

 You can style the drawn delegate by overriding the itemDelegate
 property. The following properties are supported for custom
 delegates:

 Note: Currently only row selection is available for this component

\list
\li  itemHeight - default platform size of item
\li  itemWidth - default platform width of item
\li  itemSelected - if the row is currently selected
\li  itemValue - The text for this item
\li  itemForeground - The default text color for an item
\endlist

\code
 For example:
   itemDelegate: Item {
       Text {
           anchors.verticalCenter: parent.verticalCenter
           color: itemForeground
           elide: Text.ElideRight
           text: itemValue
        }
    }
\endcode

 Data for each row is provided through a model:

\code
 ListModel {
    ListElement{ column1: "value 1"; column2: "value 2"}
    ListElement{ column1: "value 3"; column2: "value 4"}
 }
\endcode

 You provide title and size properties on TableColumns
 by setting the default header property :

\code
 TableView {
    TableColumn{ role: "column1" ; title: "Column 1" ; width:100}
    TableColumn{ role: "column2" ; title: "Column 2" ; width:200}
    model: datamodel
 }
\endcode

 The header sections are attached to values in the datamodel by defining
 the listmodel property they attach to. Each property in the model, will
 then be shown in each column section.

 The view itself does not provide sorting. This has to
 be done on the model itself. However you can provide sorting
 on the model and enable sort indicators on headers.
\list
\li sortColumn - The index of the currently selected sort header
\li sortIndicatorVisible - If sort indicators should be enabled
\li sortIndicatorDirection - "up" or "down" depending on state
\endlist
*/

ScrollArea {
    id: root

    property variant model

    width: 200
    height: 200

    __scrollBarTopMargin: styleitem.style == "mac" ? headerrow.height : 0

    // Cosmetic properties
    property bool highlightOnFocus: false
    property bool alternateRowColor: true
    property bool headerVisible: true

    // Styling properties
    property Component itemDelegate: standardDelegate
    property Component rowDelegate: rowDelegate
    property Component headerDelegate: headerDelegate

    /*!
        \qmlproperty color ScrollArea:backgroundColor

        This property sets the background color of the viewport.

        The default value is the base color of the SystemPalette.

    */
    property alias backgroundColor: colorRect.color

    frame: true

    // Sort properties
    property int sortColumn // Index of currently selected sort column
    property bool sortIndicatorVisible: false // enables or disables sort indicator
    property string sortIndicatorDirection: "down" // "up" or "down" depending on current state

    // Item properties
    default property alias header: listView.columnheader
    property alias contentHeader: listView.header
    property alias contentFooter: listView.footer
    property alias currentItem: listView.currentItem

    // Viewport properties
    property alias count: listView.count
    property alias section: listView.section

    property alias currentIndex: listView.currentIndex // Should this be currentRowIndex?

    Accessible.role: Accessible.Table

    // Signals
    signal activated

    function decrementCurrentIndex() {
        __scroller.blockUpdates = true;
        listView.decrementCurrentIndex();
        __scroller.blockUpdates = false;
    }

    function incrementCurrentIndex() {
        __scroller.blockUpdates = true;
        listView.incrementCurrentIndex();
        __scroller.blockUpdates = false;
    }

    ListView {
        id: listView
        anchors.topMargin: headerrow.height
        anchors.fill: parent

        flickableDirection: Flickable.HorizontalFlick
        SystemPalette {
            id: palette
            colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
        }

        Rectangle {
            id: colorRect
            parent: viewport
            anchors.fill: parent
            color: palette.base
            z: -1
        }

        StyleItem {
            id: itemstyle
            elementType: "item"
            visible: false
        }

        MouseArea {
            id: mousearea

            anchors.fill: listView

            property bool autoincrement: false
            property bool autodecrement: false

            onReleased: {
                autoincrement = false
                autodecrement = false
            }

            // Handle vertical scrolling whem dragging mouse outside boundraries
            Timer { running: mousearea.autoincrement && __scroller.verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: incrementCurrentIndex()}
            Timer { running: mousearea.autodecrement && __scroller.verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: decrementCurrentIndex()}

            onPositionChanged: {
                if (mouseY > listView.height && pressed) {
                    if (autoincrement) return;
                    autodecrement = false;
                    autoincrement = true;
                } else if (mouseY < 0 && pressed) {
                    if (autodecrement) return;
                    autoincrement = false;
                    autodecrement = true;
                } else  {
                    autoincrement = false;
                    autodecrement = false;
                }
                var y = Math.min(flickableItem.contentY + listView.height - 5, Math.max(mouseY + flickableItem.contentY, flickableItem.contentY));
                var newIndex = listView.indexAt(0, y);
                if (newIndex >= 0)
                    listView.currentIndex = listView.indexAt(0, y);
            }

            onPressed:  {
                listView.forceActiveFocus()
                var x = Math.min(flickableItem.contentWidth - 5, Math.max(mouseX + flickableItem.contentX, 0))
                var y = Math.min(flickableItem.contentHeight - 5, Math.max(mouseY + flickableItem.contentY, 0))
                listView.currentIndex = listView.indexAt(x, y)
            }

            onDoubleClicked: { root.activated() }

            // Note by prevent stealing we are keeping the flickable from
            // eating our mouse press events
            preventStealing: true
        }

        // Fills extra rows with alternate color
        Column {
            id: rowfiller
            property int rowHeight: flickableItem.contentHeight/count
            property int paddedRowCount: height/rowHeight
            property int count: flickableItem.count
            y: flickableItem.contentHeight
            width: parent.width
            visible: flickableItem.contentHeight > 0 && alternateRowColor
            height: viewport.height - flickableItem.contentHeight
            Repeater {
                model: visible ? parent.paddedRowCount : 0
                Loader {
                    width: rowfiller.width
                    height: rowfiller.rowHeight
                    sourceComponent: root.rowDelegate
                    property bool itemAlternateBackground: (index + count) % 2 === 1
                    property bool itemSelected: false
                    property variant model: listView.model
                    property variant modelData: null
                }
            }
        }

        property list<TableColumn> columnheader
        highlightFollowsCurrentItem: true
        model: root.model

        Keys.onUpPressed: root.decrementCurrentIndex()
        Keys.onDownPressed: root.incrementCurrentIndex()

        Keys.onPressed: {
            if (event.key === Qt.Key_PageUp) {
                verticalScrollBar.value = __scroller.verticalScrollBar.value - listView.height
            } else if (event.key === Qt.Key_PageDown)
                verticalScrollBar.value = __scroller.verticalScrollBar.value + listView.height
        }

        Keys.onReturnPressed: root.activated();

        delegate: Item {
            id: rowitem
            width: row.width
            height: rowstyle.height

            property int rowIndex: model.index
            property bool itemAlternateBackground: alternateRowColor && rowIndex % 2 == 1
            property variant itemModelData: typeof modelData == "undefined" ? null : modelData
            property variant itemModel: model

            Loader {
                id: rowstyle
                // row delegate
                sourceComponent: root.rowDelegate
                // Row fills the tree width regardless of item size
                // But scrollbar should not adjust to it
                width: parent.width + __scroller.horizontalScrollBar.width
                x: flickableItem.contentX

                property bool itemAlternateBackground: rowitem.itemAlternateBackground
                property bool itemSelected: rowitem.ListView.isCurrentItem
                property int index: rowitem.rowIndex
                property variant model: listView.model
                property variant modelData: rowitem.itemModelData
                property variant itemModel: rowitem.itemModel
            }
            Row {
                id: row
                anchors.left: parent.left
                height: parent.height
                Repeater {
                    id: repeater
                    model: root.header.length
                    Loader {
                        id: itemDelegateLoader
                        height: parent.height
                        visible: header[index].visible
                        sourceComponent: header[index].delegate ? header[index].delegate : itemDelegate
                        property variant model: listView.model
                        property variant role: header[index].role
                        property variant modelData: itemModelData

                        width: header[index].width

                        function getValue() {
                            if (header[index].role.length && itemModel.hasOwnProperty(header[index].role))
                                return itemModel[header[index].role] // Qml ListModel and QAbstractItemModel
                            else if (modelData != undefined && modelData.hasOwnProperty(header[index].role))
                                return modelData[header[index].role] // QObjectList / QObject
                            else if (modelData != undefined)
                                return modelData // Models without role
                            else
                                return ""
                        }
                        property variant itemValue: getValue()
                        property bool itemSelected: rowitem.ListView.isCurrentItem
                        property color itemForeground: itemSelected ? rowstyleitem.highlightedTextColor : rowstyleitem.textColor
                        property int rowIndex: rowitem.rowIndex
                        property int columnIndex: index
                        property int itemElideMode: header[index].elideMode
                        property int itemTextAlignment: header[index].textAlignment
                    }
                }
                onWidthChanged: listView.contentWidth = width
            }
        }

        Text{ id:text }

        Item {
            id: tableHeader
            clip: true
            parent: __scroller
            visible: headerVisible
            anchors.top: parent.top
            anchors.margins: viewport.anchors.margins
            anchors.rightMargin: __scroller.frameWidth +
                                 (__scroller.outerFrame && __scrollBarTopMargin ? 0 : __scroller.verticalScrollBar.width
                                                          + __scroller.scrollBarSpacing)

            anchors.left: parent.left
            anchors.right: parent.right

            height: headerVisible ? headerrow.height : 0

            Behavior on height { NumberAnimation{ duration: 80 } }

            Row {
                id: headerrow
                x: -listView.contentX

                Repeater {
                    id: repeater

                    property int targetIndex: -1
                    property int dragIndex: -1

                    model: header.length

                    delegate: Item {
                        z:-index
                        width: header[index].width
                        visible: header[index].visible
                        height: headerStyle.height

                        Loader {
                            id: headerStyle
                            sourceComponent: root.headerDelegate
                            anchors.left: parent.left
                            anchors.right: parent.right
                            property string itemValue: header[index].title
                            property string itemSort:  (sortIndicatorVisible && index == sortColumn) ? (sortIndicatorDirection == "up" ? "up" : "down") : "";
                            property bool itemPressed: headerClickArea.pressed
                            property bool itemContainsMouse: headerClickArea.containsMouse
                            property string itemPosition: header.length === 1 ? "only" :
                                                                                index===header.length-1 ? "end" :
                                                                                                          index===0 ? "beginning" : ""
                        }
                        Rectangle{
                            id: targetmark
                            width: parent.width
                            height:parent.height
                            opacity: (index == repeater.targetIndex && repeater.targetIndex != repeater.dragIndex) ? 0.5 : 0
                            Behavior on opacity { NumberAnimation{duration:160}}
                            color: palette.highlight
                        }

                        MouseArea{
                            id: headerClickArea
                            drag.axis: Qt.YAxis
                            hoverEnabled: true
                            anchors.fill: parent
                            onClicked: {
                                if (sortColumn == index)
                                    sortIndicatorDirection = sortIndicatorDirection === "up" ? "down" : "up"
                                sortColumn = index
                            }
                            // Here we handle moving header sections
                            // NOTE: the direction is different from the master branch
                            // so this indicates that I am using an invalid assumption on item ordering
                            onPositionChanged: {
                                if (pressed) { // only do this while dragging
                                    for (var h = header.length-1 ; h >= 0 ; --h) {
                                        if (drag.target.x > headerrow.children[h].x) {
                                            repeater.targetIndex = h
                                            break
                                        }
                                    }
                                }
                            }

                            onPressed: {
                                repeater.dragIndex = index
                                draghandle.x = parent.x
                            }

                            onReleased: {
                                if (repeater.targetIndex >= 0 && repeater.targetIndex != index ) {
                                    // Rearrange the header sections
                                    var items = new Array
                                    for (var i = 0 ; i< header.length ; ++i)
                                        items.push(header[i])
                                    items.splice(index, 1);
                                    items.splice(repeater.targetIndex, 0, header[index]);
                                    header = items
                                    if (sortColumn == index)
                                        sortColumn = repeater.targetIndex
                                }
                                repeater.targetIndex = -1
                            }
                            drag.maximumX: 1000
                            drag.minimumX: -1000
                            drag.target: draghandle
                        }

                        Loader {
                            id: draghandle
                            property string itemValue: header[index].title
                            property string itemSort:  (sortIndicatorVisible && index == sortColumn) ? (sortIndicatorDirection == "up" ? "up" : "down") : "";
                            property bool itemPressed: headerClickArea.pressed
                            property bool itemContainsMouse: headerClickArea.containsMouse
                            property string itemPosition

                            parent: tableHeader
                            width: header[index].width
                            height: parent.height
                            sourceComponent: root.headerDelegate
                            visible: headerClickArea.pressed
                            opacity: 0.5
                        }


                        MouseArea {
                            id: headerResizeHandle
                            property int offset: 0
                            property int minimumSize: 20
                            anchors.rightMargin: -width/2
                            width: 16 ; height: parent.height
                            anchors.right: parent.right
                            onPositionChanged:  {
                                var newHeaderWidth = header[index].width + (mouseX - offset)
                                header[index].width = Math.max(minimumSize, newHeaderWidth)
                            }
                            property bool found:false

                            onDoubleClicked: {
                                var row
                                var minWidth =  0
                                var listdata = listView.children[0]
                                for (row = 0 ; row < listdata.children.length ; ++row){
                                    var item = listdata.children[row+1]
                                    if (item && item.children[1] && item.children[1].children[index] &&
                                            item.children[1].children[index].children[0].hasOwnProperty("implicitWidth"))
                                        minWidth = Math.max(minWidth, item.children[1].children[index].children[0].implicitWidth)
                                }
                                if (minWidth)
                                    header[index].width = minWidth
                            }
                            onPressedChanged: if (pressed) offset=mouseX
                            cursorShape: Qt.SplitHCursor
                        }
                    }
                }
            }
            Loader {
                id: loader
                property string itemValue
                property string itemSort
                property bool itemPressed
                property bool itemContainsMouse
                property string itemPosition

                anchors.top: parent.top
                anchors.right: parent.right
                anchors.bottom: headerrow.bottom
                anchors.rightMargin: -2
                sourceComponent: root.headerDelegate
                width: root.width - headerrow.width + 2
                visible: root.header.length
                z:-1
            }

            Component {
                id: standardDelegate
                Item {
                    height: Math.max(16, styleitem.implicitHeight)
                    property int implicitWidth: sizehint.paintedWidth + 4
                    Text {
                        id: label
                        objectName: "label"
                        width: parent.width
                        anchors.margins: 6
                        font: itemstyle.font
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: itemTextAlignment
                        anchors.verticalCenter: parent.verticalCenter
                        elide: itemElideMode
                        text: itemValue != undefined ? itemValue : ""
                        color: itemForeground
                        renderType: Text.NativeRendering
                    }
                    Text {
                        id: sizehint
                        font: label.font
                        text: itemValue ? itemValue : ""
                        visible: false
                    }
                }
            }

            Component {
                id: nativeDelegate
                // This gives more native styling, but might be less performant
                StyleItem {
                    elementType: "item"
                    text:   itemValue
                    selected: itemSelected
                    active: root.activeFocus
                }
            }

            Component {
                id: headerDelegate
                StyleItem {
                    elementType: "header"
                    activeControl: itemSort
                    raised: true
                    sunken: itemPressed
                    text: itemValue
                    hover: itemContainsMouse
                    hints: itemPosition
                }
            }

            Component {
                id: rowDelegate
                StyleItem {
                    id: rowstyle
                    elementType: "itemrow"
                    activeControl: itemAlternateBackground ? "alternate" : ""
                    selected: itemSelected ? true : false
                    height: Math.max(16, styleitem.implicitHeight)
                    active: root.activeFocus
                }
            }

            StyleItem {
                id: styleitem
                elementType: "header"
                visible:false
                contentWidth: 16
                contentHeight: font.pixelSize
            }

            StyleItem {
                id: rowstyleitem
                property color textColor: styleHint("textColor")
                property color highlightedTextColor: styleHint("highlightedTextColor")
                elementType: "item"
                visible: false
            }
        }
    }
}
