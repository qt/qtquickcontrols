import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: busyIndicator

    // Common API:
    property bool running: true

    width: backgroundComponent.item.width;
    height: backgroundComponent.item.height;

    property Component background: defaultStyle.background

    Loader {
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }

    DefaultStyles.BusyIndicatorStyle{ id: defaultStyle }
}
