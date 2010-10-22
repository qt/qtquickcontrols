import Qt 4.7
import com.meego 1.0 as Meego

Rectangle {
    transformOrigin: Item.TopLeft
    width: 800
    height: 640

    gradient: Gradient{
        GradientStop{ position:0 ; color:"#aaa"}
        GradientStop{ position:1 ; color:"#ccc"}
    }
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

//        Meego.Button {
//            text: "meego"
 //       }

        Slider {
        }

        Slider {
            backgroundColor:"red"
        }

        Slider {
            backgroundColor:"red"
            showProgress:true
            foregroundColor:generateColor(value)
        }


        Slider {
///            showProgress: true
            foregroundColor: generateColor()
        }

        LineEdit { text: "Some text" }
	LineEdit {
		text: "Some text"
		backgroundColor:"purple"
	}

        SpinBox { }
        SpinBox { foregroundColor: "white"; backgroundColor:"#4499ff"}


    }

    function generateColor(value) {
        return Qt.hsla(0.33 - (value / 300), 1, 0.5, 1)
    }
}
