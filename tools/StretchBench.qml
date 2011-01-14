import QtQuick 1.0
import "../components"
import "stretchbench"

Item {
    width: 950
    height: 500

    property string currentComponentName: componentsList.model.get(componentsList.currentIndex).component

    Rectangle {
        id: listPanel
        color: "lightgray";
        width: 200
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        ListView {
            id: componentsList
            anchors.fill: parent

            model: ListModel {
                ListElement { component: "ChoiceList" }
                ListElement { component: "ButtonBlock" }
                ListElement { component: "ButtonRow" }
                ListElement { component: "ButtonColumn" }
                ListElement { component: "Switch" }
                ListElement { component: "Button" }
                ListElement { component: "CheckBox" }
                ListElement { component: "RadioButton" }
                ListElement { component: "Slider" }
                ListElement { component: "ProgressBar" }
                ListElement { component: "BusyIndicator" }
                ListElement { component: "TextField" }
                ListElement { component: "TextArea" }
                ListElement { component: "SpinBox" }
            }

            highlight: Rectangle { color: "blue" }
            delegate: Item {
                width: componentsList.width
                height: item.height
                Item { id: item
                    width: itemText.width+20; height: itemText.height+6
                    Text {
                        id: itemText; text: component; font.pixelSize: 20; anchors.centerIn: parent
                        color: index == ListView.view.currentIndex ? "white" : "black"
                    }
                }
                MouseArea { anchors.fill: parent; onPressed: componentsList.currentIndex = index }
            }
        }
    }

    Rectangle {
        anchors.fill: testBenchRect
        color: "lightblue"
    }

    Flickable {
        id: testBenchRect
        anchors.left: listPanel.right; anchors.right: testConfigPanel.left
        anchors.top: parent.top; anchors.bottom: parent.bottom
        contentWidth: width+1    // Add a little to make it flickable
        contentHeight: height+1
        clip: true

        Image {
            anchors.fill: parent
            anchors.margins: -1000
            source: "stretchbench/images/checkered.png"
            fillMode: Image.Tile
            opacity: testBenchRect.moving || topLeftHandle.pressed || bottomRightHandle.pressed ? 0.12 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Upper-left resizing handle

        MouseArea {
            id: topLeftHandle
            width: 30
            height: 30

            drag.target: topLeftHandle
            drag.minimumX: 0; drag.minimumY: 0
            drag.maximumX: bottomRightHandle.x - width
            drag.maximumY: bottomRightHandle.y - height

            Rectangle {
                anchors.fill: parent
                color: "blue"
            }
        }

        // Container for the tested Component (red when resized)

        Rectangle {
            id: container

            property bool pressed: topLeftHandle.pressed || bottomRightHandle.pressed

            color: "transparent"
            border.color: pressed ? "red" : "transparent"

            // Floor ensures that images are on integer coordinates so they stay crisp
            y:Math.floor(topLeftHandle.y + topLeftHandle.height)
            x:Math.floor(topLeftHandle.x + topLeftHandle.width)
            width:Math.floor(bottomRightHandle.x - topLeftHandle.x - topLeftHandle.width)
            height:Math.floor(bottomRightHandle.y - topLeftHandle.y - topLeftHandle.height)

            Loader {
                id: loader
                focus: true
                sourceComponent: sourceComponentFromIndex()

                onStatusChanged: {
                    if (status == Loader.Ready) {
                        anchors.fill = null;
                        topLeftHandle.x = (testBenchRect.width - item.width) / 2 - topLeftHandle.width;
                        topLeftHandle.y = (testBenchRect.height - item.height) / 2 - topLeftHandle.height;
                        bottomRightHandle.x = (testBenchRect.width - item.width) / 2 + item.width;
                        bottomRightHandle.y = (testBenchRect.height - item.height) / 2 + item.height;
                        anchors.fill = container;
                        item.anchors.fill = loader;
                    }
                }

                function sourceComponentFromIndex() {
                    var name = componentsList.model.get(componentsList.currentIndex).component;
                    switch (name) {
                    case "Button": return buttonComponent;
                    case "ButtonBlock": return buttonBlockComponent;
                    case "ButtonRow": return buttonRowComponent;
                    case "ButtonColumn": return buttonColumnComponent;
                    case "CheckBox": return checkBoxComponent;
                    case "RadioButton": return radioButtonComponent;
                    case "Switch": return switchComponent;
                    case "Slider": return sliderComponent;
                    case "ProgressBar": return progressBarComponent;
                    case "BusyIndicator": return busyIndicatorComponent;
                    case "ChoiceList": return choiceListComponent;
                    case "TextField": return lineEditComponent;
                    case "TextArea": return textAreaComponent;
                    case "SpinBox": return spinBoxComponent;
                    }
                    return null;
                }

                Rectangle {
                    color: "transparent"
                    opacity: container.pressed && loader.item.topMargin != undefined ? 1 : 0
                    border.color: "yellow"

                    anchors.fill: parent
                    anchors.leftMargin: Math.max(loader.item.leftMargin, 0)
                    anchors.rightMargin: Math.max(loader.item.rightMargin, 0)
                    anchors.topMargin: Math.max(loader.item.topMargin, 0)
                    anchors.bottomMargin: Math.max(loader.item.bottomMargin, 0)

                    z: 2
                }
            }
        }

        // Lower-right resizing handle

        MouseArea {
            id: bottomRightHandle
            width: 30
            height: 30

            drag.target: bottomRightHandle
            drag.minimumX: topLeftHandle.x + width
            drag.minimumY: topLeftHandle.y + height
            drag.maximumX: testBenchRect.width - width;
            drag.maximumY: testBenchRect.height - height

            Rectangle {
                anchors.fill: parent
                color: "blue"
            }
        }
    }

    //
    // Right-hand side Component configuration panel
    //

    Rectangle {
        id: testConfigPanel
        color: "lightgray";
        width: 250
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "Button" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: buttonOptionDimmed }
            StretchBenchBoolOption { text: "Latching:"; id: buttonOptionLatching }
            StretchBenchBoolOption { text: "Has icon:"; id: buttonOptionHasIcon }
            StretchBenchBoolOption { text: "Two-line text:"; id: buttonOptionTwoLineText }
            StretchBenchBoolOption { text: "Green background:"; id: buttonOptionGreenBackground }
            StretchBenchBoolOption { text: "White text:"; id: buttonOptionWhiteText }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "ButtonBlock" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: buttonBlockOptionDimmed }
            StretchBenchBoolOption { text: "Vertical layout"; id: buttonBlockOptionVerticalLayout }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "ChoiceList" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: choiceListOptionDimmed }
            StretchBenchBoolOption { text: "Has model:"; id: choiceListOptionHasModel }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "CheckBox" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: checkBoxOptionDimmed }
            StretchBenchBoolOption { text: "Green background:"; id: checkBoxOptionGreenBackground }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "RadioButton" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: radioButtonOptionDimmed }
            StretchBenchBoolOption { text: "Green background:"; id: radioButtonOptionGreenBackground }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "Switch" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: switchOptionDimmed }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "TextArea" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: textAreaOptionDimmed }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "Slider" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: sliderOptionDimmed }
            StretchBenchBoolOption { text: "Vertical"; id: sliderOptionVertical }
            StretchBenchBoolOption { text: "Inverted"; id: sliderOptionInverted }
            StretchBenchBoolOption { text: "Steps"; id: sliderOptionSteps; checked: true }
            StretchBenchBoolOption { text: "Value at 30:"; id: sliderOptionValueAt30 }
            StretchBenchBoolOption { text: "Zero in middle:"; id: sliderOptionZeroInMiddle }
            StretchBenchBoolOption { text: "Time formatted:"; id: sliderOptionTimeFormatted }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "BusyIndicator" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: busyIndicatorOptionDimmed }
            StretchBenchBoolOption { text: "Paused (i.e. !running):"; id: busyIndicatorOptionPaused }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "SpinBox" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: spinBoxOptionDimmed }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "TextField" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: lineEditOptionDimmed }
            StretchBenchBoolOption { text: "Red text color:"; id: lineEditOptionRedText; }
            StretchBenchBoolOption { text: "Italic font:"; id: lineEditOptionItalicText; }
            StretchBenchBoolOption { text: "Password mode:"; id: lineEditOptionPasswordMode; }
            StretchBenchBoolOption { text: "Focused:"; id: lineEditOptionFocused;
                onCheckedChanged: if(checked) loader.item.forceActiveFocus(); else secondTextField.focus = true; }

            TextField { id: secondTextField; placeholderText: "Click to verify focus handling"; width: 230}
            TextField { }
            TextField { }

            //mm doesn't quite seem to work
