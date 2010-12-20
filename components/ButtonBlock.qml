import QtQuick 1.0
import "./behaviors"    // ButtonBehavior
import "./visuals"      // AdjoiningVisual
import "./styles/default" as DefaultStyles

Item {
    id: buttonBlock

    property alias model: repeater.model
    property variant bindings: ["text", "iconSource", "enabled", "opacity"]

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

        Repeater {
            id: repeater
            delegate: AdjoiningVisual {
                id:delegateloader
                styledItem: delegateloader
                styling: buttonBackground

                property alias pressed: behavior.pressed
                property alias containsMouse: behavior.containsMouse
                property alias checkable: behavior.checkable  // button toggles between checked and !checked
                property alias checked: behavior.checked

                property string text
                property variant button: delegateloader
                property url iconSource
                signal clicked

                property int buttonIndex: index    // workaround to give access to button's index below
                Repeater {
                    model: bindings
                    delegate: Item {
                        id: bindingItem
                        property string bindingComponent: 'import QtQuick 1.0;' +
                                'Binding {' +
                                '    target: delegateloader;' +
                                '    property: "' + bindings[index] + '";' +
                                '    value: buttonBlock.model.get(' + buttonIndex + ').' + bindings[index] + ';' +
                                '}'

                        Component.onCompleted: Qt.createQmlObject(bindingComponent, bindingItem)
                    }
                }

                ButtonBehavior {
                    id: behavior
                    anchors.fill: parent
                    onClicked: delegateloader.clicked()
                }

                property int adjoins
                adjoins: {   //mm see QTBUG-14987
                    var count = repeater.count;
                    var adjoins = 0x0;
                    if(index%grid.columns != 0) // not first in row
                        adjoins |= 0x1;         // dock left

                    if(index%grid.columns != Math.min(grid.columns, count)-1 // not last in row
                       && index != count-1)     // nor dead last
                        adjoins |= 0x2;         // dock right

                    if(index >= grid.columns)   // not in the first row
                        adjoins |= 0x4;         // dock up

                    if(index < count-grid.columns) // not in the last row
                        adjoins |= 0x8;         // dock down

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
                    id:labelComponent
                    property variant button: delegateloader
                    anchors.fill: parent
                    anchors.leftMargin: leftMargin
                    anchors.rightMargin: rightMargin
                    anchors.topMargin: topMargin
                    anchors.bottomMargin: bottomMargin
                    sourceComponent: buttonLabel
                    property alias pressed: behavior.pressed
                    property alias containsMouse: behavior.containsMouse
                    property alias checkable: behavior.checkable  // button toggles between checked and !checked
                    property alias checked: behavior.checked
                }

                Component.onCompleted: {
                    if(buttonBlock.orientation == Qt.Vertical)    //mm Can't make this work without QTBUG-14957
                        grid.widestItemWidth = Math.max(grid.widestItemWidth, width);
                    else
                        grid.talestItemHeight = Math.max(grid.talestItemHeight, height);
                }

                Connections {
                    target:  behavior
                    onClicked: buttonBlock.clicked(index)
                }
            }
        }
    }
    SystemPalette{id:syspal; colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled}
    DefaultStyles.ButtonBlockStyle{ id: defaultStyle }
}
