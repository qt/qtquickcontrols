import QtQuick 1.0
import "./behaviors"    // ButtonBehavior
import "./visuals"      // AdjoiningVisual
import "./styles/default" as DefaultStyles

// KNOWN ISSUES
// 1) When switching between horizontal and vertical orientation after block has been created, the Grid's move
//    transition is called *before* the grid item's have actually moved, resulting in incorrect "adjoins" states
// 2) Can't make items in vertical groups all the same width without access to their implicitWidth, see QTBUG-14957
// 3) Should be generalized into JoinedGroup and ButtonBlock made a specialization.
// 4) ExclusiveSelection support missing

// NOTES
// 1) The ButtonBlock implementation has no ultimate dependency on AdjoiningVisual, and can therefor be made to work
//    with any Component for the item instances. The use of AdjoiningVisual is only for simplifying the implementation
//    and styling of the items in the block. The property defining how an item in the block should be joinged with its
//    neighbours is "adjoins" which the ButtonBlock "attaches" to the items in the block (i.e. defines in their
//    look-up scope) which means the "button" instances does not need to define this property, only read it to draw
//    their border appropriately. This "adjoins" property is a *completely* separate concept from the AdjoiningVisual.
//    I.e. the coupling between the ButtonGroup and the "button" elements making up the group is the weakest possible.


