import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.ChoiceList {
    id:choicelist

    background: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem {
            elementType:"combobox"
            sunken: pressed
            raised: !pressed
            hover: containsMouse
            enabled:choicelist.enabled
        }
    }

    listItem: Item {
        height:24
        anchors.left:parent.left
        width:choicelist.width

        QStyleBackground {
            anchors.fill:parent
            style: QStyleItem {
                elementType:"menuitem"
                text:choicelist.model.get(index).text
                selected:containsMouse
            }
        }
    }

    listHighlight: null

    popupFrame: QStyleBackground {
        style:QStyleItem{elementType:"menu"}
    }
}

