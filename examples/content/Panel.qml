import QtQuick 1.0
import QtDesktop 0.1

Rectangle {
    id:root

    width: 540
    height: 340
    color:"#c3c3c3"
    ScrollArea {
        frame:false
        anchors.fill: parent

        Item {
            width:600
            height:600
            BorderImage {
                id: page
                source: "../images/page.png"
                y:10; x:50
                width: 400; height: 400
                border.left: 12; border.top: 12
                border.right: 12; border.bottom: 12
                Text {
                    id:text
                    anchors.fill: parent
                    anchors.margins: 40
                    text:textfield.text
                }
                Rectangle {
                    border.color: "#444"
                    anchors.centerIn: parent
                    color: Qt.rgba(s1.value, s2.value, s3.value)
                    width: 200
                    height: width
                }

            }

            BorderImage {
                id: sidebar
                source: "../images/panel.png"
                anchors.left: parent.left
                anchors.top: parent.top
                width: show ? 160 : 40
                height:parent.height
                Behavior on width { NumberAnimation { easing.type: Easing.OutSine ; duration: 250 } }
                property bool show: false
                border.left: 0;
                border.right: 26;
                MouseArea {
                    id:mouseArea
                    anchors.fill: parent
                    onClicked: sidebar.show = !sidebar.show
                }
                Column {
                    id: panel1
                    opacity: sidebar.show ? 1 : 0
                    Behavior on opacity { NumberAnimation { easing.type:Easing.InCubic; duration: 600} }

                    scale: sidebar.show ? 1 : 0
                    Behavior on scale { NumberAnimation { easing.type:Easing.InCubic; duration: 200 } }
                    transformOrigin: Item.Top

                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    spacing:12

                    Button { width: parent.width - 12; text: "Close Panel"; onClicked: sidebar.show = false}
                    TextField{ id:textfield; text: "Some text" ; width: parent.width - 12}
                    SpinBox { width: parent.width - 12}
                    CheckBox{ id: expander; text:"Sliders"}
                }

                Column {
                    id: panel2
                    opacity: expander.checked && sidebar.show ? 1 : 0
                    scale: opacity
                    Behavior on opacity{ NumberAnimation { easing.type:Easing.OutSine; duration: 300}}
                    transformOrigin: Item.Top
                    anchors.top: panel1.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 12
                    spacing: 12
                    Slider { id: s1; width:parent.width - 12; value:0.5}
                    Slider { id: s2; width:parent.width - 12; value:0.5}
                    Slider { id: s3; width:parent.width - 12; value:0.5}

                }
            }
        }
    }
}
