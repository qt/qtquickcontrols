import QtQuick 1.0
import "./styles/default" as DefaultStyles

Item {
    id: scrollDecorator

    property Flickable flickableItem

    anchors.fill: parent

    ScrollIndicator {
        horizontal: true
        scrollItem: scrollDecorator.flickableItem
    }

    ScrollIndicator {
        horizontal: false
        scrollItem: scrollDecorator.flickableItem
    }
}