Item {
    id: buttonBlock

    property alias model: repeater.model
    property variant bindings: {"text":"text", "iconSource":"iconSource", "enabled":"enabled", "opacity":"opacity"}

    property Component buttonBackground: defaultStyle.background
    property Component buttonLabel: defaultStyle.label

    property color backgroundColor: syspal.button
    property color textColor: syspal.text;

    property int orientation: Qt.Horizontal
    signal clicked(int index)

    property int leftMargin: defaultStyle.leftMargin
    property int topMargin: defaultStyle.topMargin
    property int rightMargin: defaultStyle.rightMargin
    property int bottomMargin: defaultStyle.bottomMargin

    width: grid.width
    height: grid.height

    Grid {
        id: grid
        columns: orientation == Qt.Vertical ? 1 : model.count
        anchors.centerIn: parent
        property int widestItemWidth: 0
        property int talestItemHeight: 0

        move: Transition {  //mm seems "move" transition is not always called after items has been moved
            ScriptAction { script: {
                    if(orientation == Qt.Horizontal) {
                        grid.leftmostVisibleIndex = grid.__leftmostVisibleIndex();
                        grid.rightmostVisibleIndex = grid.__rightmostVisibleIndex();
                    } else {
                        grid.topmostVisibleIndex = grid.__topmostVisibleIndex();
                        grid.bottommostVisibleIndex = grid.__bottommostVisibleIndex();
                    }
                }
            }
        }

        property int leftmostVisibleIndex
        function __leftmostVisibleIndex() {
            var leftmostVisibleIndex = 0;
            var leftmostItemX = 10000000;
            for(var i = 0; i < children.length; i++) {
                var child = children[i];
                if(child.x < leftmostItemX && child.opacity > 0) {
                    leftmostItemX = child.x;
                    leftmostVisibleIndex = i;
                }
            }
            return leftmostVisibleIndex;
        }

        property int rightmostVisibleIndex
        function __rightmostVisibleIndex() {
            var rightmostVisibleIndex = 0;
            var rightmostItemX = 0;
            for(var i = 0; i < children.length; i++) {
                var child = children[i];
//mm                print("rightmost child? at: " + child.x + "," + child.y)
                if(child.x > rightmostItemX && child.opacity > 0) {
                    rightmostItemX = child.x;
                    rightmostVisibleIndex = i;
                }
            }
            return rightmostVisibleIndex;
        }

        property int topmostVisibleIndex
        function __topmostVisibleIndex() {
            var topmostVisibleIndex = 0;
            var topmostItemY = 10000000;
            for(var i = 0; i < children.length; i++) {
                var child = children[i];
                if(child.y < topmostItemY && child.opacity > 0) {
                    topmostItemY = child.y;
                    topmostVisibleIndex = i;
                }
            }
            return topmostVisibleIndex;
        }

        property int bottommostVisibleIndex
        function __bottommostVisibleIndex() {
            var bottommostVisibleIndex = 0;
            var bottommostItemY = 0;
            for(var i = 0; i < children.length; i++) {
                var child = children[i];
//mm                print("bottommost child? at: " + child.x + "," + child.y)
                if(child.y > bottommostItemY && child.opacity > 0) {
                    bottommostItemY = child.y;
                    bottommostVisibleIndex = i;
                }
            }
            return bottommostVisibleIndex;
        }

        Repeater {
            id: repeater
            delegate: AdjoiningVisual {
                id: blockButton
                styledItem: blockButton
                styling: buttonBackground

                property alias pressed: behavior.pressed
                property alias containsMouse: behavior.containsMouse
                property alias checkable: behavior.checkable  // button toggles between checked and !checked
                property alias checked: behavior.checked

                property string text
                property url iconSource
                property color textColor: buttonBlock.textColor
                property color backgroundColor: buttonBlock.backgroundColor

                Component.onCompleted: {
                    // Create the Binding objects defined by the ButtonBlock's "bindings" map property to allow
                    // the properties of the buttons to be bound to properties in the model with different names
                    var keys = Object.keys(bindings);
                    for(var i = 0; i < keys.length; i++) {
                        var key = keys[i];
                        var bindingComponent =
                                'import QtQuick 1.0;' +
                                'Binding {' +
                                '    target: blockButton;' +
                                '    property: "' + key + '";' +
                                '    value: buttonBlock.model.get(' + index + ').' + bindings[key] + ';' +
                                '}';
                        Qt.createQmlObject(bindingComponent, blockButton);    //mm do we ever need to explicitly delete these?
                    }

                    // Find the widest/talest item to make all buttons the same width/height
                    if(buttonBlock.orientation == Qt.Vertical)    //mm Can't make this work without QTBUG-14957
                        grid.widestItemWidth = Math.max(grid.widestItemWidth, width);
                    else
                        grid.talestItemHeight = Math.max(grid.talestItemHeight, height);
                }

                ButtonBehavior {
                    id: behavior
                    anchors.fill: parent
                    onClicked: buttonBlock.clicked(index)
                }

                property int adjoins
                adjoins: {   //mm see QTBUG-14987
                    var adjoins;
                    if(orientation == Qt.Horizontal) {
                        adjoins = 0x1|0x2;  // left and right
                        if(index == grid.leftmostVisibleIndex) adjoins &= ~0x1;   // not left
                        if(index == grid.rightmostVisibleIndex) adjoins &= ~0x2;  // not right
                    } else {
                        adjoins = 0x4|0x8;  // top and bottom
                        if(index == grid.topmostVisibleIndex) adjoins &= ~0x4;    // not top
                        if(index == grid.bottommostVisibleIndex) adjoins &= ~0x8; // not bottom
                    }
                    return adjoins;
                }


               // width: orientation == Qt.Vertical ? grid.widestItemWidth : item.width
               // height: orientation == Qt.Vertical ? item.height : grid.talestItemHeight
                property int minimumWidth: defaultStyle.minimumWidth
                property int minimumHeight: defaultStyle.minimumHeight

                width: Math.max(minimumWidth,
                                labelComponent.item.width + leftMargin + rightMargin)
                height: Math.max(minimumHeight,
                                 labelComponent.item.height + topMargin + bottomMargin)

                Loader {
                    id: labelComponent
                    property variant styledItem: blockButton
                    anchors.fill: parent
                    anchors.leftMargin: leftMargin
                    anchors.rightMargin: rightMargin
                    anchors.topMargin: topMargin
                    anchors.bottomMargin: bottomMargin
                    sourceComponent: buttonLabel
                }

            }
        }
    }

    SystemPalette { id: syspal; colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled }
    DefaultStyles.ButtonBlockStyle { id: defaultStyle }
}
