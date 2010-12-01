import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: progressBar

    property real value: 0
    property real minimumValue: 0
    property real maximumValue: 100
    property bool indeterminate: false

    property color backgroundColor: "white"
    property color progressColor: "lightgreen"

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    width: minimumWidth
    height: minimumHeight

    property Component background: defaultStyle.background
    property Component progress: defaultStyle.progress
    property Component indeterminateProgress: defaultStyle.indeterminateProgress

    Loader {
        id: groove
        property alias indeterminate:progressBar.indeterminate
        property alias value:progressBar.value
        property alias maximumValue:progressBar.maximumValue
        property alias minimumValue:progressBar.minimumValue

        sourceComponent: background
        anchors.fill: parent
    }

    Item {
        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin

        Loader {
            id: progressComponent
            property alias indeterminate:progressBar.indeterminate
            property alias value:progressBar.value
            property alias maximumValue:progressBar.maximumValue
            property alias minimumValue:progressBar.minimumValue
            property real complete: (value-minimumValue)/(maximumValue-minimumValue)
            property alias widget: progressBar

            opacity: !indeterminate && value > 0 ? 1 : 0
            width: Math.round((progressBar.width-leftMargin-rightMargin)*(complete))
            height: progressBar.height-topMargin-bottomMargin
            anchors.left:parent.left
            sourceComponent: progressBar.progress
        }

        Loader {
            id: indeterminateComponent
            property alias widget: progressBar
            property alias indeterminate:progressBar.indeterminate
            property alias value:progressBar.value
            property alias maximumValue:progressBar.maximumValue
            property alias minimumValue:progressBar.minimumValue

            opacity: indeterminate ? 1 : 0
            anchors.fill: parent
            sourceComponent: indeterminateProgress
        }
    }

    DefaultStyles.ProgressBarStyle { id: defaultStyle }
}
