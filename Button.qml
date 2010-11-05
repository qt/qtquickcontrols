import Qt 4.7
import "./styles/default" as DefaultStyles

BasicButton {
    id: button

    property string text
    property url icon

    minimumWidth: defaultStyle.minimumWidth
    minimumHeight: defaultStyle.minimumHeight

    leftMargin: defaultStyle.leftMargin
    topMargin: defaultStyle.topMargin
    rightMargin: defaultStyle.rightMargin
    bottomMargin: defaultStyle.bottomMargin

    background: defaultStyle.background
    content: defaultStyle.content

    DefaultStyles.ButtonStyle { id: defaultStyle }
}
