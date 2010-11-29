import Qt 4.7

Item {
    property string corner: ""    // Can we use Qt::Corner? see http://doc.trolltech.com/4.7/qt.html#Corner-enum
    property bool adjoining: false

    clip: true
    anchors {
        left: corner == "TopLeftCorner" || corner == "BottomLeftCorner" ? parent.left : parent.horizontalCenter
        right: corner == "TopLeftCorner" || corner == "BottomLeftCorner" ? parent.horizontalCenter : parent.right
        top: corner == "TopLeftCorner" || corner == "TopRightCorner" ? parent.top : parent.verticalCenter
        bottom: corner == "TopLeftCorner" || corner == "TopRightCorner" ? parent.verticalCenter : parent.bottom
    }

    Item {
        width: parent.width*2
        height: parent.height*2
        x: corner == "TopLeftCorner" || corner == "BottomLeftCorner" ? 0 : -parent.width
        y: corner == "TopLeftCorner" || corner == "TopRightCorner" ? 0 : -parent.height

        Loader {
            anchors.fill: parent
            sourceComponent: adjoining ? adjoingStyling : normalStyling
        }
    }
}
