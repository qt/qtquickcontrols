import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.ChoiceList {
    id:choicelist

    property int buttonHeight: buttonitem.sizeFromContents(100, 15).height
    QStyleItem { id:buttonitem; elementType:"button" }
    height: buttonHeight
    topMargin:4
    bottomMargin:4

    QStyleItem {
        id:styleitem
        elementType:"combobox"
        sunken: pressed
        raised: !pressed
        hover: containsMouse
        enabled:choicelist.enabled
    }

    background: QStyleBackground {
        anchors.fill:parent
        style: styleitem
    }

    listItem: Item {
        id:item
        height:24
        anchors.left:parent.left
        width:choicelist.width

        QStyleBackground {
            anchors.fill:parent
            style: QStyleItem {
                elementType: "menuitem"
                text: choicelist.model.get(index).text
                selected: containsMouse
            }
        }
    }

    listHighlight: null

    popupFrame: QStyleBackground {
        style:QStyleItem{elementType:"menu"}
    }
}

