import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: button

    property string text
    property url iconSource

    // Common API:
    property bool running:true

    width: backgroundComponent.item.width;
    height: backgroundComponent.item.height;

    property Component background: defaultStyle.background

    Loader {
        id:backgroundComponent
        anchors.fill:parent
        sourceComponent: background
        property alias running:button.running // Forward to style component
    }

    DefaultStyles.BusyIndicatorStyle{ id: defaultStyle }
}