//            StretchBenchBoolOption { text: "Focused:"; checked: lineEdit.activeFocus;
//                onCheckedChanged: { if(checked) lineEdit.focus = false; else lineEdit.forceActiveFocus(); }
//            }
//            TextField { id: lineEdit }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "ProgressBar" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: progressBarOptionDimmed }
            StretchBenchBoolOption { text: "Indeterminate:"; id: progressBarOptionIndeterminate }
        }
    }

    //
    // The components that we use in the stretch bench
    //

    Component {
        id: buttonComponent
        Button {
            enabled: !buttonOptionDimmed.checked
            checkable: buttonOptionLatching.checked
            text: buttonOptionTwoLineText.checked ? "Button\nwith two lines" : "Button"
            iconSource: buttonOptionHasIcon.checked ? "images/testIcon.png" : ""
            backgroundColor: buttonOptionGreenBackground.checked ? "green" : "#fff"
            textColor: buttonOptionWhiteText.checked ? "white" : "black"
        }
    }

    Component {
        id: buttonBlockComponent
        ButtonBlock {
            //orientation: Qt.Vertical
            model: ListModel {
                ListElement { text: "Button A" }
                ListElement { text: "Button B1" }
                ListElement { text: "Button C12" } //;iconSource: "images/testIcon.png" }
                ListElement { text: "Button D123" }
            }
            onClicked: model.setProperty(1, "text", "Foo")
            enabled: !buttonBlockOptionDimmed.checked
            orientation: buttonBlockOptionVerticalLayout.checked ? Qt.Vertical : Qt.Horizontal
        }
    }
    Component {
        id: buttonRowComponent
        ButtonRow {
            Button { text: "Button A" }
            Button { text: "Button B1" }
            Button { text: "Button C12" } //;iconSource: "images/testIcon.png" }
            Button { text: "Button D123" }
        }
    }
    Component {
        id: buttonColumnComponent
        ButtonColumn {
            Button { text: "Button A" }
            Button { text: "Button B1" }
            Button { text: "Button C12" }
            Button { text: "Button D123" }
        }
    }

    Component {
        id: checkBoxComponent
        CheckBox {
            enabled: !checkBoxOptionDimmed.checked
            backgroundColor: checkBoxOptionGreenBackground.checked ? "green" : "#fff"
        }
    }

    Component {
        id: radioButtonComponent
        RadioButton {
            enabled: !radioButtonOptionDimmed.checked
            backgroundColor: radioButtonOptionGreenBackground.checked ? "green" : "#fff"
        }
    }

    Component {
        id: sliderComponent
        Slider {
            enabled: !sliderOptionDimmed.checked
            value: sliderOptionValueAt30.checked ? 30 : 0
            minimumValue: sliderOptionZeroInMiddle.checked ? -50 : 0
            maximumValue: sliderOptionZeroInMiddle.checked ? 50 : 100

            orientation: sliderOptionVertical.checked ? Qt.Vertical : Qt.Horizontal
            stepSize: sliderOptionSteps.checked ? 1.0 : 0.0
            inverted: sliderOptionInverted.checked

            function formatValue(v) {
                v = Math.round(v);
                if (sliderOptionTimeFormatted.checked) {
                    var seconds = Math.floor(v % 60);
                    var minutes = Math.floor(v / 60);

                    // :-P
                    if (seconds < 10)
                        seconds = "0" + seconds;
                    return minutes + ":" + seconds
                }
                return v;
            }
        }
    }

    Component {
        id: progressBarComponent
        ProgressBar {
            enabled: !progressBarOptionDimmed.checked
            indeterminate: progressBarOptionIndeterminate.checked
            Timer {
                id: timer
                running: true
                repeat: true
                interval: 25
                onTriggered: { parent.value = (parent.value + 1) % 100 }
            }
        }
    }

    Component {
        id: busyIndicatorComponent
        BusyIndicator {
            enabled: !busyIndicatorOptionDimmed.checked
            running: !busyIndicatorOptionPaused.checked
        }
    }

    Component {
        id: lineEditComponent
        TextField {
            enabled: !lineEditOptionDimmed.checked
            textColor: lineEditOptionRedText.checked ? "red" : "black"
            font.italic: lineEditOptionItalicText.checked
            passwordMode: lineEditOptionPasswordMode.checked
            focus: lineEditOptionFocused.checked
        }
    }

    Component {
        id: textAreaComponent
        TextArea {
            enabled: !textAreaOptionDimmed.checked
        }
    }

    Component {
        id: switchComponent
        Switch {
            enabled: !switchOptionDimmed.checked
        }
    }

    Component {
        id: choiceListComponent
        ChoiceList {
            enabled: !choiceListOptionDimmed.checked
            model: choiceListOptionHasModel.checked ? testDataModel : null

            ListModel {
                id: testDataModel
                ListElement { text: "1) Apple" }
                ListElement { text: "2) Banana" }
                ListElement { text: "3) Coconut" }
                ListElement { text: "4) Orange" }
                ListElement { text: "5) Kiwi" }
                ListElement { text: "6) Apple" }
                ListElement { text: "7) Banana" }
                ListElement { text: "8) Coconut" }
                ListElement { text: "9) Orange" }
                ListElement { text: "10) Kiwi" }
                ListElement { text: "11) Apple" }
                ListElement { text: "12) Banana" }
                ListElement { text: "13) Coconut" }
                ListElement { text: "14) Orange" }
                ListElement { text: "15) Kiwi" }
                ListElement { text: "16) Apple" }
                ListElement { text: "17) Banana" }
                ListElement { text: "18) Coconut" }
                ListElement { text: "19) Orange" }
                ListElement { text: "20) Kiwi" }
                ListElement { text: "21) Apple" }
                ListElement { text: "22) Banana" }
                ListElement { text: "23) Coconut" }
                ListElement { text: "24) Orange" }
                ListElement { text: "25) Kiwi" }
                ListElement { text: "26) Apple" }
                ListElement { text: "27) Banana" }
                ListElement { text: "28) Coconut" }
                ListElement { text: "29) Orange" }
                ListElement { text: "30) Kiwi" }
            }
        }
    }

    Component {
        id: spinBoxComponent
        SpinBox {
            enabled: !spinBoxOptionDimmed.checked
        }
    }
}
