import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: scrollbar

    //public API
    property variant scrollItem      // item to which the scrollbar is attached - this must be a Flickable, GridView or ListView
    property string orientation: ""  // possible values : "vertical", "horizontal" //mm Can this be made an enumeration?

    //private
    width:  (scrollbar.orientation == "horizontal") ? scrollItem.width : 14
    height: (scrollbar.orientation == "horizontal") ? 14 : scrollItem.height
    anchors.left: (scrollbar.orientation == "horizontal") ? scrollItem.left : undefined
    anchors.right: scrollItem.right
    anchors.top: (scrollbar.orientation == "horizontal") ? undefined : scrollItem.top
    anchors.bottom: scrollItem.bottom

    opacity: (scrollItem.moving == true) ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 100 } }

//    property Component background: defaultStyle.background
    property Component content: defaultStyle.content
    DefaultStyles.ScrollBarStyle { id: defaultStyle }

    Loader {
        anchors.fill: parent
        sourceComponent: content
    }
}
