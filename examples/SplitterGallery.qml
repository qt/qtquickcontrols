import QtQuick 1.0
import "../components"
import "../components/plugin"

Rectangle {
    width: 800
    height: 600

    SplitterRow {
        id: splitter
        anchors.fill: parent

        SplitterItem {
            minimumWidth: 50
            percentageWidth: 50
//            maximumWidth: 200
            width: 200
//            expanding: true
            Rectangle {
                color: "gray"
            }
        }
        SplitterItem {
//            minimumWidth: 50
//            maximumWidth: 200
            percentageWidth: 30
//            expanding: true
            width:200
            Rectangle {
                color: "darkGray"
            }
        }
        SplitterItem {
//            minimumWidth: 50
//            maximumWidth: 200
            width: 50
            Rectangle {
                color: "gray"
            }
        }
//        SplitterItem {
////            minimumWidth: 50
////            maximumWidth: 100
//            width: 50
//            Rectangle {
//                color: "darkgray"
//            }
//        }
    }
}
