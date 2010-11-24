import Qt 4.7

Rectangle {
    width: 4*240
    height: 440
    property int rowspacing: 8
    property int columnspacing: 12

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
                spacing: rowspacing
                Column {
                    spacing: columnspacing
                    anchors.margins: 20

                    Text{ font.bold:true; text:"Default:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" }
                    LineEdit { }
                    TextBox { userPrompt:"This is a\n multiline control."}
                    SpinBox{ }
                    Slider { value: 50 }
                    Switch { }
                    Row{
                        CheckBox { } CheckBox { checked:true}
                        RadioButton{ } RadioButton { checked:true}
                        spacing: rowspacing
                    }
                    ComboBox{ model: choices}
                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                    }
                    ProgressBar { indeterminate:true }
                    Row{
                        spacing:rowspacing
                        BusyIndicator{}
                        BusyIndicator{running:false}
                    }
                }
                Column {
                    enabled:false
                    spacing: columnspacing
                    anchors.margins: 20
                    Text{ font.bold:true; text:"Disabled:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me"}
                    LineEdit { }
                    TextBox { text:"This is a\n multiline control."}
                    SpinBox{ }
                    Slider { value: 50 }
                    Switch { }
                    Row{
                        CheckBox { } CheckBox { checked:true}
                        RadioButton{ } RadioButton { checked:true}
                        spacing:rowspacing
                    }
                    ComboBox{ model: choices}
                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                    }
                    ProgressBar { indeterminate:true }
                    Row{
                        spacing:rowspacing
                        BusyIndicator{}
                        BusyIndicator{running:false}
                    }
                }
                Column {
                    id:column3
                    spacing: columnspacing
                    anchors.margins: 20
                    property variant bg: "#ffc"
                    property variant fg: "#356"

                    Text{ font.bold:true; text:"Colored:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" ; backgroundColor: column3.bg; textColor: column3.fg}
                    LineEdit { backgroundColor: column3.bg; textColor: column3.fg}
                    TextBox  { text:"This is a\n multiline control."; backgroundColor: column3.bg; textColor: column3.fg}
                    SpinBox{ backgroundColor: column3.bg; textColor: column3.fg}
                    Slider { value: 50; backgroundColor: column3.bg; progressColor: "blue";}
                    Switch { backgroundColor: column3.bg; textColor: column3.fg}
                    Row{
                        CheckBox { backgroundColor: column3.bg; }
                        CheckBox { checked:true; backgroundColor: column3.bg; }
                        RadioButton{ backgroundColor: column3.bg; }
                        RadioButton { checked:true; backgroundColor: column3.bg; }
                        spacing:rowspacing
                    }
                    ComboBox{ model: choices; backgroundColor: column3.bg; textColor: column3.fg}
                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                    }
                    ProgressBar{ indeterminate:true}
                    Row{
                        spacing:rowspacing
                        BusyIndicator{}
                        BusyIndicator{running:false}
                    }

                }
                Column {
                    id:column4
                    spacing: columnspacing
                    anchors.margins: 20

                    Text{ font.bold:true; text:"Custom:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" ; background: shinyButton}
                    LineEdit { background: shinyEdit}
                    TextBox {  text:"This is a\n multiline control."; background: shinyEdit}
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
                        spacing:rowspacing
                    }

                    ComboBox{ model: choices; background: shinyButton; popupFrame: shinyButton}

                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                        content:shinyBar
                    }

                    ProgressBar {
                        indeterminate:true
                        content:shinyBar
                    }
                    Row{
                        spacing:rowspacing
                        BusyIndicator{background:shinySpinner}
                        BusyIndicator{background:shinySpinner; running:false}
                    }
                }
            }
            Component{
                id:shinySpinner
                BorderImage {
                    width:30; height:30
                    source: "images/shinybutton_normal.png"
                    border.top:4 ; border.left:4 ; border.bottom:4 ; border.right:4
                    Timer { running: true; repeat: true; interval: 25; onTriggered: opacity}
                    PropertyAnimation on opacity {
                        running: parent.running;
                        easing.type:Easing.OutSine
                        loops:Animation.Infinite;
                        from:1; to:0; duration:500}
                }
            }
            Component{
                id:shinyBar
                BorderImage {
                    source: "images/shinybutton_normal.png"
                    width: indeterminate ? parent.width :parent.width * (value-minimum)/(maximum-minimum);
                    border.top:4 ; border.left:4 ; border.bottom:4 ; border.right:4
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
