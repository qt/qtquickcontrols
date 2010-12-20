import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.LineEdit {
    minimumHeight: 40

    Style {
        id: meegostyle
        styleClass: "MTextEditStyle"
        mode: inputElement.activeFocus ? "selected" : "default"
    }
    font: meegostyle.current.get("font")
    textColor: meegostyle.current.get("textColor")

    background: BorderImage {
        source: "image://theme/meegotouch-textedit-background"
        border.top: 12
        border.bottom: 12
        border.left: 12
        border.right: 12
    }
}

