import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.ProgressBar{
    id:button

    minimumHeight: meegostyle.preferredHeight
    minimumWidth: meegostyle.preferredWidth

    Style {
        id: meegostyle
        styleClass: "MProgressIndicatorStyle"
        styleType: "bar"
    }

    background: BorderImage {
        z:-5
        source: "image://theme/meegotouch-progressindicator-bar-background"
        border.top: 4
        border.bottom: 4
        border.left: 4
        border.right: 4
    }


    progress:
        MaskedImage {
            id: bar
            style: meegostyle
            maskProperty: "progressBarMask"
            imageProperty: "knownBarTexture"
            fullWidth: __fullWidth
        }

    indeterminateProgress:
        MaskedImage {
            // We use a second image for the wrapping animation when not full width.
            id: wrappingBar
            style: meegostyle
            imageProperty: "unknownBarTexture"
            maskProperty: "progressBarMask"
            tiled: meegostyle.current.get("unknownBarTextureTiled")
            imageXOffset: 0
            width: 0
            fullWidth: false
            NumberAnimation on imageXOffset  {
                loops:Animation.Infinite;
                from:0;
                to:6;
                duration:300
            }
        }
}

