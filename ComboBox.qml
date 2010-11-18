import Qt 4.7
import "./styles/default" as DefaultStyles
import Qt.labs.components 1.0    // ImplicitlySizedItem. See QTBUG-14957

Item {
    id: comboBox

    property alias model: popupList.model
    property int currentIndex: 0
    //mm unused    property string currentText
    property int popupListSizeInItems: 5

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
        onPressed: {
            comboBox.pressed = true; popupFrame.item.opacity = popupFrame.item.opacity ? 0 : 1;

            // Since the popup is not a child of combobox
            // we have to recalculate the position to global coordinates
            var point = popupHelper.mapFromItem(comboBox, 0, labelComponent.item.y)
            popupList.y = point.y - popupList.currentItem.y
            popupList.x = point.x

        }
        onReleased: comboBox.pressed = false
    }



    MouseArea {
        id:popupHelper
        // There is no global toplevel so we have to make one
        // We essentially reparent this item to the root item

        opacity:popupFrame.item.opacity
        anchors.fill:parent

        Component.onCompleted: {
            var p = parent;
            while (p.parent != undefined)
                p = p.parent
            parent = p;
        }

        onClicked: popupFrame.item.opacity = 0

        Loader {
            id:popupFrame

            anchors.fill:popupList
            anchors.leftMargin: defaultStyle.popupFrame.leftMargin != undefined ? defaultStyle.popupFrame.leftMargin : -6
            anchors.rightMargin: defaultStyle.popupFrame.rigthMargin != undefined ? defaultStyle.popupFrame.rigthMargin : -6
            anchors.topMargin: defaultStyle.popupFrame.topMargin != undefined ? defaultStyle.popupFrame.topMargin : -6
            anchors.bottomMargin: defaultStyle.popupFrame.bottomMargin != undefined ? defaultStyle.popupFrame.bottomMargin : -6
            sourceComponent: defaultStyle.popupFrame

            onLoaded: { item.opacity=0 }
        }

        ListView {
            id: popupList

            height:contentHeight
            // Why is contentWidth evaluated to 0?
            width:Math.max(comboBox.width, contentWidth)

            opacity:popupFrame.item.opacity

            boundsBehavior: "StopAtBounds"
            keyNavigationWraps: true

            delegate: Component {
                // Ensure we handle input and not the delegate
                Loader{
                    sourceComponent:defaultStyle.listItem
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { currentIndex = index; popupFrame.item.opacity = 0; }
                    }
                }
            }

            highlight: comboBox.listHighlight
            currentIndex: comboBox.currentIndex
            highlightFollowsCurrentItem: true

            focus: true
            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                    comboBox.currentIndex = index;
                } else if (event.key == Qt.Key_Escape) {
                    popupFrame.item.opacity = 0;
                }
            }
        }
        DefaultStyles.ComboBoxStyle{ id: defaultStyle }
    }
}
