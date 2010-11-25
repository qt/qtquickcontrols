import Qt 4.7

Item {
    width: 900
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
                ListElement { component: "Button" }
                ListElement { component: "CheckBox" }
                ListElement { component: "RadioButton" }
                ListElement { component: "Switch" }
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
                    Text { id: itemText; text: component; font.pixelSize: 20; anchors.centerIn: parent }
                }
                MouseArea { anchors.fill: parent; onPressed: componentsList.currentIndex = index }
            }
        }
    }

    Rectangle {
        id: testBenchRect
        anchors.left: listPanel.right; anchors.right: testConfigPanel.left
        anchors.top: parent.top; anchors.bottom: parent.bottom

        // Upper-left resizing handle

        Rectangle {
            id: topLeftHandle
            width: 30; height: 30
            color: "lightblue"

            MouseArea {
                anchors.fill: parent
                onPressed: redJiggRect.state = "pressed"
                onReleased: redJiggRect.state = ""
                drag.target: topLeftHandle
            }
        }

        // Container for the tested Component (red when resized)

        Rectangle {
            id: redJiggRect
            color: state == "pressed" ? "red" : "white"
            anchors.top: topLeftHandle.bottom
            anchors.left: topLeftHandle.right
            anchors.bottom: bottomRightHandle.top
            anchors.right: bottomRightHandle.left

            function loadComponent(componentName) {
                redJiggRect.state = ""
                loader.source = componentName + ".qml"
            }

            Loader {
                id: loader
                focus: true
                onSourceChanged: loader.state = ""
                onLoaded: {
                    topLeftHandle.x = (testBenchRect.width-loader.item.width)/2 - topLeftHandle.width
                    topLeftHandle.y = (testBenchRect.height-loader.item.height)/2 - topLeftHandle.height
                    bottomRightHandle.x = (testBenchRect.width-loader.item.width)/2 + loader.item.width
                    bottomRightHandle.y = (testBenchRect.height-loader.item.height)/2 + loader.item.height

                    switch(currentComponentName) {
                        case "Button": { loader.state =  "buttonTest"; break }
                        case "LineEdit": { loader.state =  "lineEditTest"; break }
                        case "ChoiceList": { loader.state =  "choiceListTest"; break }
                        case "ProgressBar": { loader.state =  "progressBarTest"; break }
                    }
                }

                states: [
                    State { name: "progressBarTest"
                        PropertyChanges {
                            target: timer
                            onTriggered: { loader.item.value = (loader.item.value + 1) % 100 }
                        }
                        PropertyChanges {
                            target: loader.item
                            indeterminate: progressBarOption1.checked
                        }
                    },
                    State { name: "lineEditTest"
                        PropertyChanges {
                            target: loader.item
                            textColor: lineEditOption1.checked ? "red" : "black"
                            font.italic: lineEditOption2.checked
                            passwordMode: lineEditOption3.checked
                        }
                    },
                    State { name: "choiceListTest"
                        PropertyChanges {
                            target: loader.item
                            model: choiceListOption1.checked ? testDataModel : undefined
                        }
                    }
                ]

                Timer { id: timer; running: true; repeat: true; interval: 25; }
                ListModel {
                    id: testDataModel
                    ListElement { text: "Apple" }
                    ListElement { text: "Banana" }
                    ListElement { text: "Coconut" }
                    ListElement { text: "Orange" }
                    ListElement { text: "Kiwi" }
                }
            }

            states: State { name: "pressed"
                PropertyChanges {
                    target: loader
                    anchors.fill: redJiggRect
                }
            }

            // Yellow outlined rect showing component's margins
            Rectangle {
                opacity: redJiggRect.state == "pressed" && loader.item.topMargin != undefined ? 1 : 0
                color: "transparent"
                border.color: "yellow"
                anchors.fill: loader
                anchors.leftMargin: loader.item.leftMargin != undefined ? loader.item.leftMargin : 0
                anchors.rightMargin: loader.item.rightMargin != undefined ? loader.item.rightMargin : 0
                anchors.topMargin: loader.item.topMargin != undefined ? loader.item.topMargin : 0
                anchors.bottomMargin: loader.item.bottomMargin != undefined ? loader.item.bottomMargin : 0
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
            }
        }
    }

    //
    // Right-hand side Component configuration panel
    //

    Rectangle {
        id: testConfigPanel
        color: "lightgray";
        width: 200
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

//        Column {
//            anchors.fill: parent; anchors.margins: 10; spacing: 5
//            opacity: currentComponentName == "Button" ? 1 : 0
//            StretchBenchConfigOption { text: "Has icon: "; id: buttonOption1 }
//        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "ChoiceList" ? 1 : 0
            StretchBenchBoolOption { text: "Has model: "; id: choiceListOption1 }
        }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "LineEdit" ? 1 : 0
            StretchBenchBoolOption { text: "Red text color:"; id: lineEditOption1; }
            StretchBenchBoolOption { text: "Italic font:"; id: lineEditOption2; }
            StretchBenchBoolOption { text: "Password mode:"; id: lineEditOption3; }
            }

        Column {
            anchors.fill: parent; anchors.margins: 10; spacing: 5
            opacity: currentComponentName == "ProgressBar" ? 1 : 0
            StretchBenchBoolOption { text: "Indeterminate:"; id: progressBarOption1 }
        }
    }

}
