import QtQuick 1.1
import "./styles/default" as DefaultStyles

BasicButton {
    id: button

    property string text
    property url iconSource

    property Component label: defaultStyle.label

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    // implementation

    implicitWidth: Math.max(minimumWidth, labelLoader.item.implicitWidth + leftMargin + rightMargin)
    implicitHeight: Math.max(minimumHeight, labelLoader.item.implicitHeight + topMargin + bottomMargin)

    minimumWidth: defaultStyle.minimumWidth
    minimumHeight: defaultStyle.minimumHeight

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

    DefaultStyles.ButtonStyle { id: defaultStyle }
}
