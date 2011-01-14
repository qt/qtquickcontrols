import QtQuick 1.0

QtObject {
    property int minimumWidth: 90
    property int minimumHeight: 32

    property int leftMargin : 8
    property int topMargin: 8
    property int rightMargin: 8
    property int bottomMargin: 8

    property Component background:
    Component {
        id: defaultBackground
        Item {
            opacity: enabled ? 1 : 0.7
            clip:true
            property bool isPositioned: position != "only" // only evaluate for rows and columns

            Item {
                anchors.fill: parent
                anchors.leftMargin:   isPositioned && (position == "rightmost"  || position =="h_middle") ? -leftMargin : 0
                anchors.rightMargin:  isPositioned && (position == "leftmost"   || position =="h_middle") ? -rightMargin : 0
                anchors.topMargin:    isPositioned && (position == "bottom"     || position =="v_middle") ? -bottomMargin : 0
                anchors.bottomMargin: isPositioned && (position == "top"        || position =="v_middle") ? -topMargin : 0

                Rectangle {
                    // Background center fill
                    anchors.fill: parent
                    anchors.leftMargin: anchors.leftMargin
                    anchors.rightMargin: anchors.rightMargin
                    anchors.topMargin: anchors.topMargin
                    anchors.bottomMargin: anchors.bottomMargin
                    radius: 5
                    color: backgroundColor
                }
                BorderImage {
                    anchors.fill: parent
                    smooth: true
                    source: button.pressed || button.checked ? "images/button_pressed.png" : "images/button_normal.png";
                    border.left: 6; border.top: 6
                    border.right: 6; border.bottom: 6
                }
            }

            // Draw
            Rectangle {
                width:1
                visible: isPositioned && !checked && !pressed && (position == "rightmost" || position == "h_middle")
                anchors.top:parent.top
                anchors.topMargin:2
                anchors.bottomMargin:2
                anchors.bottom:parent.bottom
                anchors.left:parent.left
                opacity:0.4
                color: "white"
            }
            Rectangle {
                width:1
                opacity:0.4
                visible: isPositioned && !checked && !pressed && (position == "leftmost" || position == "h_middle")
                anchors.top:parent.top
                anchors.topMargin:2
                anchors.bottomMargin:2
                anchors.bottom:parent.bottom
                anchors.right:parent.right
                color: "black"
            }
        }
    }

    property Component label:
    Component {
        id: defaultLabel
        Item {
            width: row.width
            height: row.height
            opacity: enabled ? 1 : 0.5
            transform: Translate {
                x: button.pressed || button.checked ? 1 : 0
                y: button.pressed || button.checked ? 1 : 0
            }

            Row {
                id: row
                anchors.centerIn: parent
                spacing: 4
                Image {
                    source: button.iconSource
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.Stretch //mm Image should shrink if button is too small, depends on QTBUG-14957
                }

                Text {
                    color: textColor //mm see QTBUG-15623
                    anchors.verticalCenter: parent.verticalCenter
                    text: button.text
                    horizontalAlignment: Text.Center
                    elide: Text.ElideRight //mm can't make layout work as desired without implicit size support, see QTBUG-14957
                }
            }
        }
    }
}
