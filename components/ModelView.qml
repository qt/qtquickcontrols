import QtQuick 1.0
import "../components"
import "../components/plugin"

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

    property alias contentX: tree.contentX
    property alias contentY: tree.contentY
    property bool alternateRowColor: true

    property int sortColumn: 0
    property bool sortIndicatorVisible: true
    property string sortIndicatorDirection: "down"

    property Component itemDelegate: standardDelegate

    Component {
        id: standardDelegate
        Text {
            clip:true
            color: itemselected ? palette.highlightedText : palette.text
            elide: Text.ElideRight
            height: itemheight
            width: itemwidth
            text: itemtext
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
            text:   itemtext
            selected: itemselected
        }
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
        focus: true
        clip:true
        interactive: false

        anchors.top: header.bottom
        anchors.left: frameitem.left
        anchors.right: frameitem.right
        anchors.bottom: frameitem.bottom

        anchors.margins: frameWidth
        model: root.model

        Keys.onUpPressed: if (currentIndex > 0)currentIndex = currentIndex - 1
        Keys.onDownPressed: if (currentIndex< count - 1)currentIndex = currentIndex + 1

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
                height:parent.height
                activeControl: model.index %2 == 0 ? "alternate" : ""
                selected: ListView.isCurrentItem ? "true" : "false"
            }
            Row {
                id: row
                anchors.left: parent.left
                anchors.leftMargin: 4
                Repeater {
                    model: headermodel.count
                    Loader {
                        id: itemDelegateLoader
                        sourceComponent: itemDelegate
                        property string itemtext: root.model.get(rowIndex)[ headermodel.get(index).label]
                        property int itemwidth: headermodel.get(index).width
                        property int itemheight: rowstyle.sizeFromContents(16, 16).height
                        property bool itemselected: rowitem.ListView.isCurrentItem
                        property bool alternaterow: rowitem.alternateRow
                    }
                }
                onWidthChanged: tree.contentWidth = width
            }
            MouseArea{
                anchors.fill: parent
                onPressed:  {
                    tree.forceActiveFocus()
                    tree.currentIndex = rowIndex
                }
            }
        }
    }
    ListView {
        id: header
        focus:false
        interactive:false
        anchors.margins: frameMargins
        anchors.left:frameitem.left
        anchors.right: frameitem.right
        anchors.top:frameitem.top
        height: Math.max(text.font.pixelSize + 2, styleitem.sizeFromContents(text.font.pixelSize, text.font.pixelSize).height)
        orientation: ListView.Horizontal


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
            text: model.label

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
                    anchors.fill:parent
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
        property int availableWidth: root.width - (frame ? (vscrollbar.width) : 0)
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
        property int availableHeight : root.height - (frame ? (hscrollbar.height) : 0)
        visible: contentHeight > availableHeight
        maximumValue: contentHeight > availableHeight ? tree.contentHeight - availableHeight : 0
        minimumValue: 0
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: styleitem.style == "mac" ? 1 : 0
        onValueChanged: contentY = value
        anchors.bottomMargin: (frameAroundContents && hscrollbar.visible) ? hscrollbar.height : 0
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
