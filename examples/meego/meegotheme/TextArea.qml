import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.TextArea {
    id:textField

    leftMargin:meegostyle.current.get("paddingLeft")
    rightMargin:meegostyle.current.get("paddingRight")
    topMargin: meegostyle.current.get("paddingTop")
    bottomMargin: meegostyle.current.get("paddingBottom")
    minimumHeight: meegostyle.preferredHeight

    placeholderText: ""

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
        border.left: textField.leftMargin
        border.right: textField.rightMargin
        // Note: top and bottom margins are too small
        border.top: textField.leftMargin
        border.bottom: textField.rightMargin
    }
}

