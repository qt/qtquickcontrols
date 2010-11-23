import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: scrollbar

    //public API
    property variant scrollItem      // item to which the scrollbar is attached - this must be a Flickable, GridView or ListView
    property bool horizontal: false

    //private
    width:  horizontal ? scrollItem.width : 14
    height: horizontal ? 14 : scrollItem.height
    anchors.left: horizontal ? scrollItem.left : undefined
    anchors.right: scrollItem.right
    anchors.top: horizontal ? undefined : scrollItem.top
    anchors.bottom: scrollItem.bottom

    opacity: (scrollItem.moving == true) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }

    property Component content: defaultStyle.content
    DefaultStyles.ScrollBarStyle { id: defaultStyle }

    Loader {
        anchors.fill: parent
        sourceComponent: content
    }
}
