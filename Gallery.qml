import Qt 4.7

Rectangle {
    width: 600
    height: 400

    Rectangle {
        radius:6
        anchors.fill:parent
        border.color: "#22000000"
        color: "#22ffffff"
        anchors.margins:20

        Row {
            anchors.margins:20
            anchors.fill: parent
            spacing: 12
            Column {
                spacing: 12
                anchors.margins: 20
                Button { text:"Push me"}
                LineEdit { }
                SpinBox{ }
                Slider {}
                Switch { text: "A switch"}
                CheckBox {text:"Some Check Box"}
            }
            Column {
                enabled:false
                spacing: 12
                anchors.margins: 20
                Button { text:"Push me"}
                LineEdit { }
                SpinBox{ }
                Slider {}
                Switch { text: "A switch"}
                CheckBox {text:"Some Check Box"}
            }
        }

    }


    gradient: Gradient{ GradientStop{ position:0 ; color:"#aaa"} GradientStop{ position:1 ; color:"#eee"}}
}
