import QtQuick 1.0
import "../components"

Rectangle {
    SystemPalette{id:syspal}
    width: 4*256
    height: 620
    property string position // jbw: hack for shinybuttonstyle
    property int rowspacing: 24
    property int columnspacing: 14

    gradient: Gradient{ GradientStop{ position:1 ; color:syspal.window}
        GradientStop{ position:0 ; color:Qt.darker(syspal.window, 1.2)}
    }

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
                ListElement { text: "Banana" }
                ListElement { text: "Orange" }
                ListElement { text: "Apple" }
                ListElement { text: "Coconut" }
            }
            Row {
                anchors.fill: parent
                Item {
                    width:column1.width+2*rowspacing
                    height:column1.height+2*rowspacing
                    Column {
                        x:rowspacing
                        id:column1
                        spacing: columnspacing
                        anchors.top:parent.top
                        anchors.topMargin:6

                        Text{ font.bold:true; text:"Default:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                        Button { text:"Push me" }
                        ButtonRow {
                            Button{ text: "A" }
                            Button{ text: "B" }
                        }
                        TextField { }
                        TextArea { placeholderText:"This is a\n multiline control."}
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
                            Timer {
                                running: true
                                repeat: true
                                interval: 25
                                onTriggered: {
                                    var next = parent.value + 0.01;
                                    parent.value = (next > parent.maximumValue) ? parent.minimumValue : next;
                                }
                            }
                        }
                        ProgressBar { indeterminate:true }
                        Row{
                            spacing:rowspacing
                            anchors.horizontalCenter:parent.horizontalCenter
                            BusyIndicator{}
                            BusyIndicator{running:false}
                        }
                    }
                }
                Item {
                    width:column2.width+2*rowspacing
                    height:column2.height+2*rowspacing
                    Column {
                        x:rowspacing
                        id:column2
                        spacing: columnspacing
                        anchors.top:parent.top
                        anchors.topMargin:6

                        Column {
                            enabled:false
                            spacing: columnspacing
                            anchors.topMargin:6
                            Text{ font.bold:true; text:"Disabled:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                            Button { text:"Push me"}
                            ButtonRow {
                                Button{ text: "A" }
                                Button{ text: "B" }
                            }
                            TextField { }
                            TextArea { placeholderText:"This is a\n multiline control."}
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
                                Timer {
                                    running: true
                                    repeat: true
                                    interval: 25
                                    onTriggered: {
                                        var next = parent.value + 0.01;
                                        parent.value = (next > parent.maximumValue) ? parent.minimumValue : next;
                                    }
                                }
                            }
                            ProgressBar { indeterminate:true }
                            Row{
                                spacing:rowspacing
                                anchors.horizontalCenter:parent.horizontalCenter
                                BusyIndicator{}
                                BusyIndicator{running:false}
                            }
                        }
                    }
                }
                Rectangle{
                    width:column3.width+2*rowspacing
                    height:column3.height+2*rowspacing
                    color:"#666"
                    border.color:"#444"
                    Column {
                        x:rowspacing
                        id:column3
                        spacing: columnspacing
                        anchors.top:parent.top
                        anchors.topMargin:6
                        property color bg: "#444"
                        property color fg: "#eee"
                        property color pg: "#f70"

                        Text{ font.bold:true; text:"Colored:" ; styleColor: "#333" ; color:"white" ; style:"Raised"}
                        Button { text:"Push me" ; backgroundColor: column3.bg; textColor: column3.fg}
                        ButtonRow {
                            Button{ text: "A" ; backgroundColor: column3.bg}
                            Button{ text: "B" ; backgroundColor: column3.bg}
                        }
                        TextField { backgroundColor: column3.bg; textColor: column3.fg}
                        TextArea  { placeholderText:"This is a\n multiline control."; backgroundColor: column3.bg; textColor: column3.fg}
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
                            Timer {
                                running: true
                                repeat: true
                                interval: 25
                                onTriggered: {
                                    var next = parent.value + 0.01;
                                    parent.value = (next > parent.maximumValue) ? parent.minimumValue : next;
                                }
                            }
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
                Rectangle{
                    width:column3.width+2*rowspacing
                    height:column3.height+2*rowspacing
                    color:"#ccc"
                    border.color:"#444"
                    Column {
                        x:rowspacing
                        id:column4
                        spacing: columnspacing
                        anchors.top:parent.top
                        anchors.topMargin:6

                        Text{ font.bold:true; text:"Custom:" ; styleColor: "white" ; color:"#333" ; style:"Raised"}
                        Button { text:"Push me" ; background: shinyButton;}
                        ButtonRow {
                            Button { text: "A" ; background:shinyButton}
                            Button{ text: "B" ; background:shinyButton}
                        }
                        TextField { background: shinyEdit}
                        TextArea {  placeholderText:"This is a\n multiline control."; background: shinyEdit}
                        SpinBox{
                            background: shinyEdit
                            leftMargin: 40
                            rightMargin: 40
                            up: BorderImage {
                                width:height;
                                source:pressed ?
                                        "customtheme/exampletheme/images/button_pressed.png" :
                                        "customtheme/exampletheme/images/button_normal.png"
                                anchors.left:parent.left
                                anchors.top:parent.top
                                anchors.bottom:parent.bottom
                                border.left:6; border.right:6; border.top:6; border.bottom:6
                                Text{ text:"+" ; anchors.centerIn:parent}
                            }
                            down: BorderImage{
                                width:height;
                                source:pressed ?
                                        "customtheme/exampletheme/images/button_pressed.png" :
                                        "customtheme/exampletheme/images/button_normal.png"
                                anchors.right:parent.right
                                anchors.top:parent.top
                                anchors.bottom:parent.bottom
                                border.left:6; border.right:6; border.top:6; border.bottom:6
                                Text{ text:"-" ; anchors.centerIn:parent}
                            }
                        }
                        Slider {
                            value: 50
                            height: 20
                            leftMargin:10
                            rightMargin:10
                            handle: BorderImage{source:"customtheme/exampletheme/images/button_normal.png";
                                width:20; height:20
                                border.left:7; border.right: 7; border.top:7; border.bottom:7
                            }
                            groove: Item {
                                anchors.fill:parent
                                BorderImage {
                                    source: "customtheme/exampletheme/images/edit_normal.png"
                                    width: parent.width;
                                    height:20; smooth:true
                                    border.left: 4; border.right: 4
                                    border.top:4; border.bottom:4
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
                                    source: parent.pressed ? "customtheme/exampletheme/images/button_pressed.png":"customtheme/exampletheme/images/button_normal.png"
                                    border.left: 6; border.top: 6
                                    border.right: 6; border.bottom: 6
                                }
                            }
                        }
                        Row {
                            CheckBox { background: shinyCheckBackground; checkmark: shinyCheckMark }
                            CheckBox { background: shinyCheckBackground; checkmark: shinyCheckMark; checked: true}
                            RadioButton { background: shinyCheckBackground; checkmark: shinyCheckMark }
                            RadioButton { background: shinyCheckBackground; checkmark: shinyCheckMark; checked: true}
                            spacing: rowspacing
                        }

                        ChoiceList{ model: choices; background: shinyButton; popupFrame: shinyButton}

                        ProgressBar {
                            Timer {
                                running: true
                                repeat: true
                                interval: 25
                                onTriggered: {
                                    var next = parent.value + 0.01;
                                    parent.value = (next > parent.maximumValue) ? parent.minimumValue : next;
                                }
                            }

                            progress: shinyBar
                            background: shinyEdit
                            indeterminateProgress: shinyBar
                        }

                        ProgressBar {
                            indeterminate:true
                            progress: shinyBar
                            indeterminateProgress: shinyBar
                        }
                        Row{
                            spacing:rowspacing
                            anchors.horizontalCenter:parent.horizontalCenter
                            BusyIndicator{background:shinySpinner}
                            BusyIndicator{background:shinySpinner; running:false}
                        }
                    }
                }
            }
            Component{
                id:shinySpinner
                BorderImage {
                    width:30; height:30
                    source: "customtheme/exampletheme/images/button_normal.png"
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
                    source: "customtheme/exampletheme/images/button_normal.png"
                    visible: styledItem.value > 0
                    border.top:4 ; border.left:4 ; border.bottom:4 ; border.right:4
                }
            }
            Component {
                id: shinyCheckBackground
                BorderImage {
                    width: styledItem.implicitWidth; height: styledItem.implicitHeight
                    source: "customtheme/exampletheme/images/edit_normal.png"
                    border.left: 6; border.top: 6
                    border.right: 6; border.bottom: 6
                }
            }
            Component{
                id: shinyCheckMark
                Image {
                    visible: styledItem.checked || styledItem.pressed ? 1 : 0
                    opacity: !enabled || styledItem.pressed ? 0.7 : 1
                    source: "customtheme/exampletheme/images/checkbox_check.png"
                }
            }
            Component{
                id:shinyButton
                Item {
                    clip:true
                    BorderImage {
                        x:position == "rightmost" ? -2 : 0
                        width:parent.width + (position == "leftmost" ? 5 : 0)
                        height:parent.height
                        source: styledItem.pressed ? "customtheme/exampletheme/images/button_pressed.png":
                                "customtheme/exampletheme/images/button_normal.png"
                        border.left: 6; border.top: 6
                        border.right: 6; border.bottom: 6
                    }
                }
            }
            Component {
                id: shinyEdit
                BorderImage {
                    source: "customtheme/exampletheme/images/edit_normal.png"
                    border.left: 6; border.top: 6
                    border.right: 6; border.bottom: 6
                }
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }
}
