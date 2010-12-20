import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.TextField {
    id:textField
    minimumHeight: 40

    Style {
        id: meegostyle
        styleClass: "MTextEditStyle"
        mode: textField.activeFocus ? "selected" : "default"
    }

    font: meegostyle.current.get("font")
    textColor: meegostyle.current.get("textColor")

    background: BorderImage {
        source: textField.activeFocus ?
                "image://theme/meegotouch-textedit-background-selected" :
                "image://theme/meegotouch-textedit-background"
        border.top: 6
        border.bottom: 6
        border.left: 20
        border.right: 20
    }
}

