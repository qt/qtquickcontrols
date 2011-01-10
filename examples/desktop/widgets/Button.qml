import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.Button {
    background: QStyleItem {
        elementType:"button"
        anchors.fill:parent
        sunken: pressed
        raised: !pressed
    }
}

