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
import "private" as Private

/*!
    \qmltype TableView
    \inqmlmodule QtDesktop 1.0
    \brief TableView is doing bla...bla...
*/

/*
*
* TableView
*
* This component provides an item-view with resizable
* header sections.
*
* You can style the drawn delegate by overriding the itemDelegate
* property. The following properties are supported for custom
* delegates:
*
* Note: Currently only row selection is available for this component
*
* itemheight - default platform size of item
* itemwidth - default platform width of item
* itemselected - if the row is currently selected
* itemvalue - The text for this item
* itemforeground - The default text color for an item
*
* For example:
*   itemDelegate: Item {
*       Text {
*           anchors.verticalCenter: parent.verticalCenter
*           color: itemForeground
*           elide: Text.ElideRight
*           text: itemValue
*        }
*    }
*
* Data for each row is provided through a model:
*
* ListModel {
*    ListElement{ column1: "value 1"; column2: "value 2"}
*    ListElement{ column1: "value 3"; column2: "value 4"}
* }
*
* You provide title and size properties on TableColumns
* by setting the default header property :
*
* TableView {
*    TableColumn{ role: "column1" ; title: "Column 1" ; width:100}
*    TableColumn{ role: "column2" ; title: "Column 2" ; width:200}
*    model: datamodel
* }
*
* The header sections are attached to values in the datamodel by defining
* the listmodel property they attach to. Each property in the model, will
* then be shown in each column section.
*
* The view itself does not provide sorting. This has to
* be done on the model itself. However you can provide sorting
* on the model and enable sort indicators on headers.
*
* sortColumn - The index of the currently selected sort header
* sortIndicatorVisible - If sort indicators should be enabled
* sortIndicatorDirection - "up" or "down" depending on state
*
*/

