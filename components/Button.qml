import Qt 4.7
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

    width: Math.max(minimumWidth,
                    labelComponent.item.width + leftMargin + rightMargin)
    height: Math.max(minimumHeight,
                     labelComponent.item.height + topMargin + bottomMargin)

    minimumWidth: defaultStyle.minimumWidth
    minimumHeight: defaultStyle.minimumHeight

    background: defaultStyle.background

    Loader {
        id: labelComponent
        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin
        sourceComponent: label
    }

    DefaultStyles.ButtonStyle { id: defaultStyle }
}
