import Qt 4.7


import com.meego 1.0 as Meego
import "meegotheme"

Rectangle {
    width: 4*240
    height: 440

    Item {
        anchors.margins:8
        anchors.fill:parent
        Column {
            spacing:6

            Row {
                spacing:6
                Button{text:"Text"}
                Button{iconSource:"images/folder_new.png"}
                Button{text:"Text"; iconSource:"images/folder_new.png"}
                CheckBox{}
                TextField{}
            }

            Row {
                spacing:6
                Meego.Button{text:"Text"}
                Meego.Button{text:""; iconSource:"images/folder_new.png"}
                Meego.Button{text:"Text"; iconSource:"images/folder_new.png"}
                Meego.CheckBox{}
                Meego.TextField{}
            }
        }
    }
}
