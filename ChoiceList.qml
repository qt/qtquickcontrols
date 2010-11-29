import Qt 4.7
import "./styles/default" as DefaultStyles

Item {
    id: choiceList

    property alias model: popupList.model
    property alias containsMouse: mouseArea.containsMouse   //mm needed?

    property Component background: defaultStyle.background
    property Component label: defaultStyle.label
    property Component hints: defaultStyle.hints
    property Component listItem: defaultStyle.listItem
    property Component listHighlight: defaultStyle.listHighlight
    property Component popupFrame: defaultStyle.popupFrame

    property color textColor: hintsLoader.item ? hintsLoader.item.textColor : "black"
    property color backgroundColor: hintsLoader.item ? hintsLoader.item.backgroundColor : "white"

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    // Common API // Note: these are not yet agreed upon
    property bool pressed: false    //mm needed?
    property int currentIndex: 0 // currently called current
    property alias delegate:popupList.delegate // j - labeldelegate?
                                               // Should it be wrapped by the platform

    width: Math.max(minimumWidth,
                    labelComponent.item.width + leftMargin + rightMargin)
    height: Math.max(minimumHeight,
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
            choiceList.pressed = true; popupFrameLoader.item.opacity = popupFrameLoader.item.opacity ? 0 : 1;

            // Since the popup is not a child of ChoiceList
            // we have to recalculate the position to global coordinates
            var point = popupHelper.mapFromItem(choiceList, 0, labelComponent.item.y)
            popupList.y = point.y - popupList.currentItem.y
            popupList.x = point.x

        }
        onReleased: choiceList.pressed = false
        onCanceled: choiceList.pressed = false    // mouse stolen e.g. by Flickable
    }



    MouseArea {
        id:popupHelper
        // There is no global toplevel so we have to make one
        // We essentially reparent this item to the root item

        opacity:popupFrameLoader.item.opacity
        anchors.fill:parent

        Component.onCompleted: {
            var p = parent;
            while (p.parent != undefined)
                p = p.parent
            parent = p;
        }

        onClicked: popupFrameLoader.item.opacity = 0

        Loader {
            id:popupFrameLoader

            anchors.fill:popupList
            anchors.leftMargin: popupFrame.leftMargin != undefined ? popupFrame.leftMargin : -6
            anchors.rightMargin: popupFrame.rigthMargin != undefined ? popupFrame.rigthMargin : -6
            anchors.topMargin: popupFrame.topMargin != undefined ? popupFrame.topMargin : -6
            anchors.bottomMargin: popupFrame.bottomMargin != undefined ? popupFrame.bottomMargin : -6
            sourceComponent: popupFrame

            onLoaded: { item.opacity=0 }
        }

        ListView {
            id: popupList

            height:contentHeight
            // Why is contentWidth evaluated to 0?
            width:Math.max(choiceList.width, contentWidth)

            opacity:popupFrameLoader.item.opacity

            boundsBehavior: "StopAtBounds"
            keyNavigationWraps: true

            delegate: Item {
                id: itemDelegate
                width: delegateLoader.item.width
                height: delegateLoader.item.height
                property int theIndex: index    // for some reason the loader can't bind directly to the "index"
                Loader {
                    id: delegateLoader
                    property alias index: itemDelegate.theIndex //mm Somehow the "model" gets through automagically, but not index
                    property Item styledItem: choiceList
                    sourceComponent: listItem
                    MouseArea {
                        anchors.fill: parent
                        onClicked: { currentIndex = index; popupFrameLoader.item.opacity = 0; }
                    }
                }
            }

            highlight: choiceList.listHighlight
            currentIndex: choiceList.currentIndex
            highlightFollowsCurrentItem: true

            focus: true
            Keys.onPressed: {
                if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                    choiceList.currentIndex = index;
                } else if (event.key == Qt.Key_Escape) {
                    popupFrameLoader.item.opacity = 0;
                }
            }
        }
        DefaultStyles.ChoiceListStyle{ id: defaultStyle }
    }
}
