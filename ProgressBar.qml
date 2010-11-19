import Qt 4.7
import Qt.labs.components 1.0    // ImplicitlySizedItem. See QTBUG-14957
import "./styles/default" as DefaultStyles

Item{
    id: progressBar

    property real startValue: 0
    property real endValue: 0

    // percentComplete should be read only
    property real currentValue: 0 // startValue + (endValue*percentComplete/100.0)

    property real percentComplete: Math.round(currentValue/(endValue-startValue)*100.0)

    property Component background: defaultStyle.background
    property Component content: defaultStyle.content

    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: preferredWidth
    height: preferredHeight

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