FocusScope{
    id: root

    property variant model

    // Framewidth seems to be 1 regardless of style
    property int frameWidth: frame ? frameitem.frameWidth : 0;
    width: 200
    height: 200

    // Cosmetic properties
    property bool frame: true
    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")
    property bool highlightOnFocus: false
    property bool alternateRowColor: true
    property bool headerVisible: true

    // Styling properties
    property Component itemDelegate: standardDelegate
    property Component rowDelegate: rowDelegate
    property Component headerDelegate: headerDelegate
    property color backgroundColor: "white"

    // Sort properties
    property int sortColumn // Index of currently selected sort column
    property bool sortIndicatorVisible: false // enables or disables sort indicator
    property string sortIndicatorDirection: "down" // "up" or "down" depending on current state

    // Item properties
    default property alias header: tree.columnheader
    property alias contentHeader: tree.header
    property alias contentFooter: tree.footer

    property alias horizontalScrollBar: scroller.horizontalScrollBar
    property alias verticalScrollBar: scroller.verticalScrollBar

    // Viewport properties
    property alias contentX: tree.contentX
    property alias contentY: tree.contentY
    property alias contentHeight : tree.contentHeight
    property alias contentWidth: tree.contentWidth
    property alias viewportWidth: scroller.availableWidth
    property alias viewportHeight: scroller.availableHeight
    property alias count: tree.count
    property alias section: tree.section

    property alias cacheBuffer: tree.cacheBuffer
    property alias currentIndex: tree.currentIndex // Should this be currentRowIndex?

    Accessible.role: Accessible.Table

    // Signals
    signal activated

    Component {
        id: standardDelegate
        Item {
            height: Math.max(16, styleitem.implicitHeight)
            property int implicitWidth: sizehint.paintedWidth + 4
            Text {
                id: label
                width: parent.width
                anchors.margins: 6
                font: itemstyle.font
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: itemTextAlignment
                anchors.verticalCenter: parent.verticalCenter
                elide: itemElideMode
                text: itemValue ? itemValue : ""
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

    StyleItem {
        id: itemstyle
        elementType: "item"
        visible:false
    }

    Component {
        id: nativeDelegate
        // This gives more native styling, but might be less performant
        StyleItem {
            elementType: "item"
            text:   itemValue
            selected: itemSelected
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
            info: itemPosition
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
        }
    }

    Rectangle {
        id: colorRect
        color: backgroundColor
        anchors.fill: frameitem
        anchors.margins: frameWidth
        anchors.rightMargin: (!frameAroundContents && verticalScrollBar.visible ? verticalScrollBar.width : 0) + frameWidth
        anchors.bottomMargin: (!frameAroundContents && horizontalScrollBar.visible ? horizontalScrollBar.height : 0) +frameWidth
    }

    StyleItem {
        id: frameitem
        elementType: "frame"
        Component.onCompleted: frameWidth = styleitem.pixelMetric("defaultframewidth");
        sunken: true
        visible: frame
        anchors.fill: parent
        anchors.rightMargin: frame ? (frameAroundContents ? (verticalScrollBar.visible ? verticalScrollBar.width + 2 * frameMargins : 0) : 0) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (horizontalScrollBar.visible ? horizontalScrollBar.height + 2 * frameMargins : 0) : 0) : 0
        anchors.topMargin: frame ? frameAroundContents : 0
        anchors.leftMargin: frame ? frameAroundContents : 0
        property int frameWidth
        property int scrollbarspacing: styleitem.pixelMetric("scrollbarspacing");
        property int frameMargins : frame ? scrollbarspacing : 0
    }
    MouseArea {
        id: mousearea

        anchors.fill: tree

        property bool autoincrement: false
        property bool autodecrement: false

        onReleased: {
            autoincrement = false
            autodecrement = false
        }

        // Handle vertical scrolling whem dragging mouse outside boundraries
        Timer { running: mousearea.autoincrement && verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: incrementCurrentIndex()}
        Timer { running: mousearea.autodecrement && verticalScrollBar.visible; repeat: true; interval: 20 ; onTriggered: decrementCurrentIndex()}

        onPositionChanged: {
            if (mouseY > tree.height && pressed) {
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
            var y = Math.min(contentY + tree.height - 5, Math.max(mouseY + contentY, contentY));
            var newIndex = tree.indexAt(0, y);
            if (newIndex >= 0)
                tree.currentIndex = tree.indexAt(0, y);
        }

        onPressed:  {
            tree.forceActiveFocus()
            var x = Math.min(contentWidth - 5, Math.max(mouseX + contentX, 0))
            var y = Math.min(contentHeight - 5, Math.max(mouseY + contentY, 0))
            tree.currentIndex = tree.indexAt(x, y)
        }

        onDoubleClicked: {
            parent.activated()
        }
    }

    function decrementCurrentIndex() {
        scroller.blockUpdates = true;
        tree.decrementCurrentIndex();
        scroller.verticalValue = contentY;
        scroller.blockUpdates = false;
    }

    function incrementCurrentIndex() {
        scroller.blockUpdates = true;
        tree.incrementCurrentIndex();
        scroller.verticalValue = contentY;
        scroller.blockUpdates = false;
    }

    ListView {
        id: tree

        property list<TableColumn> columnheader
        highlightFollowsCurrentItem: true
        model: root.model
        interactive: false

        anchors.top: tableColumn.bottom
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.bottom: frameitem.bottom
        anchors.margins: frameWidth
        anchors.topMargin: -frameWidth
        anchors.rightMargin: (!frameAroundContents && verticalScrollBar.visible ? verticalScrollBar.width: 0) + frameWidth
        anchors.bottomMargin: (!frameAroundContents && horizontalScrollBar.visible ? horizontalScrollBar.height : 0)  + frameWidth

        focus: true
        clip: true

        // Fills extra rows with alternate color
        Column {
            id: rowfiller
            property variant rowHeight: Math.max(1, contentHeight / count)
            property int rowCount: height/rowHeight
            y: contentHeight
            width: parent.width
            visible: contentHeight > 0 && alternateRowColor && !verticalScrollBar.visible
            height: parent.height - contentHeight
            Repeater {
                model: visible ? rowfiller.rowCount : 0
                Loader {
                    width: rowfiller.width
                    height: rowfiller.rowHeight
                    sourceComponent: root.rowDelegate
                    property bool itemAlternateBackground: (index + count) % 2 === 1
                    property bool itemSelected: false
                    property variant model: tree.model
                    property variant modelData: null
                }
            }
        }

        Keys.onUpPressed: root.decrementCurrentIndex()
        Keys.onDownPressed: root.incrementCurrentIndex()

        Keys.onPressed: {
            if (event.key == Qt.Key_PageUp) {
                verticalScrollBar.value = verticalScrollBar.value - tree.height
            } else if (event.key == Qt.Key_PageDown)
                verticalScrollBar.value = verticalScrollBar.value + tree.height
        }

        Keys.onReturnPressed: root.activated();

        onContentYChanged:  {
            scroller.blockUpdates = true
            scroller.verticalValue = tree.contentY
            verticalScrollBar.value = tree.contentY
            scroller.blockUpdates = false
        }

        onContentXChanged:  {
            scroller.blockUpdates = true
            scroller.horizontalValue = tree.contentX
            horizontalScrollBar.value = tree.contentX
            scroller.blockUpdates = false
        }

        delegate: Item {
            id: rowitem
            width: row.width
            height: rowstyle.height

            anchors.margins: frameWidth
            property int rowIndex: model.index
            property bool itemAlternateBackground: alternateRowColor && rowIndex % 2 == 1
            property variant itemModelData: typeof modelData == "undefined" ? null : modelData

            Loader {
                id: rowstyle
                // row delegate
                sourceComponent: root.rowDelegate
                // Row fills the tree width regardless of item size
                // But scrollbar should not adjust to it
                width: frameitem.width
                x: contentX

                property bool itemAlternateBackground: rowitem.itemAlternateBackground
                property bool itemSelected: rowitem.ListView.isCurrentItem
                property int index: rowitem.rowIndex
                property variant model: tree.model
                property variant modelData: rowitem.itemModelData
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
                        property variant model: tree.model
                        property variant role: header[index].role
                        property variant modelData: itemModelData

                        width: header[index].width

                        function getValue() {
                            if (header[index].role.length && model.get && model.get(rowIndex)[header[index].role])
                                return model.get(rowIndex)[header[index].role]
                            else if (modelData && modelData.hasOwnProperty(header[index].role))
                                return modelData[header[index].role]
                            else if (modelData)
                                return modelData
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
                onWidthChanged: tree.contentWidth = width
            }
        }
    }


    Text{ id:text }

    Item {
        id: tableColumn

        anchors.top: frameitem.top
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.margins: frameWidth

        clip: true
        visible: headerVisible
        height: headerVisible ? headerrow.height : frameWidth

        Behavior on height { NumberAnimation{ duration: 80 } }

        Row {
            id: headerrow
            anchors.top: parent.top
            x: -tree.contentX

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
                        SystemPalette{id:palette}
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
                        // so this indicates that Im using an invalid assumption on item ordering
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

                        parent: tableColumn
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
                            var listdata = tree.children[0]
                            for (row = 0 ; row < listdata.children.length ; ++row){
                                var item = listdata.children[row+1]
                                if (item && item.children[1] && item.children[1].children[index] &&
                                        item.children[1].children[index].children[0].hasOwnProperty("implicitWidth"))
                                    minWidth = Math.max(minWidth, item.children[1].children[index].children[0].implicitWidth)
                            }
                            if (minWidth)
                                header[index].width = minWidth
                        }
                        onPressedChanged: if(pressed)offset=mouseX
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
    }

    Private.ScrollAreaHelper {
        id: scroller
        anchors.fill: parent
        anchors.topMargin: styleitem.style == "mac" ? tableColumn.height + frameWidth: 0
        scrollSpeed: 2
    }

    StyleItem {
        z: 2
        anchors.fill: parent
        anchors.margins: -4
        visible: highlightOnFocus && parent.activeFocus && styleitem.styleHint("focuswidget")
        elementType: "focusframe"
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
