import QtQuick 1.0
import "./styles/default" as DefaultStyles
import "./private" as Private //  for ChoiceListPopup

// KNOWN ISSUES
// 1) Keyboard navigation in the popout does not work in Gallery (but does work in StretchBench)
// 2) Popout list does not have a scrollbar/scroll indicator or similar
// 3) The ChoiceListPopup should be dynamically loaded, to support radically different implementations
// 4) Mouse wheel scroll events not handled by the popout ListView (see QTBUG-7369)

Item {
    id: choiceList

    property alias model: popup.model
    property int currentIndex: popup.currentIndex

    property alias containsMouse: mouseArea.containsMouse   //mm needed?
    property bool pressed: false    //mm needed?

    property color textColor: syspal.text
    property color backgroundColor: syspal.button

    property Component background: defaultStyle.background
    property Component label: defaultStyle.label
    property Component listItem: defaultStyle.listItem
    property Component listHighlight: defaultStyle.listHighlight
    property Component popupFrame: defaultStyle.popupFrame

    property int minimumWidth: defaultStyle.minimumWidth
    property int minimumHeight: defaultStyle.minimumHeight

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: Math.max(minimumWidth,
                    labelComponent.item.width + leftMargin + rightMargin)
    height: Math.max(minimumHeight,
                     labelComponent.item.height + topMargin + bottomMargin)

    // Implementation

    SystemPalette { id: syspal }
    Loader {
        property alias styledItem: choiceList
        sourceComponent: background
        anchors.fill: parent
    }

    Loader {
        id: labelComponent
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
        drag.target: Item {}    // disable dragging in case ChoiceList is on a Flickable
        onPressed: {
            choiceList.pressed = true;
            popup.togglePopup();

        }
        onReleased: choiceList.pressed = false
        onCanceled: choiceList.pressed = false    // mouse stolen e.g. by Flickable
    }

    Private.ChoiceListPopup {
        id: popup
        listItem: choiceList.listItem
        listHighlight: choiceList.listHighlight
        popupFrame: choiceList.popupFrame
    }

    DefaultStyles.ChoiceListStyle { id: defaultStyle }
}




