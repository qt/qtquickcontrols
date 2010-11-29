import Qt 4.7

Rectangle {
    id: block
    width: grid.width+20
    height: grid.height+20
    color: "blue"

    signal clicked(int index)
    property alias model: repeater.model
    property alias columns: grid.columns

    property Component buttonTemplate: Button { checkable: true; adjoins: parent.adjoins }
    //    property Component customStyle: null
    //    property list<Item> selected
    //    property variant selected: new Array();

    Grid {
        id: grid
        columns: 1000
        anchors.centerIn: parent
        Repeater {
            id: repeater
            delegate: Loader {
                property int adjoins: foo(repeater.count)
                function foo(count) {   //mm why do we need a named functon here?
                    var adjoins = 0x0;
                    if(index%columns != 0)      // not first in row
                        adjoins |= 0x1;         // dock left

                    if(index%columns != Math.min(columns, count)-1 // not last in row
                       && index != count-1)     // nor dead last
                        adjoins |= 0x2;         // dock right

                    if(index >= columns)        // not in the first row
                        adjoins |= 0x4;         // dock up

                    if(index < count-columns)   // not in the last row
                        adjoins |= 0x8;         // dock down

                    return adjoins;
                }

                sourceComponent: buttonTemplate
                onLoaded: {
// if(customStyle != null) { item.background = customStyle.background; item.content = customStyle.content }
                    if(model.text) item.text = model.text;
                    if(model.icon) item.icon = model.icon;
                    if(model.enabled) item.enabled = model.enabled;
                    if(model.checkable) item.checkable = model.checkable;
                }
                Connections {
                    target:  item
                    onClicked: { print("Clicked " + index); block.clicked(index) }
                }
            }
        }
    }
}
