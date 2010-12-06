import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: scrollIndicator

    property variant scrollItem      // must be a Flickable, e.g. GridView or ListView
    property bool horizontal: false

    property Component content: defaultStyle.content

    //private
    anchors.left: horizontal ? parent.left : undefined
    anchors.right: parent.right
    anchors.top: horizontal ? undefined : parent.top
    anchors.bottom: parent.bottom
    width:  horizontal ? parent.width : defaultStyle.minimumWidth
    height: horizontal ? defaultStyle.minimumWidth : parent.height

    opacity: (horizontal ? scrollItem.movingHorizontally : scrollItem.movingVertically) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }

    Item {
        id: ratationContainer

        anchors.centerIn: parent
        rotation: horizontal ? -90 : 0
        width: horizontal ? scrollIndicator.height : scrollIndicator.width  // rotate width and heigh back
        height: horizontal ? scrollIndicator.width : scrollIndicator.height

        property variant visibleArea: scrollItem.visibleArea
        property real scrollItemSize: horizontal ? scrollItem.width : scrollItem.height
        property real scrollItemVisibleAreaPos: horizontal ? visibleArea.xPosition : visibleArea.yPosition
        property real scrollItemVisibleAreaScrollRatio: horizontal ? visibleArea.widthRatio : visibleArea.heightRatio
        property real scrollItemContentPos: horizontal ? scrollItem.contentX : scrollItem.contentY
        property real scrollItemContentSize: horizontal ? scrollItem.contentWidth : scrollItem.contentHeight

        property real offset: scrollItemVisibleAreaPos * scrollItemSize
        property real length: scrollItemVisibleAreaScrollRatio * scrollItemSize
        property real startOvershoot: Math.max(-scrollItemContentPos, 0)
        property real endOvershoot: Math.max(scrollItemContentPos-(scrollItemContentSize-scrollItemSize), 0)
        property real start: Math.max(offset + endOvershoot, 0)
        property real end: Math.min(offset+length-startOvershoot, scrollItemSize)

        Loader {
            x: 0
            y: parent.endOvershoot > 0 ? Math.min(parent.start, parent.scrollItemSize-width) : parent.start
            width: 12
            height: Math.max(parent.end-parent.start, width)

            sourceComponent: content
        }
    }

    DefaultStyles.ScrollIndicatorStyle { id: defaultStyle }
}
