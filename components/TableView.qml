import QtQuick 1.0
import "../components"
import "../components/plugin"

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
* You provide title and size properties on headersections
* by setting the default header property :
*
* TableView {
*    HeaderSeciton{ property: "column1" ; caption: "Column 1" ; width:100}
*    HeaderSection{ property: "column2" ; caption: "Column 2" ; width:200}
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
    property int frameWidth: frame ? styleitem.pixelMetric("defaultframewidth") : 0;
    property alias contentHeight : tree.contentHeight
    property alias contentWidth: tree.contentWidth
    property bool frame: true
    property bool highlightOnFocus: false
    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")

    property int sortColumn: 0  // Index of currently selected sort header
    property bool sortIndicatorVisible: true // enables or disables sort indicator
    property string sortIndicatorDirection: "down" // "up" or "down" depending on current state

    property bool alternateRowColor: true
    property alias contentX: tree.contentX
    property alias contentY: tree.contentY
    property int headerHeight: headerrow.height

    property Component itemDelegate: standardDelegate
    property Component rowDelegate: rowDelegate
    property Component headerDelegate: headerDelegate

    default property alias header: tree.header


    Component {
        id: standardDelegate
        Item {
            Text {
                anchors.fill: parent
                anchors.margins: 2
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                text: itemValue ? itemValue : ""
                color: itemForeground
            }
        }
    }

    Component {
        id: nativeDelegate
        // This gives more native styling, but might be less performant
        QStyleItem {
            elementType: "item"
            text:   itemValue
            selected: itemSelected
        }
    }

    Component {
        id: headerDelegate
        QStyleItem {
            elementType: "header"
            activeControl: itemSort
            raised: true
            sunken: itemPressed
            text: itemValue
            hover: itemContainsMouse
        }
    }
    Component {
        id: rowDelegate
        QStyleItem {
            id: rowstyle
            elementType: "itemrow"
            activeControl: itemAlternateBackground ? "alternate" : ""
            selected: itemSelected ? "true" : "false"
        }
    }

    Rectangle {
        id: colorRect
        color: "white"
        anchors.fill: frameitem
        anchors.margins: frameWidth
        anchors.rightMargin: (!frameAroundContents && vscrollbar.visible ? vscrollbar.width : 0) + frameWidth
        anchors.bottomMargin: (!frameAroundContents && hscrollbar.visible ? hscrollbar.height : 0) +frameWidth
    }

    QStyleItem {
        id: frameitem
        elementType: "frame"
        onElementTypeChanged: scrollarea.frameWidth = styleitem.pixelMetric("defaultframewidth");
        sunken: true
        visible: frame
        anchors.fill: parent
        anchors.rightMargin: frame ? (frameAroundContents ? (vscrollbar.visible ? vscrollbar.width + 2 * frameMargins : 0) : -frameWidth) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (hscrollbar.visible ? hscrollbar.height + 2 * frameMargins : 0) : -frameWidth) : 0
        anchors.topMargin: frame ? (frameAroundContents ? 0 : -frameWidth) : 0
        property int scrollbarspacing: styleitem.pixelMetric("scrollbarspacing");
        property int frameMargins : frame ? scrollbarspacing : 0
    }

    ListView {
        id: tree
        property list<HeaderSection> header

        model: root.model

        MouseArea {
            id: mousearea

            anchors.fill: parent

            property bool autoincrement: false;
            property bool autodecrement: false;

            onReleased: {
                autoincrement = false
                autodecrement = false
            }

            // Handle vertical scrolling whem dragging mouse outside boundraries

            Timer { running: mousearea.autoincrement; repeat: true; interval: 40 ; onTriggered: tree.incrementCurrentIndex()}
            Timer { running: mousearea.autodecrement; repeat: true; interval: 40 ; onTriggered: tree.decrementCurrentIndex()}

            onMousePositionChanged: {
                if (mouseY > tree.height) {
                    autodecrement = false
                    autoincrement = true
                } else if (mouseY < 0) {
                    autoincrement = false
                    autodecrement = true
                } else {
                    var x = Math.min(contentWidth - 5, Math.max(mouseX + contentX, 0))
                    var y = Math.min(contentHeight - 5, Math.max(mouseY + contentY, 0))
                    tree.currentIndex = tree.indexAt(x, y)
                    autoincrement = false
                    autodecrement = false
                }
            }
            onPressed:  {
                tree.forceActiveFocus()
                var x = Math.min(contentWidth - 5, Math.max(mouseX + contentX, 0))
                var y = Math.min(contentHeight - 5, Math.max(mouseY + contentY, 0))
                tree.currentIndex = tree.indexAt(x, y)
            }
        }

        interactive: false
        anchors.top: headersection.bottom
        anchors.topMargin: -frameWidth
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.bottom: frameitem.bottom
        anchors.margins: frameWidth

        anchors.rightMargin: (!frameAroundContents && vscrollbar.visible ? vscrollbar.width: 0) + frameWidth
        anchors.bottomMargin: (!frameAroundContents && hscrollbar.visible ? hscrollbar.height : 0)  + frameWidth

        focus: true
        clip: true

        Keys.onUpPressed: if (currentIndex > 0) currentIndex = currentIndex - 1
        Keys.onDownPressed: if (currentIndex< count - 1) currentIndex = currentIndex + 1

        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex, ListView.Contain)
            vscrollbar.value = tree.contentY
        }

        delegate: Item {
            id: rowitem
            width: row.width
            height: row.height
            anchors.margins: frameWidth
            property int rowIndex: model.index
            property bool itemAlternateBackground: alternateRowColor && rowIndex % 2 == 1
            Loader {
                id: rowstyle
                // row delegate
                sourceComponent: root.rowDelegate
                // Row fills the tree width regardless of item size
                // But scrollbar should not adjust to it
                width: frameitem.width
                x: contentX
                height: row.height

                property bool itemAlternateBackground: rowitem.itemAlternateBackground
                property bool itemSelected: rowitem.ListView.isCurrentItem
            }
            Row {
                id: row
                anchors.left: parent.left
                Repeater {
                    id: repeater
                    model: root.header.length
                    Loader {
                        id: itemDelegateLoader
                        visible: header[index].visible
                        sourceComponent: itemDelegate
                        width: header[index].width
                        height: Math.max(16, styleitem.sizeFromContents(16, 16).height)

                        function getValue() {
                            if (index < header.length &&
                                root.model.get(rowIndex).hasOwnProperty(header[index].property))
                                return root.model.get(rowIndex)[ header[index].property]
                        }
                        property variant itemValue: root.model.get(rowIndex)[ header[index].property]
                        property bool itemSelected: rowitem.ListView.isCurrentItem
                        property color itemForeground: itemSelected ? rowstyleitem.highlightedTextColor : rowstyleitem.textColor
                        property int rowIndex: rowitem.rowIndex
                        property int columnIndex: index
                    }
                }
                onWidthChanged: tree.contentWidth = width
            }
        }
    }
    Text{ id:text }

    Item {
        id: headersection
        clip: true
        anchors.top: frameitem.top
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.margins: frameWidth
        height: styleitem.sizeFromContents(text.font.pixelSize, styleitem.fontHeight).height

        Row {
            id: headerrow

            x: -tree.contentX
            anchors.top: parent.top
            height:parent.height
            Repeater {
                model: header.length
                delegate: Item {
                    z:-index
                    width: header[index].width
                    visible: header[index].visible
                    height: parent.height

                    Loader {
                        sourceComponent: root.headerDelegate
                        anchors.fill: parent
                        property string itemValue: header[index].caption
                        property string itemSort:  (sortIndicatorVisible && index == sortColumn) ? (sortIndicatorDirection == "up" ? "up" : "down") : "";
                        property bool itemPressed: headerClickArea.pressed
                        property bool itemContainsMouse: headerClickArea.containsMouse
                    }

                    MouseArea{
                        id: headerClickArea
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: {
                            if (sortColumn == index)
                                sortIndicatorDirection = sortIndicatorDirection === "up" ? "down" : "up"
                            sortColumn = index
                        }
                    }

                    MouseArea{
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
                        onPressedChanged: if(pressed)offset=mouseX
                        QStyleItem {
                            anchors.fill: parent
                            cursor: "splithcursor"
                        }
                    }
                }
            }
        }
        Loader {
            id: loader
            z:-1
            sourceComponent: root.headerDelegate
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: headerrow.bottom
            anchors.rightMargin: -2
            width: root.width - headerrow.width
            property string itemValue
            property string itemSort
            property bool itemPressed
            property bool itemContainsMouse
        }
    }
    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        property int availableWidth: root.width - vscrollbar.width
        visible: contentWidth > availableWidth
        maximumValue: contentWidth > availableWidth ? tree.contentWidth - availableWidth : 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: frameWidth
        anchors.bottomMargin: styleitem.frameoffset
        anchors.rightMargin: vscrollbar.visible ? scrollbarExtent : (frame ? 1 : 0)
        onValueChanged: contentX = value
        property int scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        // We cannot bind directly to tree.height due to binding loops so we have to redo the calculation here
        property int availableHeight : root.height - (hscrollbar.visible ? hscrollbar.height : 0) - headersection.height
        visible: contentHeight > availableHeight
        maximumValue: contentHeight > availableHeight ? tree.contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.rightMargin: styleitem.frameoffset
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: styleitem.style == "mac" ? headersection.height : 0
        onValueChanged: contentY = value
        anchors.bottomMargin: hscrollbar.visible ? hscrollbar.height :  styleitem.frameoffset
    }

    QStyleItem {
        z: 2
        anchors.fill: parent
        anchors.margins: -4
        visible: highlightOnFocus && parent.activeFocus && styleitem.styleHint("focuswidget")
        elementType: "focusframe"
    }

    QStyleItem {
        id: styleitem
        elementType: "header"
        visible:false
        property int frameoffset: style === "mac" ? -1 : 0
    }
    QStyleItem {
        id: rowstyleitem
        elementType: "item"
        visible:false
        property color textColor: styleHint("textColor")
        property color highlightedTextColor: styleHint("highlightedTextColor")
    }
    SystemPalette{id:palette}
}
