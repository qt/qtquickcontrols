import QtQuick 2.0
import QtDesktop 1.0
import QtDesktop.Styles 1.0

Item {
    width: 300
    height: 200

    Column {
        anchors.margins: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        spacing: 20

        Row {
            spacing: 8
            Button {
                text: "Push me"
                style: ButtonStyle { backgroundColor: "#afe" }
            }
            Button {
                text: "Push me"
                style: ButtonStyle { backgroundColor: "#eee" }
            }
            Button {
                text: "Push me"
                style: buttonStyle
            }
        }
        Row {
            spacing: 8
            TextField {
                style: TextFieldStyle { backgroundColor: "#afe" }
            }
            TextField {
                style: TextFieldStyle { backgroundColor: "#eee" }
            }
            TextField {
                style: textfieldStyle
            }
        }
        Row {
            spacing: 8
            SpinBox {
                style: SpinBoxStyle { backgroundColor: "#afe" }
            }
            SpinBox {
                style: SpinBoxStyle { backgroundColor: "#eee" }
            }
            SpinBox {
                style: spinboxStyle
            }
        }

        Row {
            spacing: 8
            Slider {
                value: 50
                maximumValue: 100
                width: 100
                style: SliderStyle { backgroundColor: "#afe"}
            }
            Slider {
                value: 50
                maximumValue: 100
                width: 100
                style: SliderStyle { backgroundColor: "#eee"}
            }
            Slider {
                value: 50
                maximumValue: 100
                width: 100
                style: sliderStyle
            }
        }

        Row {
            spacing: 8
            ProgressBar {
                value: 50
                maximumValue: 100
                width: 100
                style: ProgressBarStyle{ backgroundColor: "#afe" }
            }
            ProgressBar {
                value: 50
                maximumValue: 100
                width: 100
                style: ProgressBarStyle{ backgroundColor: "#eee" }
            }
            ProgressBar {
                value: 50
                maximumValue: 100
                width: 100
                style: progressbarStyle
            }
        }
    }

    // Style delegates:

    property Component buttonStyle: ButtonStyle {
        background: Rectangle {
            width: 100; height:20
            color: control.pressed ? "darkGray" : "lightGray"
            antialiasing: true
            border.color: "gray"
            radius: height/2
        }
    }

    property Component textfieldStyle: TextFieldStyle {
        background: Rectangle {
            width: 100
            height: 20
            color: "#f0f0f0"
            antialiasing: true
            border.color: "gray"
            radius: height/2
        }
    }

    property Component sliderStyle: SliderStyle {

        handle: Rectangle {
            width: 10
            height:20
            color: control.pressed ? "darkGray" : "lightGray"
            border.color: "gray"
            antialiasing: true
            radius: height/2
        }

        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 8
            antialiasing: true
            color: "darkGray"
            border.color: "gray"
            radius: height/2
        }
    }

    property Component spinboxStyle: SpinBoxStyle {
        leftMargin: 8
        topMargin: 1
        background: Rectangle {
            width: 100
            height: 20
            color: "#f0f0f0"
            border.color: "gray"
            antialiasing: true
            radius: height/2
        }
    }

    property Component progressbarStyle: ProgressBarStyle {
        background: Rectangle {
            width: 100
            height: 20
            color: "#f0f0f0"
            border.color: "gray"
            antialiasing: true
            radius: height/2
        }
    }
}

