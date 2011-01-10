import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.ChoiceList {
    id:choicelist
    background: QStyleItem {
        elementType:"combobox"
        anchors.fill:parent
        sunken: pressed
        raised: !pressed
        hover: containsMouse
    }

    listItem: Item {
        height:20
        anchors.left:parent.left
        width:choicelist.width
        QStyleItem {
            elementType:"menuitem"
            text:model.get(index).text
            anchors.fill:parent
        }
    }

    popupFrame: QStyleItem {
        elementType:"menu"
    }
}

