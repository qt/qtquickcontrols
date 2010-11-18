import Qt 4.7

Rectangle {
    width: 4*240
    height: 400

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
                    CheckBox { }
                    ComboBox{ model: choices}
                    ProgressBar {
                        startValue: 250; endValue: 1000;
                        progressText: currentValue
                        Timer { running: true; repeat: true; interval: 25; onTriggered: parent.percentComplete == 100 ? parent.percentComplete = 0 : parent.percentComplete++}
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
                    CheckBox { }
                    ComboBox{ model: choices}
                    ProgressBar {
                        startValue: 250; endValue: 1000;
                        progressText: currentValue
                        Timer { running: true; repeat: true; interval: 25; onTriggered: parent.percentComplete == 100 ? parent.percentComplete = 0 : parent.percentComplete++}
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
                    CheckBox { backgroundColor: column3.bg; textColor: column3.fg}
                    ComboBox{ model: choices; backgroundColor: column3.bg; textColor: column3.fg}
                    ProgressBar {
                        startValue: 250; endValue: 1000;
                        progressText: currentValue
                        Timer { running: true; repeat: true; interval: 25; onTriggered: parent.percentComplete == 100 ? parent.percentComplete = 0 : parent.percentComplete++}
                    }
                    ProgressBar{}
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
                        leftMargin: 32
                        up: Button {
                            width:height;
                            anchors.left:parent.left
                            anchors.top:parent.top
                            anchors.bottom:parent.bottom
                            anchors.margins: 4
                            Text{
                                text:"+"
                                anchors.centerIn: parent
                            }
                        }
                        down: Button {
                            width:height;
                            anchors.right:parent.right
                            anchors.top:parent.top
                            anchors.bottom:parent.bottom
                            anchors.margins: 4
                            Text{
                                text:"-"
                                anchors.centerIn: parent
                            }
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
                    Switch { background: shinyEdit}
                    CheckBox { background: shinyEdit}
                    ComboBox{ model: choices; background: shinyButton; popupFrame: shinyButton}
                    ProgressBar {
                        id:bar
                        startValue: 250; endValue: 1000;
                        progressText: currentValue
                        Timer { running: true; repeat: true; interval: 25; onTriggered: parent.percentComplete == 100 ? parent.percentComplete = 0 : parent.percentComplete++}
                        content: BorderImage {
                            id: name
                            source: "images/shinybutton_normal.png"
                            width: bar.width*bar.percentComplete/100.0;
                            height: 20
                            border.top:4 ; border.left:4 ; border.bottom:4 ; border.right:4
                        }
                    }
                    ProgressBar{
                        id:bar2
                        progressText: currentValue
                        content: BorderImage {
                            source: "images/shinybutton_normal.png"
                            width: bar2.width*bar2.percentComplete/100.0;
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
