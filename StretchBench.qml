import Qt 4.7

Item {
    width: 950
    height: 500

    property string currentComponentName

    Rectangle {
        id: listPanel
        color: "lightgray";
        width: 200
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        ListView {
            id: componentsList
            anchors.fill: parent

            onCurrentIndexChanged: {
                currentComponentName = componentsList.model.get(componentsList.currentIndex).component
                redJiggRect.loadComponent(currentComponentName)
            }

            model: ListModel {
                ListElement { component: "ButtonBlock" }
                ListElement { component: "Switch" }
                ListElement { component: "Button" }
                ListElement { component: "CheckBox" }
                ListElement { component: "RadioButton" }
                ListElement { component: "Slider" }
                ListElement { component: "ProgressBar" }
                ListElement { component: "BusyIndicator" }
                ListElement { component: "ChoiceList" }
                ListElement { component: "LineEdit" }
                ListElement { component: "MultiLineEdit" }
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
            source: "images/checkered.png"
            fillMode: Image.Tile
            opacity: testBenchRect.moving || redJiggRect.state == "pressed" ? 0.12 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        // Upper-left resizing handle

        Rectangle {
            id: topLeftHandle
            width: 30; height: 30
            color: "blue"

            MouseArea {
                anchors.fill: parent
                onPressed: redJiggRect.state = "pressed"
                onReleased: redJiggRect.state = ""
                drag.target: topLeftHandle
                drag.minimumX: 0; drag.minimumY: 0
                drag.maximumX: bottomRightHandle.x-width
                drag.maximumY: bottomRightHandle.y-height
            }
        }

        // Container for the tested Component (red when resized)

        Rectangle {
            id: redJiggRect
            color: "transparent"
            border.color: state == "pressed" ? "red" : "transparent"
            anchors.top: topLeftHandle.bottom
            anchors.left: topLeftHandle.right
            anchors.bottom: bottomRightHandle.top
            anchors.right: bottomRightHandle.left

            property Item testItem

            function loadComponent(componentName) {
                redJiggRect.state = ""
                var str = 'import QtQuick 1.0;'

                switch (componentName) {
                case "Button": str +=
                    'Button { ' +
                    '   enabled: !buttonOptionDimmed.checked;' +
                    '   checkable: buttonOptionLatching.checked;' +
                    '   iconSource: buttonOptionHasIcon.checked ? "images/testIcon.png" : "";' +
                    '   text: buttonOptionTwoLineText.checked ? "Button\\nwith two lines" : "Button";' +
                    '   backgroundColor: buttonOptionGreenBackground.checked ? "green" : "#fff";' +
                    '   textColor: buttonOptionWhiteText.checked ? "white" : "black";' +
                    '}';
                    break;
                case "ButtonBlock": str +=
                    'ButtonBlock { ' +
//                    '    orientation: Qt.Vertical;' +
                    '    model: ListModel {' +
                    '        ListElement { text: "Button A" }' +
                    '        ListElement { text: "Button B1" }' +
                    '        ListElement { text: "Button C12" } ' + //;iconSource: "images/testIcon.png" }' +
                    '        ListElement { text: "Button D123" }' +
                    '    }' +
                    '   onClicked: model.setProperty(1, "text", "Foo")' +
                    '}'
                    break;
                case "CheckBox": str +=
                    'CheckBox { ' +
                    '   enabled: !checkBoxOptionDimmed.checked;' +
                    '   backgroundColor: checkBoxOptionGreenBackground.checked ? "green" : "#fff";' +
                    '}';
                    break;
                case "RadioButton": str +=
                    'RadioButton { ' +
                    '   enabled: !radioButtonOptionDimmed.checked;' +
                    '   backgroundColor: radioButtonOptionGreenBackground.checked ? "green" : "#fff";' +
                    '}';
                    break;
                case "Slider": str +=
                    'Slider { ' +
                    '   enabled: !sliderOptionDimmed.checked;' +
                    '   value: sliderOptionValueAt30.checked ? 30 : 0;' +
                    '   minimumValue: sliderOptionZeroInMiddle.checked ? -50 : 0;' +
                    '   maximumValue: sliderOptionZeroInMiddle.checked ? 50 : 100;' +
//                    '   text: sliderOptionTimeFormatted.checked ? Math.floor(value/60) + ":" + value%60 : value;' +
                    '}';
                    break;
                case "ProgressBar": str +=
                    'ProgressBar { ' +
                    '   enabled: !progressBarOptionDimmed.checked;' +
                    '   indeterminate: progressBarOptionIndeterminate.checked;' +
                    '   Timer { id: timer; running: true; repeat: true; interval: 25;' +
                    '       onTriggered: { parent.value = (parent.value + 1) % 100 }' +
                    '   }' +
                    '}';
                    break;
                case "BusyIndicator": str +=
                    'BusyIndicator { ' +
                    '   enabled: !busyIndicatorOptionDimmed.checked;' +
                    '   running: !busyIndicatorOptionPaused.checked;' +
                    '}';
                    break;
                case "LineEdit": str +=
                    'LineEdit { ' +
                    '   enabled: !lineEditOptionDimmed.checked;' +
                    '   textColor: lineEditOptionRedText.checked ? "red" : "black";' +
                    '   font.italic: lineEditOptionItalicText.checked;' +
                    '   passwordMode: lineEditOptionPasswordMode.checked;' +
                    '}';
                    break;
                case "MultiLineEdit": str +=
                    'MultiLineEdit { ' +
                    '   enabled: !multiLineEditOptionDimmed.checked;' +
                    '}';
                    break;
                case "Switch": str +=
                    'Switch { ' +
                    '   enabled: !switchOptionDimmed.checked;' +
                    '}';
                    break;
                case "ChoiceList": str +=
                    'ChoiceList { ' +
                    '   enabled: !choiceListOptionDimmed.checked;' +
                    '   model: choiceListOptionHasModel.checked ? testDataModel : null;' +
                    '}';
                    break;
                case "SpinBox": str +=
                   'SpinBox { ' +
                   '   enabled: !spinBoxOptionDimmed.checked;' +
                   '}';
                    break;
                }

                var newObject = Qt.createQmlObject(str, redJiggRect);
                topLeftHandle.x = (testBenchRect.width-newObject.width)/2 - topLeftHandle.width;
                topLeftHandle.y = (testBenchRect.height-newObject.height)/2 - topLeftHandle.height;
                bottomRightHandle.x = (testBenchRect.width-newObject.width)/2 + newObject.width;
                bottomRightHandle.y = (testBenchRect.height-newObject.height)/2 + newObject.height;
                newObject.anchors.fill = redJiggRect;
                if(testItem) testItem.destroy();
                testItem = newObject;

                // Yellow outlined rect showing component's margins
                Qt.createQmlObject( 'import QtQuick 1.0;' +
                'Rectangle {' +
                '    opacity: redJiggRect.state == "pressed" && redJiggRect.testItem.topMargin != undefined ? 1 : 0;' +
                '    color: "transparent";' +
                '    border.color: "yellow";' +
                '    anchors.fill: parent;' +
                '    anchors.leftMargin: Math.max(redJiggRect.testItem.leftMargin, 0);' +
                '    anchors.rightMargin: Math.max(redJiggRect.testItem.rightMargin, 0);' +
                '    anchors.topMargin: Math.max(redJiggRect.testItem.topMargin, 0);' +
                '    anchors.bottomMargin: Math.max(redJiggRect.testItem.bottomMargin, 0);' +
                '}', testItem);

            }

            ListModel {
                id: testDataModel
                ListElement { text: "Apple" }
                ListElement { text: "Banana" }
                ListElement { text: "Coconut" }
                ListElement { text: "Orange" }
                ListElement { text: "Kiwi" }
            }
        }

        // Lower-right resizing handle

        Rectangle {
            id: bottomRightHandle
            width: 30; height: 30
            color: "blue"

            MouseArea {
                anchors.fill: parent
                onPressed: redJiggRect.state = "pressed"
                onReleased: redJiggRect.state = ""
                drag.target: bottomRightHandle
                drag.minimumX: topLeftHandle.x+width
                drag.minimumY: topLeftHandle.y+height
                drag.maximumX: testBenchRect.width-width;
                drag.maximumY: testBenchRect.height-height
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
            opacity: currentComponentName == "MultiLineEdit" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: multiLineEditOptionDimmed }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "Slider" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: sliderOptionDimmed }
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
            opacity: currentComponentName == "LineEdit" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: lineEditOptionDimmed }
            StretchBenchBoolOption { text: "Red text color:"; id: lineEditOptionRedText; }
            StretchBenchBoolOption { text: "Italic font:"; id: lineEditOptionItalicText; }
            StretchBenchBoolOption { text: "Password mode:"; id: lineEditOptionPasswordMode; }
            }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "ProgressBar" ? 1 : 0
            StretchBenchBoolOption { text: "Dimmed:"; id: progressBarOptionDimmed }
            StretchBenchBoolOption { text: "Indeterminate:"; id: progressBarOptionIndeterminate }
        }
    }

}
