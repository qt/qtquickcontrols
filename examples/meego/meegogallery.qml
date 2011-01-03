import Qt 4.7


import com.meego 1.0 as Meego
import "meegotheme"

Rectangle {
    width: 4*240
    height: 600

    Item {
        anchors.margins:8
        anchors.fill:parent
        Row {
            spacing:20
            Column {
                spacing:20
                Text{ text: "Based on Custom"}
                Row {
                    spacing:6
                    Button{text:"Text"}
                    Button{iconSource:"images/folder_new.png"}
                    Button{text:"Text"; iconSource:"images/folder_new.png"}
                    CheckBox{}
                }
                ProgressBar {
                    width:400
                    Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                }
                ProgressBar {
                    width:400
                    indeterminate: true
                }
                Row {
                    spacing:6
                    TextField{}
                    TextArea{}
                }
                Slider{}
                ButtonBlock{
                    model: ListModel{
                        ListElement{text:"one" ; iconSource:"images/folder_new.png"}
                        ListElement{text:"two" }
                        ListElement{text:"three"}
                    }
                }
            }
            Column{
                spacing:20
                Text{ text: "Based on mainline" }
                Row {
                    spacing:6
                    Meego.Button{text:"Text"}
                    Meego.Button{text:""; iconSource:"images/folder_new.png"}
                    Meego.Button{text:"Text"; iconSource:"images/folder_new.png"}
                    Meego.CheckBox{}
                }
                Meego.ProgressBar {
                    width:400
                    Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                }
                Meego.ProgressBar {
                    width:400
                    indeterminate: true
                }
                Row {
                    spacing:6
                    Meego.LineEdit{width:200}
                    Meego.MultiLineEdit{width:200}
                }
                Meego.Slider{}
                Meego.ButtonRow{
                    Meego.Button{text:"one" ; iconSource: "images/folder_new.png"}
                    Meego.Button{text:"two"}
                    Meego.Button{text:"three"}
                }
            }
        }
    }
}
