import QtQuick 1.1

BasicButton {
    id: button

    property string text
    property url iconSource

    property Component label: null

    property int leftMargin: 0
    property int topMargin: 0
    property int rightMargin: 0
    property int bottomMargin: 0

    // implementation

    implicitWidth: Math.max(minimumWidth, labelLoader.item ? labelLoader.item.implicitWidth : 0 + leftMargin + rightMargin)
    implicitHeight: Math.max(minimumHeight, labelLoader.item ? labelLoader.item.implicitHeight : 0 + topMargin + bottomMargin)

    minimumWidth: 0
    minimumHeight: 0

    background: defaultStyle.background

    Loader {
        id: labelLoader
        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin
        property alias styledItem: button
        sourceComponent: label
    }
}
