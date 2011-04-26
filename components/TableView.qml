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
*   itemDelegate: Text {
*       color: itemselected ? "white": "black"
*       elide: Text.ElideRight
*       height: itemheight
*       width: itemwidth
*       text: itemvalue
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
* by setting the headermodel :
*
* ListModel {
*    ListElement{ property: "column1" ; caption: "Column 1" ; width:100}
*    ListElement{ property: "column2" ; caption: "Column 2" ; width:200}
* }
*
* The header sections are attached to properties in the datamodel by defining
* the listmodel property they attach to.
*
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
    property variant headermodel
    property variant model
    property int frameWidth: styleitem.pixelMetric("defaultframewidth");
    property alias contentHeight : tree.contentHeight
    property alias contentWidth: tree.contentWidth
    property bool frame: true
    property bool highlightOnFocus: false
    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")
    property int frameMargins : frame ? 2 : 0

    property int sortColumn: 0  // Index of currently selected sort header
    property bool sortIndicatorVisible: true // enables or disables sort indicator
    property string sortIndicatorDirection: "down" // "up" or "down" depending on current state

    property bool alternateRowColor: true
    property alias contentX: tree.contentX
    property alias contentY: tree.contentY

    property Component itemDelegate: standardDelegate

    Component {
        id: standardDelegate
        Item {
            width: itemwidth
            height: itemheight
            clip: true
            Text {
                anchors.fill:parent
                anchors.margins: 2
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                text: itemvalue
                color: itemforeground
            }
        }
    }

    Component {
        id: nativeDelegate
        // This gives more native styling, but might be less performant
        QStyleItem {
            id: itemdelegate
            elementType: "item"
            height: itemheight
            width:  itemwidth
            text:   itemvalue
            selected: itemselected
        }
    }

    Rectangle {
        id: colorRect
        color: "white"
        anchors.fill: frameitem
        anchors.margins: frameWidth
        anchors.rightMargin: (!frameAroundContents && vscrollbar.visible ? vscrollbar.width +frameWidth: 0)
        anchors.bottomMargin: (!frameAroundContents && hscrollbar.visible ? hscrollbar.height +frameWidth : 0)
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
    }

    ListView {
        id: tree

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
                    autoincrement = true
                } else if (mouseY < 0) {
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
        anchors.top: header.bottom
        anchors.topMargin: -frameWidth
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.bottom: frameitem.bottom
        anchors.margins: frameWidth

        anchors.rightMargin: (!frameAroundContents && vscrollbar.visible ? vscrollbar.width +frameWidth: 0)
        anchors.bottomMargin: (!frameAroundContents && hscrollbar.visible ? hscrollbar.height +frameWidth : 0)

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
            anchors.margins: frameMargins
            property int rowIndex: model.index
            property bool alternateRow: alternateRowColor && rowIndex %2 == 1
            QStyleItem {
                id: rowstyle
                elementType: "itemrow"
                // Row fills the tree with regardless of item size
                // But scrollbar should not adjust to it
                width: frameitem.width
                x: contentX
                height: parent.height
                activeControl: model.index%2 == 1 ? "alternate" : ""
                selected: ListView.isCurrentItem ? "true" : "false"
                property color textColor: styleHint("textColor")
                property color highlightedTextColor: styleHint("highlightedTextColor")
            }
            Row {
                id: row
                anchors.left: parent.left
                Repeater {
                    model: headermodel.count
                    Loader {
                        id: itemDelegateLoader
                        sourceComponent: itemDelegate
                        property string itemvalue: root.model.get(rowIndex)[ headermodel.get(index).property]
                        property int itemwidth: headermodel.get(index).width
                        property int itemheight: Math.max(16, rowstyle.sizeFromContents(16, 16).height)
                        property bool itemselected: rowitem.ListView.isCurrentItem
                        property bool alternaterow: rowitem.alternateRow
                        property color itemforeground: itemselected ? rowstyle.highlightedTextColor : rowstyle.textColor
                    }
                }
                onWidthChanged: tree.contentWidth = width
            }
        }
    }
    ListView {
        id: header
        focus: false
        interactive: false
        anchors.margins: frameMargins
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.top: frameitem.top
        contentWidth: tree.contentWidth
        contentX: tree.contentX
        height: styleitem.sizeFromContents(text.font.pixelSize, styleitem.fontHeight).height
        orientation: ListView.Horizontal
        clip: true
        // Derive size from style
        Text{ id:text }

        model: headermodel

        delegate: QStyleItem {
            clip: true
            elementType: "header"
            raised: true
            sunken: headerClickArea.pressed
            hover: headerClickArea.containsMouse
            property string sortString: sortIndicatorDirection == "up" ? "up" : "down";
            activeControl: sortIndicatorVisible &&  (model.index == sortColumn) ? sortString : ""

            width: model.width
            height: parent.height
            text: model.caption

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
                property int offset:0
                property int minimumSize: 20
                anchors.rightMargin: -width/2
                width: 16 ; height: parent.height
                anchors.right: parent.right
                onPositionChanged:  {
                    var newHeaderWidth = model.width + (mouseX - offset)
                    headermodel.setProperty(index, "width", Math.max(minimumSize, newHeaderWidth))
                }
                onPressedChanged: if(pressed)offset=mouseX

                QStyleItem {
                    anchors.fill: parent
                    cursor: "splithcursor"
                }
            }
        }
        QStyleItem {
            elementType: "header"
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: header.bottom
            width: Math.max(0, header.width - contentWidth)
            raised: true
        }
    }
    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        property int availableWidth: root.width - vscrollbar.width
        visible: contentWidth > availableWidth
        maximumValue: contentWidth > availableWidth ? tree.contentWidth - availableWidth: 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: (frame ? frameWidth : 0)
        anchors.rightMargin: { vscrollbar.visible ? scrollbarExtent : (frame ? 1 : 0) }
        onValueChanged: contentX = value
        property int scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        // We cannot bind directly to tree.height due to binding loops so we have to redo the calculation here
        property int availableHeight : root.height - (hscrollbar.visible ? hscrollbar.height : 0) - header.height - (frame ? 2 * frameWidth : 0)
        visible: contentHeight > availableHeight
        maximumValue: contentHeight > availableHeight ? tree.contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: styleitem.style == "mac" ? 1 : 0
        onValueChanged: contentY = value
        anchors.bottomMargin: hscrollbar.visible ? hscrollbar.height : 0
    }

    QStyleItem {
        z: 2
        anchors.fill: parent
        anchors.margins: -4
        visible: highlightOnFocus && parent.activeFocus && styleitem.styleHint("focuswidget")
        elementType: "focusframe"
    }

    QStyleItem { id: styleitem ; elementType: "header"; visible:false }
    SystemPalette{id:palette}
}
