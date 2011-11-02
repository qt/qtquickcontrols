import QtQuick 1.1

Window {
    width: 320
    height: 240

    property alias toolBar: toolBarArea.data
    property alias statusBar: statusBarArea.data
    default property alias data: contentArea.data

    SystemPalette {id: syspal}


    Rectangle {
        anchors.fill: parent
        color: syspal.button
    }


    Column {
        id: toolBarArea
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Item {
        id: contentArea
        anchors.top: toolBarArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: statusBarArea.top
    }

    Column {
        id: statusBarArea
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
