import Qt 4.7

Rectangle {
    width: 4*240
    height: 440

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: parent.height*2


        Rectangle {
            radius:6
            anchors.fill:parent
            border.color: "#22000000"
            color: "#22ffffff"
            anchors.margins:20

            ListModel {
                id: choices
                ListElement { content: "Banana" }
                ListElement { content: "Orange" }
                ListElement { content: "Apple" }
                ListElement { content: "Coconut" }
            }

            Row {
                anchors.margins:20
                anchors.fill: parent
                spacing: 12
                Column {
                    spacing: 12
                    anchors.margins: 20
                    Text{ font.bold:true; text:"Default:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me"}
                    LineEdit { }
                    SpinBox{ }
                    Slider { value: 50 }
                    Switch { }
                    Row{
                        CheckBox { } CheckBox { checked:true}
                        RadioButton{ } RadioButton { checked:true}
                        spacing:6
                    }
                    ComboBox{ model: choices}
                    ProgressBar {
                        progressText: percentComplete
                        endValue:100
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.currentValue = (parent.currentValue + 1) % 100 }}
                    }
                    ProgressBar { }
                }
                Column {
                    enabled:false
                    spacing: 12
                    anchors.margins: 20
                    Text{ font.bold:true; text:"Disabled:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me"}
                    LineEdit { }
                    SpinBox{ }
                    Slider { value: 50 }
                    Switch { }
                    Row{
                        CheckBox { } CheckBox { checked:true}
                        RadioButton{ } RadioButton { checked:true}
                        spacing:6
                    }
                    ComboBox{ model: choices}
                    ProgressBar {
                        progressText: percentComplete
                        endValue:100
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.currentValue = (parent.currentValue + 1) % 100 }}
                    }
                    ProgressBar { }
                }
                Column {
                    id:column3
                    spacing: 12
                    anchors.margins: 20
                    property variant bg: "#ffc"
                    property variant fg: "#356"

                    Text{ font.bold:true; text:"Colored:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" ; backgroundColor: column3.bg; textColor: column3.fg}
                    LineEdit { backgroundColor: column3.bg; textColor: column3.fg}
                    SpinBox{ backgroundColor: column3.bg; textColor: column3.fg}
                    Slider { value: 50; backgroundColor: column3.bg; progressColor: "blue";}
                    Switch { backgroundColor: column3.bg; textColor: column3.fg}
                    Row{
                        CheckBox { backgroundColor: column3.bg; }
                        CheckBox { checked:true; backgroundColor: column3.bg; }
                        RadioButton{ backgroundColor: column3.bg; }
                        RadioButton { checked:true; backgroundColor: column3.bg; }
                        spacing:6
                    }
                    ComboBox{ model: choices; backgroundColor: column3.bg; textColor: column3.fg}
                    ProgressBar {
                        progressText: percentComplete
                        endValue:100
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.currentValue = (parent.currentValue + 1) % 100 }}
                    }
                    ProgressBar{ }
                }
                Column {
                    id:column4
                    spacing: 12
                    anchors.margins: 20

                    Text{ font.bold:true; text:"Custom:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" ; background: shinyButton}
                    LineEdit { background: shinyEdit}
                    SpinBox{
                        background: shinyEdit
                        leftMargin: 40
                        rightMargin: 40
                        up: BorderImage {
                            width:height;
                            source:upPressed ?
                                    "images/shinybutton_pressed.png" :
                                    "images/shinybutton_normal.png"
                            anchors.left:parent.left
                            anchors.top:parent.top
                            anchors.bottom:parent.bottom
                            border.left:6; border.right:6; border.top:6; border.bottom:6
                            Text{ text:"+" ; anchors.centerIn:parent}
                        }
                        down: BorderImage{
                            width:height;
                            source:downPressed ?
                                    "images/shinybutton_pressed.png" :
                                    "images/shinybutton_normal.png"
                            anchors.right:parent.right
                            anchors.top:parent.top
                            anchors.bottom:parent.bottom
                            border.left:6; border.right:6; border.top:6; border.bottom:6
                            Text{ text:"-" ; anchors.centerIn:parent}
                        }
                    }
                    Slider {
                        handle: BorderImage{source:"images/shinybutton_normal.png";
                            width:40; height:30
                            border.left:7; border.right: 7; border.top:7; border.bottom:7
                        }
                        groove: Item {
                            anchors.fill:parent
                            BorderImage {
                                source: "images/shinyedit_normal.png"
                                width: parent.width;
                                height:14; smooth:true
                                border.left: 6; border.right: 6
                            }
                        }
                    }
                    Switch {
                        id:aa
                        groove: shinyEdit;
                        handle: BorderImage {
                            width:aa.height
                            height:aa.height
                            source: parent.pressed ? "images/shinybutton_pressed.png":"images/shinybutton_normal.png"
                            border.left: 6; border.top: 6
                            border.right: 6; border.bottom: 6
                        }

                    }
                    Row{
                        CheckBox { background: shinyEdit} CheckBox { background: shinyEdit; checked:true}
                        RadioButton{ background: shinyEdit} RadioButton { background: shinyEdit; checked:true}
                        spacing:6
                    }

                    ComboBox{ model: choices; background: shinyButton; popupFrame: shinyButton}

                    ProgressBar {
                        progressText: percentComplete
                        endValue:100
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.currentValue = (parent.currentValue + 1) % 100 }}
                        content: BorderImage {
                            source: "images/shinybutton_normal.png"
                            width: parent.width * percentComplete/100.0;
                            height: 20
                            border.top:4 ; border.left:4 ; border.bottom:4 ; border.right:4
                        }
                    }

                    ProgressBar {
                        progressText: currentValue
                        content: BorderImage {
                            source: "images/shinybutton_normal.png"
                            width: parent.width*parent.percentComplete/100.0;
                            border.top:4 ; border.left:4 ; border.bottom:4 ; border.right:4
                        }
                    }
                }
            }
            Component{
                id:shinyButton
                BorderImage {
                    source: parent.pressed ? "images/shinybutton_pressed.png":"images/shinybutton_normal.png"
                    anchors.fill:parent
                    border.left: 6; border.top: 6
                    border.right: 6; border.bottom: 6
                }
            }
            Component{
                id:shinyEdit
                BorderImage {
                    source: "images/shinyedit_normal.png"
                    anchors.fill:parent
                    border.left: 6; border.top: 6
                    border.right: 6; border.bottom: 6
                }
            }

            gradient: Gradient{ GradientStop{ position:0 ; color:"#aaa"} GradientStop{ position:1 ; color:"#eee"}}
        }
    }

    ScrollBar {
        scrollItem: flickable
    }
}
