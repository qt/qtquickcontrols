import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: lineEdit

    property alias text: input.text
    property alias containsMouse: mousearea.containsMouse

    property color backgroundColor: "#fff";
    property color foregroundColor: "#222";

    property Component background: defaultStyle.background
    property Component content: defaultStyle.content

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(minimumWidth,
                    input.width + leftMargin + rightMargin)

    height: Math.max(minimumHeight,
                     input.height + topMargin + bottomMargin)

    DefaultStyles.LineEditStyle { id: defaultStyle }

    // background
    Loader {
        id: backgroundComponent
        anchors.fill: parent
        sourceComponent: background
    }

    MouseArea {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true
    }

    TextInput {
        id: input
        font.pixelSize: 14
        anchors.leftMargin: leftMargin
        anchors.topMargin: topMargin
        anchors.rightMargin: rightMargin
        anchors.bottomMargin: bottomMargin
        anchors.fill: parent
        selectByMouse: true
        color: foregroundColor
        opacity: parent.enabled ? 1 : 0.5
    }
}
