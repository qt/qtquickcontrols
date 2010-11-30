import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: progressBar

    property real value: 0
    property real minimumValue: 0
    property real maximumValue: 100
    property bool indeterminate: false

    property color backgroundColor: "green"
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
        id: clipRect
        property real complete: (value-minimumValue)/(maximumValue-minimumValue)
        property int glowMargins: 50
        opacity: !indeterminate && enabled ? 1 : 0  //mm correct to always hide when !enabled?
        anchors.fill: parent
        anchors.margins: -glowMargins
        anchors.rightMargin: rightMargin + Math.round((progressBar.width-leftMargin-rightMargin)*(1-complete))
        clip: true
        Loader {
            id: progressComponent
            property alias indeterminate:progressBar.indeterminate
            property alias value:progressBar.value
            property alias maximumValue:progressBar.maximumValue
            property alias minimumValue:progressBar.minimumValue

            opacity: indeterminate ? 0 : 1   //mm correct to always hide when !enabled?
            x: clipRect.glowMargins+leftMargin  //mm see QTBUG-15652
            y: clipRect.glowMargins+topMargin
            width: progressBar.width-leftMargin-rightMargin
            height: progressBar.height-topMargin-bottomMargin
            sourceComponent: progressBar.progress   // qualify "progress" so not to use Loader's property
        }
    }

    Loader {
        id: indeterminateComponent
        property alias indeterminate:progressBar.indeterminate
        property alias value:progressBar.value
        property alias maximumValue:progressBar.maximumValue
        property alias minimumValue:progressBar.minimumValue

        opacity: indeterminate && enabled ? 1 : 0   //mm correct to always hide when !enabled?
        anchors.fill: parent    //mm The loaded item's size does not get set in this one case!!?

        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin
        sourceComponent: indeterminateProgress
    }


    DefaultStyles.ProgressBarStyle { id: defaultStyle }
}
