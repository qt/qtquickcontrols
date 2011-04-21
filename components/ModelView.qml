import QtQuick 1.0
import "../components"
import "../components/plugin"

FocusScope{
    id: root
    property variant headermodel
    property variant model
    property int __scrollbarExtent : styleitem.pixelMetric("scrollbarExtent");
    property int frameWidth: styleitem.pixelMetric("defaultframewidth");
    property alias contentHeight : tree.contentHeight
    property alias contentWidth: tree.contentWidth
    property bool frame: false
    property bool highlightOnFocus: false
    property bool frameAroundContents: styleitem.styleHint("framearoundcontents")
    property int frameMargins : frame ? 2 : 0

    property alias contentX: tree.contentX
    property alias contentY: tree.contentY

    ListView {
        id: header
        focus:false
        interactive:false
        anchors.rightMargin: frame ? (frameAroundContents ? (vscrollbar.visible ? vscrollbar.width + 2 * frameMargins : 0) : -frameWidth) : 0
        anchors.left:parent.left
        anchors.right:parent.right
        anchors.top:parent.top
        orientation: ListView.Horizontal

        property int sortColumn: -1

        // Derive size fomr style
        Text{ id:text }
        QStyleItem { id: styleitem ; elementType: "header"; visible:false }
        height: Math.max(text.font.pixelSize + 2, styleitem.sizeFromContents(text.font.pixelSize, text.font.pixelSize).height)

        model: headermodel

        delegate: QStyleItem {
            clip: true
            elementType: "header"
            raised: true
            sunken: hoverarea.pressed
            hover: hoverarea.containsMouse
            activeControl: model.index == header.sortColumn ? "sort" : ""

            width: (index ==  headermodel.count - 1) ? header.width - x  : model.width
            height: parent.height
            text: model.label

            MouseArea{
                id: hoverarea
                hoverEnabled: true
                anchors.fill: parent
                /*
                        onClicked: {
                        if (index == 1)
                            filemodel.sortField = 3
                        else filemodel.sortField = 1
                        header.sortColumn = index
                    }
                    */
            }

            MouseArea{
                property int offset:0
                anchors.rightMargin: -width/2
                width: 16 ; height: parent.height
                anchors.right: parent.right

                onPositionChanged:  {
                    headermodel.setProperty(index, "width",model.width + (mouseX - offset))}
                onPressedChanged: if(pressed)offset=mouseX

                QStyleItem {
                    anchors.fill:parent
                    cursor: "splithcursor"
                }
            }
        }
    }

    ListView {
        id: tree

        clip: true
        focus: true
        interactive: false
        anchors.topMargin: header.height
        anchors.fill: parent
        model: root.model
        anchors.rightMargin: frame ? (frameAroundContents ? (vscrollbar.visible ? vscrollbar.width + 2 * frameMargins : 0) : -frameWidth) : 0
        anchors.bottomMargin: frame ? (frameAroundContents ? (hscrollbar.visible ? hscrollbar.height + 2 * frameMargins : 0) : -frameWidth) : 0

        Keys.onUpPressed: if (currentIndex > 0)currentIndex = currentIndex - 1
        Keys.onDownPressed: if (currentIndex< count - 1)currentIndex = currentIndex + 1
        onCurrentIndexChanged: {
            positionViewAtIndex(currentIndex, ListView.Contain)
            vscrollbar.value = tree.contentY
        }

        delegate: QStyleItem {
            id: rowitem
            elementType: "itemrow"
            width: parent.width
            height: 18
            activeControl: index%2 == 0 ? "alternate" : ""
            property int rowIndex: model.index
            selected: ListView.isCurrentItem ? "true" : "false"
            Row {
                Repeater {
                    model: headermodel.count
                    QStyleItem {
                        id: itemdelegate
                        elementType: "item"
                        height: 20
                        activeControl: index%2 == 0 ? "alternate" : ""
                        selected: rowitem.ListView.isCurrentItem ? "true" : "false"
                        property string varname: headermodel.get(index).label
                        text: root.model.get(rowIndex)[varname];
                        width:  (index ==  headermodel.count - 1) ? header.width - x  : headermodel.get(index).width

                    }
                }
            }
            MouseArea{
                anchors.fill:parent
                onPressed:  {
                    tree.forceActiveFocus()
                    tree.currentIndex = rowIndex
                }
            }
        }
    }

    ScrollBar {
        id: hscrollbar
        orientation: Qt.Horizontal
        property int availableWidth : tree.width - (frame ? (vscrollbar.width) : 0)
        visible: contentWidth > availableWidth
        maximumValue: contentWidth > availableWidth ? tree.contentWidth - availableWidth: 0
        minimumValue: 0
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: (frame ? frameWidth : 0)
        anchors.rightMargin: { vscrollbar.visible ? __scrollbarExtent : (frame ? 1 : 0) }
        onValueChanged: contentX = value
    }

    ScrollBar {
        id: vscrollbar
        orientation: Qt.Vertical
        property int availableHeight : tree.height - (frame ? (hscrollbar.height) : 0)
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
}
