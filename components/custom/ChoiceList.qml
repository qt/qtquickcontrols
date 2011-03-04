import QtQuick 1.0
import "./private" as Private //  for ChoiceListPopup

// KNOWN ISSUES
// 1) Popout list does not have a scrollbar/scroll indicator or similar
// 2) The ChoiceListPopup should ff dynamically loaded, to support radically different implementations
// 3) Mouse wheel scroll events not handled by the popout ListView (see QTBUG-7369)
// 4) Support for configurable bindings between model's and ChoiceList's properties similar to ButtonBlock's is missing

Item {
    id: choiceList

    property alias model: popup.model
    property int currentIndex: popup.currentIndex

    property alias containsMouse: mouseArea.containsMouse   //mm needed?
    property bool pressed: false    //mm needed?

    property Component background: null
    property Component listItem: null
    property Component popupFrame: null

    property int leftMargin: 0
    property int topMargin: 0
    property int rightMargin: 0
    property int bottomMargin: 0

    property string popupBehavior
    width: 0
    height: 0

    property bool activeFocusOnPress: true

    // Implementation

    SystemPalette { id: syspal }
    Loader {
        property alias styledItem: choiceList
        sourceComponent: background
        anchors.fill: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: Item {}    // disable dragging in case ChoiceList is on a Flickable
        onPressed: {
            if (activeFocusOnPress)
                choicelist.focus = true
            choiceList.pressed = true;
            popup.togglePopup();

        }
        onReleased: choiceList.pressed = false
        onCanceled: choiceList.pressed = false    // mouse stolen e.g. by Flickable
    }

    Private.ChoiceListPopup {
        id: popup
        listItem: choiceList.listItem
        popupFrame: choiceList.popupFrame
    }

    Keys.onSpacePressed: { popup.togglePopup() }
    Keys.onUpPressed: { if (currentIndex < model.count - 1) currentIndex++ }
    Keys.onDownPressed: {if (currentIndex > 0) currentIndex-- }
}
