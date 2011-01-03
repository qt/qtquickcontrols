import QtQuick 1.0
import "./styles/default" as DefaultStyles

Item {
    id: scrollDecorator

    property variant flickable      // must be a Flickable, e.g. GridView or ListView

    anchors.fill: parent
    ScrollIndicator {
        horizontal: true
        scrollItem: scrollDecorator.flickable
    }

    ScrollIndicator {
        horizontal: false
        scrollItem: scrollDecorator.flickable
    }
}
