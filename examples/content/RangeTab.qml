import QtQuick 2.0
import QtDesktop 1.0

Row {
    anchors.fill: parent
    anchors.margins:16
    spacing:16

    Column {
        spacing:12

        GroupBox {
            title: "Animation options"
            adjustToContentSize: true
            ButtonRow {
                exclusive: false
                CheckBox {
                    id:fade
                    text: "Fade on hover"
                }
                CheckBox {
                    id: scale
                    text: "Scale on hover"
                }
            }
        }
        Row {
            spacing: 20
            Column {
                spacing: 10
                Button {
                    width:200
                    text: "Push button"
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                Slider {
                    value: 0.5
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                Slider {
                    id : slider1
                    value: 50
                    tickmarksEnabled: false
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                ProgressBar {
                    value: 0.5
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
                ProgressBar {
                    indeterminate: true
                    scale: scale.checked && containsMouse ? 1.1 : 1
                    opacity: !fade.checked || containsMouse ? 1 : 0.5
                    Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                    Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
                }
            }
            Dial{
                width: 120
                height: 120
                scale: scale.checked && containsMouse ? 1.1 : 1
                opacity: !fade.checked || containsMouse ? 1 : 0.5
                Behavior on scale { NumberAnimation { easing.type: Easing.OutCubic ; duration: 120} }
                Behavior on opacity { NumberAnimation { easing.type: Easing.OutCubic ; duration: 220} }
            }
        }
    }
}

