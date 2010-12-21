import Qt 4.7
import "../../../components" as Components

// ### import QtComponents to load meego imageprovider
import com.meego.themebridge 1.0

Components.Slider{
    id:slider

    minimumWidth: 400;
    minimumHeight: 40;
    leftMargin: 30
    rightMargin: 30


    Style {
        id: sliderStyle
        styleClass: "MSliderStyle"
    }

    handle: Image {
        source: slider.pressed ?
                    "image://theme/meegotouch-slider-handle-background-pressed-horizontal" :
                    "image://theme/meegotouch-slider-handle-background-horizontal"
    }

    onPressedChanged: {
        if (pressed) {
            sliderStyle.feedback("pressFeedback");
        } else {
            sliderStyle.feedback("releaseFeedback");
        }
    }


    groove: Item {

        BorderImage {
            source: "image://theme/meegotouch-slider-background-horizontal"
            border { left: 4; top: 4; right: 4; bottom: 4 }
            height: 12

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right

            anchors.leftMargin:20
            anchors.rightMargin: 20
            BorderImage {
                source: "image://theme/meegotouch-slider-elapsed-background-horizontal"
                border { left: 4; top: 4; right: 4; bottom: 4 }
                height: 12

                anchors.verticalCenter: parent.verticalCenter
                x: positionForValue(0)
                width: handlePosition - x
            }
        }
    }

    valueIndicator: BorderImage {
            id: indicatorBackground
            source: "image://theme/meegotouch-slider-handle-value-background"
            border { left: 12; top: 12; right: 12; bottom: 12 }

            width: label.width + 50
            height: 80

            Image {
                id: arrow
            }

            state: slider.valueIndicatorPosition
            states: [
                State {
                    name: "Top"
                    PropertyChanges {
                        target: arrow
                        source: "image://theme/meegotouch-slider-handle-label-arrow-down"
                    }
                    AnchorChanges {
                        target: arrow
                        anchors.top: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                },
                State {
                    name: "Bottom"
                    PropertyChanges {
                        target: arrow
                        source: "image://theme/meegotouch-slider-handle-label-arrow-up"
                    }
                    AnchorChanges {
                        target: arrow
                        anchors.bottom: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                },
                State {
                    name: "Left"
                    PropertyChanges {
                        target: arrow
                        source: "image://theme/meegotouch-slider-handle-label-arrow-right"
                    }
                    AnchorChanges {
                        target: arrow
                        anchors.left: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }
                },
                State {
                    name: "Right"
                    PropertyChanges {
                        target: arrow
                        source: "image://theme/meegotouch-slider-handle-label-arrow-right"
                    }
                    AnchorChanges {
                        target: arrow
                        anchors.right: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            ]

            Label {
                id: label
                anchors.centerIn: parent
                styleObjectName: "MSliderHandleLabel"
                text: slider.value
                color:"white"
            }

            // Native libmeegotouch slider value indicator pops up 100ms after pressing
            // the handle... but hiding happens without delay.
            visible: slider.valueIndicatorVisible && slider.pressed
            Behavior on visible {
                enabled: !indicatorBackground.visible
                PropertyAnimation {
                    duration: 100
                }
            }
        }



    /*    handle: BorderImage {
        source: pressed ? "image://theme/meegotouch-button-background-pressed" :
        "image://theme/meegotouch-button-background"
        border.top: 8
        border.bottom: 8
        border.left: 22
        border.right: 22
    }*/
}

