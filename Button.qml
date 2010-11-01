import Qt 4.7
import "./styles/default" as DefaultStyles

BasicButton {
    id: button

    property string text
    property url icon

    background: defaultStyle.background
    content: defaultStyle.content
    DefaultStyles.ButtonStyle { id: defaultStyle }
}
