import Qt 4.7
import "./styles/default" as DefaultStyles
import Qt.labs.components 1.0    // ImplicitlySizedItem. See QTBUG-14957

Item {
    id: comboBox

    property alias model: popOut.model
    property int currentIndex: 0
    //mm unused    property string currentText
    property int popoutSizeInItems: 5

    //mm needed?    signal clicked
    property bool pressed: false    //mm needed?
    property alias containsMouse: mouseArea.containsMouse   //mm needed?

    property Component background: defaultStyle.background
    property Component label: defaultStyle.label
    property Component hints: defaultStyle.hints
    property Component listItem: defaultStyle.listItem
    property Component listHighlight: defaultStyle.listHighlight

    property color textColor: hintsLoader.item ? hintsLoader.item.textColor : "black"
    property color backgroundColor: hintsLoader.item ? hintsLoader.item.backgroundColor : "white"

    property int preferredWidth: defaultStyle.preferredWidth
    property int preferredHeight: defaultStyle.preferredHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(preferredWidth,
                    labelComponent.item.width + leftMargin + rightMargin)
    height: Math.max(preferredHeight,
                     labelComponent.item.height + topMargin + bottomMargin)

    Loader { id: hintsLoader; sourceComponent: hints }

    Loader {
        sourceComponent: background
        anchors.fill:parent
    }

    Loader {
        id:labelComponent
        anchors.fill: parent
        anchors.leftMargin: leftMargin
        anchors.rightMargin: rightMargin
        anchors.topMargin: topMargin
        anchors.bottomMargin: bottomMargin
        sourceComponent: label
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: { comboBox.pressed = true; popOut.opacity = popOut.opacity ? 0 : 1; }
        onReleased: comboBox.pressed = false
    }

    //    Rectangle { color: "red"; anchors.fill: parent; z: 1000 }

    // List should be real popout, see QTBUG-15000 and QTBUG-15001
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
    DefaultStyles.ComboBoxStyle{ id: defaultStyle }
}
