import QtQuick 2.0
import "custom" as Components
import "custom/private" as Private

Item {
    id: choiceList

    visible:  false
    width: 140

    onVisibleChanged: popup.state = visible ? "" : "hidden"
    function show(xpos, ypos) {
        x = xpos
        y = ypos
        popup.state = ""
    }

    property alias model: popup.model

    Private.ChoiceListPopup {
        id: popup
        listItem: choiceList.listItem
        popupFrame: choiceList.popupFrame
        width: parent.width
    }

    property Component listItem: Item {
        id: item
        height: 22

        width: styledItem.width
        anchors.left: parent.left
        QStyleItem {
            anchors.fill: parent
            elementType: "comboboxitem"
            text: itemText
            selected: highlighted
        }
    }

    QStyleItem {
        id: backgroundItem
        elementType: "choicelist"
    }

    property Component popupFrame: QStyleItem {
        property string behavior: "Windows"
        property int fw: backgroundItem.pixelMetric("menupanelwidth");
        anchors.leftMargin: backgroundItem.pixelMetric("menuhmargin") + fw
        anchors.rightMargin: backgroundItem.pixelMetric("menuhmargin") + fw
        anchors.topMargin: backgroundItem.pixelMetric("menuvmargin") + fw
        anchors.bottomMargin: backgroundItem.pixelMetric("menuvmargin") + fw
        elementType: "menu"

/*        effect: DropShadow {
            blurRadius: 10
            color: "#60000000"
            xOffset: 1
            yOffset: 1
        }
*/
    }
}
