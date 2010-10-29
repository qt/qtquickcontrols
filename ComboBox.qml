import Qt 4.7
import Qt.labs.components 1.0
import "./styles/default" as DefaultStyles

Item {
    id: comboBox

    width: Math.max(100, contentComponent.item.width + 2*10)
    height: Math.max(32, contentComponent.item.height + 2*4)

//    clip: true

    property alias model: popOut.model
    property int currentIndex: 0
    property string currentText
    property int popoutSizeInItems: 5

    property bool pressed: false
    property alias hover: mouseArea.containsMouse

    property Component background: defaultStyle.background
    property Component content: defaultStyle.content
    property Component listItem: defaultStyle.listItem
    property Component listHighlight: defaultStyle.listHighligth
    DefaultStyles.ComboBoxStyle { id: defaultStyle }

    property color backgroundColor: "#fff"
    property color foregroundColor: "#333"

//    property alias font: fontcontainer.font
//    Text { id: fontcontainer; font.pixelSize: 14 } // Workaround since font is not a declarable type (bug?)

    Loader { // background
        anchors.fill: parent
        sourceComponent: comboBox.background
    }

    Loader { // content
        id: contentComponent
        anchors.centerIn: parent
        sourceComponent: comboBox.content
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: { comboBox.pressed = true; popOut.opacity = popOut.opacity ? 0 : 1; }
        onReleased: comboBox.pressed = false
    }

//    Rectangle { color: "red"; anchors.fill: parent; z: 1000 }
    ListView {  //mm load it dynamiacally?
        id: popOut
        opacity: 0
        width: 100
        height: 100
        anchors.top: comboBox.bottom

        clip: true
        boundsBehavior: "StopAtBounds"
        keyNavigationWraps: true

        delegate: comboBox.listItem
        highlight: comboBox.listHighlight
        currentIndex: comboBox.currentIndex
        highlightFollowsCurrentItem: true

        focus: true
        Keys.onPressed: {
            if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                comboBox.currentIndex = index;
            } else if (event.key == Qt.Key_Escape) {
                popOut.opacity = 0;
            }
        }
    }
}
