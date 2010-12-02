import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: scrollDecorator

    property variant scrollItem      // must be a Flickable, e.g. GridView or ListView
    property bool horizontal: false

    //private
    anchors.left: horizontal ? scrollItem.left : undefined
    anchors.right: scrollItem.right
    anchors.top: horizontal ? undefined : scrollItem.top
    anchors.bottom: scrollItem.bottom
    width:  horizontal ? scrollItem.width : defaultStyle.minimumWidth
    height: horizontal ? defaultStyle.minimumWidth : scrollItem.height

    property Component content: defaultStyle.content
    DefaultStyles.ScrollDecoratorStyle { id: defaultStyle }

    opacity: (scrollItem.moving == true) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }

    Item {
        id: ratationContainer
        rotation: horizontal ? -90 : 0
        width: horizontal ? scrollDecorator.width : scrollDecorator.height
        height: horizontal ? scrollDecorator.height : scrollDecorator.width

        property real offset: scrollItem.visibleArea.yPosition * scrollItem.height
        property real length: scrollItem.visibleArea.heightRatio * scrollItem.height

        property real topOvershoot: Math.max(-scrollItem.contentY, 0)
        property real bottomOvershoot: Math.max(scrollItem.contentY-(scrollItem.contentHeight-scrollItem.height), 0)

        property real start: Math.max(offset + bottomOvershoot, 0)
        property real end: Math.min(offset+length-topOvershoot, scrollItem.height)

        Loader {
            x: 0
            y: parent.bottomOvershoot > 0 ? Math.min(parent.start, scrollItem.height-width) : parent.start
            width: 12
            height: Math.max(parent.end-parent.start, width)

            sourceComponent: content
        }
    }
}
