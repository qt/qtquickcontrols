import Qt 4.7
import Qt.labs.components 1.0    // ImplicitlySizedItem. See QTBUG-14957
import "./styles/default" as DefaultStyles

Item{
    id: progressBar
    property Component background: defaultStyle.background
    property Component content: defaultStyle.content

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    // Common API:
    property real minimum: 0
    property real maximum: 100
    property real value: 0
    property bool indeterminate: false

    width: minimumWidth
    height: minimumHeight

    Loader {
        id: groove
        sourceComponent: background
        anchors.fill: parent
    }

    Loader {
        id: contentComponent
        anchors.fill: parent

        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin
        sourceComponent: content
    }

    DefaultStyles.ProgressBarStyle{ id: defaultStyle }
}
