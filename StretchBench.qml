import Qt 4.7

Item {
    width: 800
    height: 500

    Rectangle {
        id: listPanel
        color: "gray";
        width: 150
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        ListView {
            id: componentsList
            anchors.fill: parent

            onCurrentIndexChanged: {
                redJiggRect.loadComponent(model.get(currentIndex).component)
            }

            model: ListModel {
                ListElement { component: "Button" }
                ListElement { component: "CheckBox" }
                ListElement { component: "RadioButton" }
                ListElement { component: "Switch" }
                ListElement { component: "Slider" }
                ListElement { component: "ProgressBar" }
                ListElement { component: "LineEdit" }
                ListElement { component: "SpinBox" }
            }

            highlight: Rectangle { color: "blue" }
            delegate: Item {
                width: componentsList.width
                height: itemText.height
                Text { id: itemText; text: component; font.pixelSize: 24; anchors.margins: 6 }
                MouseArea { anchors.fill: parent; onPressed: componentsList.currentIndex = index }
            }
        }
    }

    Rectangle {
        id: testBenchRect
        anchors.left: listPanel.right; anchors.right: parent.right
        anchors.top: parent.top; anchors.bottom: parent.bottom

        Rectangle {
            id: topLeftHandle
            width: 30; height: 30
            color: "lightblue"

            MouseArea {
                anchors.fill: parent
                onPressed: redJiggRect.state = "pressed"
                drag.target: topLeftHandle
            }
        }

        Rectangle {
            id: redJiggRect
            color: "red"
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
                onLoaded: {
                    topLeftHandle.x = (testBenchRect.width-loader.item.width)/2 - topLeftHandle.width
                    topLeftHandle.y = (testBenchRect.height-loader.item.height)/2 - topLeftHandle.height
                    bottomRightHandle.x = (testBenchRect.width-loader.item.width)/2 + loader.item.width
                    bottomRightHandle.y = (testBenchRect.height-loader.item.height)/2 + loader.item.height
                }
            }

            states: State { name: "pressed"
                PropertyChanges {
                    target: loader
                    anchors.fill: redJiggRect
                }
            }
        }

        Rectangle {
            id: bottomRightHandle
            width: 30; height: 30
            color: "blue"

            MouseArea {
                anchors.fill: parent
                onPressed: redJiggRect.state = "pressed"
                drag.target: bottomRightHandle
            }
        }
    }
}
