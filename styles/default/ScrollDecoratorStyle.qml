import Qt 4.7

QtObject {
    property Component content:
    Component {
        id: defaultContent
        Item {
            id: track
            Item {
                id: thumb
                x: horizontal ? Math.min (Math.max ((scrollItem.visibleArea.xPosition * scrollItem.width), 0), (track.width - width)) : 0
                y: horizontal ? 0 : Math.min (Math.max ((scrollItem.visibleArea.yPosition * scrollItem.height), 0), (track.height - height))
                width: horizontal ? scrollItem.visibleArea.widthRatio * scrollItem.width : 6
                height: horizontal ? 6 : (scrollItem.visibleArea.heightRatio * scrollItem.height) - 8
                Rectangle {
                    id: shadow
                    anchors.fill: thumb
                    radius: 3
                    color: "#000000"
                    opacity: 0.6
                }

                Rectangle {
                    height: thumb.height - 2
                    width: thumb.width - 2
                    anchors.centerIn: thumb
                    radius: 2
                    color: "#FFFFFF"
                }
            }
        }
    }
}
