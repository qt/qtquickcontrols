import Qt 4.7

Rectangle {
    width: 600
    height: 300

    Rectangle {
        radius:6
        anchors.fill:parent
        border.color: "#22000000"
        color: "#22ffffff"
        anchors.margins:20

        Column {
            id: column
            anchors.fill: parent
            spacing: 12
            anchors.margins: 20
            Button { text:"enabled"}
            Button { text:"disabled" ; enabled: false}
            LineEdit { }
            SpinBox{ }
            Slider {}
            CheckBox { }
        }

    }


    gradient: Gradient{ GradientStop{ position:0 ; color:"#aaa"} GradientStop{ position:1 ; color:"#eee"}}
}
