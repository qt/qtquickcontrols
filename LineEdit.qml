import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: lineEdit

    width: 200
    height: 32

    property alias text: input.text
    property alias containsMouse: mousearea.containsMouse

    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    property Component background: defaultStyle.background
    property Component content: defaultStyle.content
    DefaultStyles.LineEditStyle { id: defaultStyle }

    // background
    Loader {
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }

    // Contents
    Loader {
        id: contentsComponent
        anchors.fill: parent
        sourceComponent: content
        onLoaded: {
            item.parent = lineEdit
        }
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true
    }

    TextInput {
        id: input
        font.pixelSize: 14
        anchors.margins: 4
        anchors.fill: contentsComponent.item
        selectByMouse: true
        color: foregroundColor
        opacity: parent.enabled ? 1 : 0.5
    }
}
