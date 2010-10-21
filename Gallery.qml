import Qt 4.7
import com.meego 1.0 as Meego

Rectangle {
    transformOrigin: Item.TopLeft
    width: 800
    height: 640

    Rectangle {
        visible: redButton.visible
        color: "black"
        width: redButton.width
        height: redButton.height
        x: redButton.x + column.anchors.margins
        y: redButton.y + column.anchors.margins
        radius: 5
    }

    //scale: 2
    Column {
        id: column
        anchors.fill: parent
        spacing: 12
        anchors.margins: 20

        Button {
            text:"hello world"
            width: 200
        }

        Button {
            text:"push"
            backgroundColor:"gold"
            foregroundColor: "black"
        }

        Button {
            text:"test"
            backgroundColor: pressed ? "indigo": "steelblue"
            Behavior on backgroundColor { ColorAnimation {} }
            icon: "images/qt-logo.png"
        }

        Button { id: redButton
            text:"red"
            background: Image {
                id: bkg
                source: pressed ? "images/bt_red.png": "images/bt_red_pressed.png"
            }
            foregroundColor: "white"
        }

        Button { id: coolButton
            text:"test"
            background: Rectangle {
                anchors.fill: parent
                color: pressed ? "orange": "crimson"
                radius: 9
                border.width: 2
                border.color: "salmon"
                Behavior on color { ColorAnimation {} }
            }
            content: Text {
                text: coolButton.text
                font.bold: true
                font.pixelSize: 16
                color: pressed ? "white": "black"
            }
        }

        Meego.Button {
            text: "meego"
        }

        Slider {
        }

        Slider { id: coolSlider
            width: 250
            height: 6
            showProgress: true
            background: Rectangle {
                color: "lightgrey"
                radius: 5
                border.width: 1
                border.color: "black"
            }
            content: Rectangle {
                color: generateColor()
                radius: 5
                border.width: 1
                border.color: "black"
            }
            handle: Rectangle {
                color: "black"
                radius: 5
                height: coolSlider.height * 3
                width: height
            }
        }
	LineEdit {
		text: "Some text"
	}
	LineEdit {
		text: "Some text"
		backgroundColor:"purple"
	}
	SpinBox {
	}
	SpinBox {
		backgroundColor:"purple"
	}


    }

    function generateColor() {
        return Qt.hsla(0.33 - (coolSlider.value / 300), 1, 0.5, 1)
    }
}
