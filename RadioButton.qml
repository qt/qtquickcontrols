import Qt 4.7
import "./styles/default" as DefaultStyles

BasicButton {
    id: button

    background: defaultStyle.background
    checkable: true

    DefaultStyles.RadioButtonStyle { id: defaultStyle }
}
