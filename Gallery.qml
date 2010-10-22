import Qt 4.7
import com.meego 1.0 as Meego

Rectangle {
    transformOrigin: Item.TopLeft
    width: 800
    height: 640

    //scale: 2
    Column {
        id: column
        anchors.fill: parent
        spacing: 12
        anchors.margins: 20

        Button {
            text:"Push Me" ;
        }

        Slider{
            backgroundColor : hover ? "#eff":"#eee"
        }

        LineEdit {
            text: "Some text" ;
        }

        SpinBox {

        }
    }

    function generateColor(value) {
        return Qt.hsla(0.33 - (value / 300), 1, 0.5, 1)
    }

    gradient: Gradient{
        GradientStop{ position:0 ; color:"#aaa"}
        GradientStop{ position:1 ; color:"#fff"}
    }

}
