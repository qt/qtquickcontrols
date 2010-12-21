import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.ButtonBlock {
    id:button

    // Icon properties. Precedence is the following:
    // Source has precedence over Id
    // When checked, try to use checked Source or Id, if empty, fallback to default Source or Id
    property string iconId
    property bool iconVisible: true
    property bool textVisible: true

    textColor: meegostyle.current.get("textColor")
    //font: meegostyle.current.get("font")

    buttonBackground:
        BorderImage {
        function mapToState() {
            var string = "image://theme/meegotouch-button-background";

            if (styledItem.pressed)
                string += "-pressed"

            if (adjoining&Qt.Horizontal)
                string += "-horizontal-center"
            else if (adjoining&Qt.Vertical)
                string += "-vertical-center"
            return string;
        }

        source: mapToState()
        border.top: 8
        border.bottom: 8
        border.left: 22
        border.right: 22
    }

    Style {
        id: meegostyle
        styleClass: "MButtonStyle"
        mode: {
            if (button.pressed)
                return "pressed"
            else if (button.checked)
                return "selected"
            else
                return "default"
        }
    }

    buttonLabel : Component {
        Item {
            height: 30
            width:(iconFromSource.width ? iconFromSource.width + 6 : 0) + label.width + 4
            Row {
                anchors.centerIn:parent
                spacing: 6
                Image {
                    id: iconFromSource
                    source:styledItem.iconSource
                    sourceSize.width: meegostyle.current.get("iconSize").width
                    sourceSize.height: meegostyle.current.get("iconSize").height
                }
                Label {
                    id: label
                    x:(iconFromSource.width ? iconFromSource.width + 8 : 0)
                    elide: Text.ElideRight
                    anchors.verticalCenter:parent.verticalCenter

                    // XXX This does not make sense yet, since the label width is not being set
                    // horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: meegostyle.current.get("verticalTextAlign")
                    font: meegostyle.current.get("font")
                    color: meegostyle.current.get("textColor")
                    text: styledItem.text
                }
            }
        }
    }
}

