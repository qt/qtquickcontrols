import QtQuick 1.0
import "custom" as Components
import "plugin"

Components.ChoiceList {

    id: choicelist

    property int buttonHeight: backgroundItem.sizeFromContents(100, 18).height
    property int buttonWidth: backgroundItem.sizeFromContents(100, 18).width

    height: buttonHeight
    width: buttonWidth
    topMargin: 4
    bottomMargin: 4

    background: QStyleItem {
        anchors.fill: parent
        elementType: "combobox"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled: choicelist.enabled
        text: choicelist.model.get(currentIndex).text
        focus: choicelist.focus
    }

    listItem: Item {
        id:item

        height: 22
        anchors.left: parent.left
        width: choicelist.width
        QStyleItem {
            anchors.fill: parent
            elementType: "comboboxitem"
            text: choicelist.model.get(index).text
            selected: highlighted

        }
    }
    popupFrame: QStyleItem {
        property string behavior: backgroundItem.styleHint("comboboxpopup") ? "MacOS" : "Windows"
        property int fw: backgroundItem.pixelMetric("menupanelwidth");
        anchors.leftMargin: backgroundItem.pixelMetric("menuhmargin") + fw
        anchors.rightMargin: backgroundItem.pixelMetric("menuhmargin") + fw
        anchors.topMargin: backgroundItem.pixelMetric("menuvmargin") + fw
        anchors.bottomMargin: backgroundItem.pixelMetric("menuvmargin") + fw
        elementType: "menu"

        effect:    DropShadow {
            blurRadius: 10
            color: "#60000000"
            xOffset: 1
            yOffset: 1
        }
    }
}
