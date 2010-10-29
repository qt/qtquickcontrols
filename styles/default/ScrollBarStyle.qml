import Qt 4.7

QtObject {
    //    property Component background: defaultBackground
    property Component content: defaultContent

    property list<Component> elements: [
        Component {
            id: defaultContent
            Item {
                id: track
                height: parent.height - 8
                width: parent.width - 8
                anchors.centerIn: parent

                Item {
                    id: thumb
                    x: (scrollbar.orientation == "horizontal") ? Math.min (Math.max ((scrollItem.visibleArea.xPosition * scrollItem.width), 0), (track.width - width)) : 0
                    y: (scrollbar.orientation == "horizontal") ? 0 : Math.min (Math.max ((scrollItem.visibleArea.yPosition * scrollItem.height), 0), (track.height - height))
                    width: (scrollbar.orientation == "horizontal") ? scrollItem.visibleArea.widthRatio * scrollItem.width : 6
                    height: (scrollbar.orientation == "horizontal") ? 6 : (scrollItem.visibleArea.heightRatio * scrollItem.height) - 8
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
    ]
}
