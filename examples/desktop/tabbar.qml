import Qt 4.7
import "widgets"

TabFrame {
    width: 640
    height: 480

    Tab{
        title:"First"
        Rectangle{
            color:"red"
        }
    }
    Tab {
        title: "Second"
        Rectangle{
            color:"blue"
        }
    }
    Tab {
        title: "Third"
        Rectangle{
            property string title:"faen 3"
            color:"green"
        }
    }
}
