import Qt 4.7

Rectangle {
    width: 700
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
                LineEdit { text:"Text"}
                SpinBox{ }
                Slider {}
                Switch { text: "A switch"}
                CheckBox {text:"Some Check Box"}
                ComboBox{ text:"items" }
            }
            Column {
                enabled:false
                spacing: 12
                anchors.margins: 20
                Button { text:"Push me"}
                LineEdit { text:"Text"}
                SpinBox{ }
                Slider {}
                Switch { text: "A switch"}
                CheckBox {text:"Some Check Box"}
                ComboBox{ text:"items"}
            }
            Column {
                id:column3
                spacing: 12
                anchors.margins: 20
                property variant bg: "#bef"
                property variant fg: "#356"

                Button { text:"Push me" ; backgroundColor: column3.bg; foregroundColor: column3.fg}
                LineEdit { text:"Text"; backgroundColor: column3.bg; foregroundColor: column3.fg}
                SpinBox{ backgroundColor: column3.bg; foregroundColor: column3.fg}
                Slider { backgroundColor: column3.bg; progressColor: "blue";}
                Switch { text: "A switch";backgroundColor: column3.bg; foregroundColor: column3.fg}
                CheckBox { text:"Some Check Box";backgroundColor: column3.bg; foregroundColor: column3.fg}
                ComboBox{ text:"items";backgroundColor: column3.bg; foregroundColor: column3.fg}
            }
        }

    }


    gradient: Gradient{ GradientStop{ position:0 ; color:"#aaa"} GradientStop{ position:1 ; color:"#eee"}}
}
