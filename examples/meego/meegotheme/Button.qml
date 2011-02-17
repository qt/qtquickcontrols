import QtQuick 1.1
import "../../../components" as Components  // Button
import com.meego.themebridge 1.0            // Style

Components.Button {

    // implementation

    minimumWidth: 55
    minimumHeight: 50 // meegostyle.preferredHeight
    //mm meegostyle.preferredHeight doesn't seem to return the right value

    leftMargin: 16
    rightMargin: 16
    topMargin: 10
    bottomMargin: 10

    textColor: meegostyle.current.get("textColor")
    //font: meegostyle.current.get("font")

    Style {
        id: meegostyle
        styleClass: "MButtonStyle"
        mode: {
            if (styledItem.pressed)
                return "pressed";
            else if (styledItem.checked)
                return "selected";
            else
                return "default";
        }
    }

    background: Component {
        BorderImage {
            source: {
                var bkgImage = "image://theme/meegotouch-button-background"
                if(!styledItem.enabled)
                    bkgImage += "-disabled";
                else if(styledItem.pressed)
                    bkgImage += "-pressed";
                else if(styledItem.checked)
                    bkgImage += "-selected";

                return bkgImage;
            }

            border.top: 8
            border.bottom: 8
            border.left: 22
            border.right: 22
        }
    }

    label: Component {
        Item {
            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight
            Row {
                id: row
                anchors.centerIn: parent
                spacing: 6
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.width: meegostyle.current.get("iconSize").width
                    sourceSize.height: meegostyle.current.get("iconSize").height
                    source: styledItem.iconSource
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    elide: Text.ElideRight
                    font: meegostyle.current.get("font")
                    color: meegostyle.current.get("textColor")
                    text: styledItem.text
                }
            }
        }
    }
}

