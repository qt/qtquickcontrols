import QtQuick 2.0
import QtDesktop 0.1

ApplicationWindow {
    width: 400
    height: 400

    Rectangle {
        id: back
        anchors.fill: parent
        color: enabled ? "red" : "blue"
    }

    Column {
        spacing: 8
        anchors.centerIn: parent

        Row {
            Button {
                id: button1
                focus: true
                text: "Button 1"
                activeFocusOnPress: true
                KeyNavigation.tab: button2
                onClicked: back.enabled = !back.enabled
            }
            Button {
                id: button2
                text: "Button 2"
                activeFocusOnPress: true
                KeyNavigation.tab: button3
                KeyNavigation.backtab: button1
                onClicked: back.enabled = !back.enabled
            }
            Button {
                id: button3
                text: "Button 3"
                activeFocusOnPress: true
                KeyNavigation.tab: checkbox1
                KeyNavigation.backtab: button2
                onClicked: back.enabled = !back.enabled
            }
        }

        Row {
            CheckBox {
                id: checkbox1
                text: "Checkbox 1"
                activeFocusOnPress: true
                KeyNavigation.tab: checkbox2
                KeyNavigation.backtab: button3
                onClicked: back.enabled = !back.enabled
            }
            CheckBox {
                id: checkbox2
                text: "Checkbox 2"
                activeFocusOnPress: true
                KeyNavigation.tab: checkbox3
                KeyNavigation.backtab: checkbox1
                onClicked: back.enabled = !back.enabled
            }
            CheckBox {
                id: checkbox3
                text: "Checkbox 3"
                activeFocusOnPress: true
                KeyNavigation.tab: radioButton1
                KeyNavigation.backtab: checkbox2
                onClicked: back.enabled = !back.enabled
            }
        }

        ButtonRow {
            exclusive: true
            RadioButton {
                id: radioButton1
                text: "RadioButton 1"
                activeFocusOnPress: true
                KeyNavigation.tab: radioButton2
                KeyNavigation.backtab: checkbox3
                onClicked: back.enabled = !back.enabled
            }
            RadioButton {
                id: radioButton2
                text: "RadioButton 2"
                activeFocusOnPress: true
                KeyNavigation.tab: radioButton3
                KeyNavigation.backtab: radioButton1
                onClicked: back.enabled = !back.enabled
            }
            RadioButton {
                id: radioButton3
                text: "RadioButton 3"
                activeFocusOnPress: true
                KeyNavigation.backtab: radioButton2
                onClicked: back.enabled = !back.enabled
            }
        }
    }
}
