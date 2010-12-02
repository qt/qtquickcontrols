import Qt 4.7
import "./styles/default" as DefaultStyles

// This is essentially a special case of checkbox - remove?

CheckBox {
    id: radiobutton

    checkmark: defaultStyle.checkmark
    background: defaultStyle.background

    DefaultStyles.RadioButtonStyle { id: defaultStyle}
}
