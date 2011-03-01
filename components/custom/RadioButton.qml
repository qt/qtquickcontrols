import QtQuick 1.1
import "./styles/default" as DefaultStyles

CheckBox {
    id: radioButton

    // implementation

    checkmark: defaultStyle.checkmark
    background: defaultStyle.background
    DefaultStyles.RadioButtonStyle { id: defaultStyle}
}
