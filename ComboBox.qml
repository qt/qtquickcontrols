import Qt 4.7
import Qt.labs.components 1.0

Item {
    id:combobox

    width: Math.max(100, labelComponent.item.width + 2*10)
    height: Math.max(32, labelComponent.item.height + 2*4)

    clip:true
    signal clicked


    property int elementsToShow: 5;
    property string currentText;
    property alias model: elements.model;
    property alias currentIndex: elements.currentIndex;

    property alias hover: markerArea.containsMouse
    property bool pressed: false

    property Component background : defaultbackground
    property Component content : defaultlabel
    property Component delegate : defaultDelegate
    property Component highlight : defaultHighlight

    property string text
    property string icon

    property color backgroundColor: "#fff";
    property color foregroundColor: "#333";

    property alias font: fontcontainer.font

    Text {id:fontcontainer; font.pixelSize:14} // Workaround since font is not a declarable type (bug?)

    ListView {
        id: elements;
        anchors.fill: parent;

        clip:true;
        boundsBehavior: "StopAtBounds";
        keyNavigationWraps: true;

        delegate: delegate;
        highlight: highlight;
    }


    // background
    Loader {
        id:backgroundComponent
        anchors.fill:parent
        sourceComponent:background
        opacity: enabled ? 1 : 0.8
    }

    // content
    Loader {
        id:labelComponent
        anchors.centerIn: parent
        sourceComponent:content
    }

    onClicked:{
        list.state == "" ? list.state = "shown" : list.state = "";
        elements.currentIndex = list.lastIndex;
    }

    MouseArea {
        id:markerArea
        enabled: combobox.enabled
        hoverEnabled: true
        anchors.fill: parent
        onPressed: {
            combobox.pressed = true
        }
        onEntered: if(pressed && enabled) combobox.pressed = true  // handles clicks as well
        onExited: {
            combobox.pressed = false
        }

        onReleased: {
            if (combobox.pressed && enabled) { // No click if release outside area
                combobox.pressed  = false
                combobox.clicked()
            }
        }
    }

    Component {
        id:defaultbackground
        Item {

            Rectangle{
                color:backgroundColor
                radius: 5
                x:1
                y:1
                width:parent.width-2
                height:parent.height-2
            }

            BorderImage {
                anchors.fill:parent
                id: backgroundimage
                smooth:true
                source: pressed ? "images/button_pressed.png" : "images/button_normal.png"
                width: 80; height: 24
                border.left: 3; border.top: 3
                border.right: 3; border.bottom: 3

                Image{
                    anchors.top:parent.top
                    anchors.right: parent.right
                    anchors.topMargin: 7
                    anchors.rightMargin: 7
                    opacity: enabled ? 1 : 0.3
                    source:"images/spinbox_up.png"
                }
                Image{
                    anchors.bottom:parent.bottom;
                    anchors.right: parent.right
                    anchors.bottomMargin: 7
                    anchors.rightMargin: 7
                    opacity: enabled ? 1 : 0.3
                    source:"images/spinbox_down.png"
                }
            }
        }
    }

    Component {
        id:defaultlabel
        Item {
            width:layout.width
            height:layout.height
            anchors.margins:4
            Row {
                spacing:6
                anchors.centerIn:parent
                id:layout
                Image { source:combobox.icon; anchors.verticalCenter:parent.verticalCenter}
                Text {
                    id:label
                    font:combobox.font
                    color:combobox.foregroundColor;
                    anchors.verticalCenter: parent.verticalCenter ;
                    text:combobox.text
                    opacity:parent.enabled ? 1 : 0.5
                }
            }
        }
    }

    Component {
        id: defaultDelegate
        Item {
            id: wrapper
            width: background.width;
            height: background.height;

            Row {
                x: 5;
                y: 5;
                spacing: 5;
                Text {
                    font.pixelSize: mx.fontSize
                    color: mx.fontColor
                    text: content;
                }
                Image {
                    source: icon;
                    anchors.verticalCenter: parent.verticalCenter;
                    height: wrapper.height - 10;
                }
            }

            function selectItem(index) {
                combobox.current = elements.model.get(index).content;
                list.lastIndex = index;
                list.state = "";
            }

            MouseArea {
                anchors.fill: parent;
                hoverEnabled: true;

                onEntered: {
                    elements.currentIndex = index;
                }
                onClicked: selectItem(index);
            }

            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                    selectItem(index);
                } else if (event.key == Qt.Key_Escape) {
                    list.state = "";
                }
            }
        }
    }

    Component {
        id: defaultHighlight
        Rectangle {
            color: "#cccccc";
            x:1
            width:parent.width-2
        }
    }

    Item {
        id: list;
        property int lastIndex;

        opacity: 0;
        height: Math.min(background.height * elements.count,
                         background.height * combobox.elementsToShow);

        anchors.top: background.bottom;
        anchors.left: background.left;
        anchors.right: background.right;

        Component {
            id: delegate
            Item {
                id: wrapper
                width: background.width;
                height: background.height;

                Row {
                    x: 5;
                    y: 5;
                    spacing: 5;
                    Text {
                        font.pixelSize: mx.fontSize
                        color: mx.fontColor
                        text: content;
                    }
                    Image {
                        source: icon;
                        anchors.verticalCenter: parent.verticalCenter;
                        height: wrapper.height - 10;
                    }
                }

                function selectItem(index) {
                    combobox.current = elements.model.get(index).content;
                    list.lastIndex = index;
                    list.state = "";
                }

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true;

                    onEntered: {
                        elements.currentIndex = index;
                    }
                    onClicked: selectItem(index);
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        selectItem(index);
                    } else if (event.key == Qt.Key_Escape) {
                        list.state = "";
                    }
                }
            }
        }
    }
}
