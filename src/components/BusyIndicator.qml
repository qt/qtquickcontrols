import QtQuick 1.0
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
        property bool running: busyIndicator.opacity > 0 &&
                               busyIndicator.visible &&
                               busyIndicator.running
//        onRunningChanged: print("Running: " + running)
        anchors.fill: parent
        sourceComponent: background

    }

    DefaultStyles.BusyIndicatorStyle { id: defaultStyle }
}
