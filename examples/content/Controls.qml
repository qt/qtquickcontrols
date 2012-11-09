import QtQuick 2.0
import QtDesktop 1.0
import QtDesktop.Styles 1.0

Item {
    id: flickable
    anchors.fill: parent
    enabled: enabledCheck.checked

    property string tabPosition: tabPositionGroup.checkedButton == r2 ? "South" : "North"

    Row {
        id: contentRow
        anchors.fill:parent
        anchors.margins: 8
        spacing: 16
        Column {
            spacing: 9
            Row {
                spacing:8
                Button {
                    id: button1
                    text: "Button 1"
                    width: 96
                    tooltip:"This is an interesting tool tip"
                    KeyNavigation.tab: button2
                }
                Button {
                    id:button2
                    text:"Button 2"
                    width:96
                    KeyNavigation.tab: combo
                }
            }
            ComboBox {
                id: combo;
                model: choices;
                width: parent.width;
                KeyNavigation.tab: t1
            }
            Row {
                spacing: 8
                SpinBox {
                    id: t1
                    width: 97

                    minimumValue: -50
                    value: -20

                    KeyNavigation.tab: t2
                }
                SpinBox {
                    id: t2
                    width:97
                    KeyNavigation.tab: t3
                }
            }
            TextField {
                id: t3
                KeyNavigation.tab: slider
                placeholderText: "This is a placeholder for a TextField"
            }
            ProgressBar {
                // normalize value [0.0 .. 1.0]
                value: (slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)
            }
            ProgressBar {
                indeterminate: true
            }
            Slider {
                id: slider
                value: 0.5
                tickmarksEnabled: tickmarkCheck.checked
                KeyNavigation.tab: frameCheckbox
            }
        }
        Column {
            id: rightcol
            spacing: 12
            GroupBox {
                id: group1
                title: "CheckBox"
                width: area.width
                adjustToContentSize: true
                ButtonRow {
                    exclusive: false
                    CheckBox {
                        id: frameCheckbox
                        text: "Text frame"
                        checked: true
                        KeyNavigation.tab: tickmarkCheck
                    }
                    CheckBox {
                        id: tickmarkCheck
                        text: "Tickmarks"
                        checked: true
                        KeyNavigation.tab: r1
                    }
                }
            }
            GroupBox {
                id: group2
                title:"Tab Position"
                width: area.width
                adjustToContentSize: true
                ButtonRow {
                    id: tabPositionGroup
                    exclusive: true
                    RadioButton {
                        id: r1
                        text: "North"
                        KeyNavigation.tab: r2
                        checked: true
                    }
                    RadioButton {
                        id: r2
                        text: "South"
                        KeyNavigation.tab: area
                    }
                }
            }

            TextArea {
                id: area
                frame: frameCheckbox.checked
                text: loremIpsum + loremIpsum
                KeyNavigation.tab: button1
            }
        }
    }
}
