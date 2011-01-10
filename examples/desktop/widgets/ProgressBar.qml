import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.ProgressBar {
    id:progressbar

    background: QStyleItem {
        elementType:"progressbar"
        anchors.fill:parent
        minimum: minimumValue
        maximum: maximumValue
        value: progressbar.value
    }

    progress: Item{}
}

