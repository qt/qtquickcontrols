import Qt 4.7
import com.meego.themebridge 1.0

Button {
    Style {
        id: meegostyle
        styleClass: "MButtonStyle"
        mode: {
            if (containsMouse && pressed)
                return "pressed"
            else
                return "default"
        }
    }

    background:
        Background {
            id: background
            anchors.fill: parent
            style: meegostyle
        }
}
