import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.Button {
    id:button

    // Icon properties. Precedence is the following:
    // Source has precedence over Id
    // When checked, try to use checked Source or Id, if empty, fallback to default Source or Id
    property string iconId
    property bool iconVisible: true
    property bool textVisible: true

    minimumWidth:55
    minimumHeight: meegostyle.preferredHeight
    textColor: meegostyle.current.get("textColor")
    //font: meegostyle.current.get("font")

    Style {
        id: meegostyle
        styleClass: "MButtonStyle"
        mode: {
            if (pressed)
                return "pressed"
            else if (checked)
                return "selected"
            else
                return "default"
        }
    }

    /*

    background: BorderImage {
        source: pressed ? "image://theme/meegotouch-button-background-pressed" :
        "image://theme/meegotouch-button-background"
        border.top: 8
        border.bottom: 8
        border.left: 22
        border.right: 22
    }



    label : Component {
        Item {
            width:(iconFromSource.width ? iconFromSource.width + 6 : 0) + label.width + 4

            Row {
                anchors.centerIn:parent
                spacing: 6
                Image {
                    Icon {
                        id: iconFromId

                        // When checked, try to use checked Id. If empty, the standard Id is the fallback
                        iconId: {
                            if (checkable.checked && button.checkedIconId)
                                return button.checkedIconId;
                            return button.iconId;
                        }

                        // Visiblity check for default state (icon is not explicitly hidden)
                        // Icon is shown if there's a valid iconId, respecting the higher
                        // priority of iconFromSource
                        visible: iconId && !iconFromSource.visible
                    }

                    id: iconFromSource
                    sourceSize.width: meegostyle.current.get("iconSize").width
                    sourceSize.height: meegostyle.current.get("iconSize").height

                    // When checked, try to use checked source. If empty, the standard source is the fallback
                    source: {
                        if (checkable.checked && button.checkedIconSource)
                            return button.checkedIconSource;
                        return button.iconSource;
                    }

                    // Visibility check for default state (icon is not explicitly hidden)
                    visible: {
                        if (iconFromSource.source == "")
                            return false;

                        if (!checkable.checked)
                            return true;

                        // Show sourceIcon when
                        //  1) checkedIconSource is present (highest priority), or
                        //  2) no checked icon exists (fallback)
                        return button.checkedIconSource || !button.checkedIconId;
                    }

                    states: State {
                        name: "iconHidden"
                        when: !button.iconVisible
                        // Hide both icons
                        PropertyChanges { target: iconFromSource; visible: false; source: "" }
                        PropertyChanges { target: iconFromId; visible: false; iconId: "" }
                    }
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

                    text: button.text
                }
            }
        }
    }
*/
}

