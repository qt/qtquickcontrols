import Qt 4.7

Rectangle {
    width: 4*240
    height: 580
    property int rowspacing: 24
    property int columnspacing: 14
    gradient: Gradient{ GradientStop{ position:1 ; color:"#bbb"} GradientStop{ position:0 ; color:"#ccc"}}

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: parent.height*2
        Item {
            anchors.top:parent.top
            anchors.left:parent.left
            anchors.leftMargin:20
            anchors.rightMargin:20

            ListModel {
                id: choices
                ListElement { content: "Banana" }
                ListElement { content: "Orange" }
                ListElement { content: "Apple" }
                ListElement { content: "Coconut" }
            }
            Row {
                anchors.fill: parent
                spacing: rowspacing
                Column {
                    anchors.top: parent.top
                    spacing: columnspacing
                    anchors.topMargin:6
                    Text{ font.bold:true; text:"Default:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" }
                    ButtonBlock {
                        model: ListModel {
                            ListElement { text: "A" }
                            ListElement { text: "B" }
                        }
                    }
                    LineEdit { }
                    MultiLineEdit { placeholderText:"This is a\n multiline control."}
                    SpinBox{ }
                    Slider { value: 50 }
                    Row{
                        spacing:rowspacing
                        anchors.horizontalCenter:parent.horizontalCenter
                        Switch { }
                        Switch { checked: true }
                    }
                    Row{
                        CheckBox { } CheckBox { checked:true}
                        RadioButton{ } RadioButton { checked:true}
                        spacing: rowspacing
                    }
                    ChoiceList{ model: choices}
                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                    }
                    ProgressBar { indeterminate:true }
                    Row{
                        spacing:rowspacing
                        anchors.horizontalCenter:parent.horizontalCenter
                        BusyIndicator{}
                        BusyIndicator{running:false}
                    }
                }
                Column {
                    anchors.top:parent.top
                    enabled:false
                    spacing: columnspacing
                    anchors.topMargin:6
                    Text{ font.bold:true; text:"Disabled:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me"}
                    ButtonBlock {
                        model: ListModel {
                            ListElement { text: "A" }
                            ListElement { text: "B" }
                        }
                    }
                    LineEdit { }
                    MultiLineEdit { placeholderText:"This is a\n multiline control."}
                    SpinBox{ }
                    Slider { value: 50 }
                    Row{
                        spacing:rowspacing
                        anchors.horizontalCenter:parent.horizontalCenter
                        Switch { }
                        Switch { checked: true }
                    }
                    Row{
                        CheckBox { } CheckBox { checked:true}
                        RadioButton{ } RadioButton { checked:true}
                        spacing:rowspacing
                    }
                    ChoiceList{ model: choices}
                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                    }
                    ProgressBar { indeterminate:true }
                    Row{
                        spacing:rowspacing
                        anchors.horizontalCenter:parent.horizontalCenter
                        BusyIndicator{}
                        BusyIndicator{running:false}
                    }
                }

                Rectangle{
                    width:column3.width+16
                    height:column3.height+16
                    color:"#666"
                    border.color:"#444"

                    Column {
                        x:8
                        id:column3
                        spacing: columnspacing
                        anchors.top:parent.top
                        anchors.topMargin:6
                        property color bg: "#444"
                        property color fg: "#eee"
                        property color pg: "#0f0"

                        Text{ font.bold:true; text:"Colored:" ; styleColor: "#333" ; color:"white" ; style:"Raised"}
                        Button { text:"Push me" ; backgroundColor: column3.bg; textColor: column3.fg}
                        ButtonBlock {
                            delegate: Button{ backgroundColor:column3.bg}
                            model: ListModel {
                                ListElement { text: "A" }
                                ListElement { text: "B" }
                            }
                        }
                        LineEdit { backgroundColor: column3.bg; textColor: column3.fg}
                        MultiLineEdit  { placeholderText:"This is a\n multiline control."; backgroundColor: column3.bg; textColor: column3.fg}
                        SpinBox{ backgroundColor: column3.bg; textColor: column3.fg}
                        Slider { value: 50; backgroundColor: column3.bg; progressColor: column3.pg;}
                        Row{
                            spacing:rowspacing
                            anchors.horizontalCenter:parent.horizontalCenter
                            Switch { backgroundColor: column3.bg; positiveHighlightColor:column3.pg}
                            Switch { backgroundColor: column3.bg; positiveHighlightColor:column3.pg; checked: true }
                        }
                        Row{
                            CheckBox { backgroundColor: checked ? column3.pg : column3.bg; ColorAnimation on backgroundColor {} }
                            CheckBox { checked:true; backgroundColor: checked ? column3.pg : column3.bg; ColorAnimation on backgroundColor {}}
                            RadioButton{ backgroundColor: checked ? column3.pg : column3.bg  ; ColorAnimation on backgroundColor {}}
                            RadioButton { checked:true; backgroundColor: checked ? column3.pg : column3.bg; ColorAnimation on backgroundColor {} }
                            spacing:rowspacing
                        }
                        ChoiceList{ model: choices; backgroundColor: column3.bg; textColor: column3.fg}
                        ProgressBar {
                            backgroundColor: column3.bg;
                            progressColor: column3.pg
                            Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                        }
                        ProgressBar{ indeterminate:true; backgroundColor: column3.bg; progressColor: column3.pg}
                        Row{
                            spacing:rowspacing
                            anchors.horizontalCenter:parent.horizontalCenter
                            BusyIndicator{}
                            BusyIndicator{running:false}
                        }
                    }
                }
                Column {
                    id:column4
                    spacing: columnspacing
                    anchors.top:parent.top
                    anchors.topMargin:6

                    Item{height:6; width:6}
                    Text{ font.bold:true; text:"Custom:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                    Button { text:"Push me" ; background: shinyButton}
                    ButtonBlock {
                        model: ListModel {
                            ListElement { text: "A" }
                            ListElement { text: "B" }
                        }
                    }
                    LineEdit { background: shinyEdit}
                    MultiLineEdit {  placeholderText:"This is a\n multiline control."; background: shinyEdit}
                    SpinBox{
                        background: shinyEdit
                        leftMargin: 40
                        rightMargin: 40
                        up: BorderImage {
                            width:height;
                            source:pressed ?
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
                            source:pressed ?
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
                    Row{
                        spacing:rowspacing
                        Switch {
                            id:aa
                            groove: shinyEdit;
                            handle: handle
                        }
                        Switch {
                            id:bb
                            groove: shinyEdit;
                            handle: handle
                            checked: true
                        }
                        Component {
                            id:handle
                            BorderImage {
                                width:bb.height
                                height:bb.height
                                source: parent.pressed ? "images/shinybutton_pressed.png":"images/shinybutton_normal.png"
                                border.left: 6; border.top: 6
                                border.right: 6; border.bottom: 6
                            }
                        }
                    }
                    Row{
                        CheckBox { background: shinyEdit} CheckBox { background: shinyEdit; checked:true}
                        RadioButton{ background: shinyEdit} RadioButton { background: shinyEdit; checked:true}
                        spacing:rowspacing
                    }

                    ChoiceList{ model: choices; background: shinyButton; popupFrame: shinyButton}

                    ProgressBar {
                        Timer { running: true; repeat: true; interval: 25; onTriggered: {parent.value = (parent.value + 1) % 100 }}
                        progress: shinyBar
                        background: shinyEdit
                        indeterminateProgress: shinyBar
                    }

                    ProgressBar {
                        indeterminate:true
                        progress: shinyBar
                        indeterminateProgress: shinyBar
                        leftMargin:4
                        rightMargin:4
                        topMargin:4
                        bottomMargin:4
                    }
                    Row{
                        spacing:rowspacing
                        anchors.horizontalCenter:parent.horizontalCenter
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
                    width: indeterminate ? parent.width :parent.width * (value-minimumValue)/(maximumValue-minimumValue);
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
		    width:32; height:32;
                    source: "images/shinyedit_normal.png"
                    anchors.fill:parent
                    border.left: 6; border.top: 6
                    border.right: 6; border.bottom: 6
                }
            }
        }
    }

    ScrollDecorator{
        scrollItem: flickable
    }
}
