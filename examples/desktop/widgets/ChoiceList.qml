import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.ChoiceList {

    background: QStyleItem {
        elementType:"combobox"
        anchors.fill:parent
        sunken: pressed
        raised: !pressed
        hover: containsMouse
    }
}

