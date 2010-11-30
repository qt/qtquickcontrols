import Qt 4.7

Item {
    id: buttonBlock

    property alias model: repeater.model
    property Component delegate: Button { adjoins: parent.adjoins; }

    property int orientation: Qt.Horizontal
    signal clicked(int index)

    signal connectProperties(variant model, variant item)
    onConnectProperties: {  //mm need QTBUG-14964 for this?
        if(model.text) item.text = model.text;
        if(model.iconSource) item.iconSource = model.iconSource;
        if(model.enabled) item.enabled = model.enabled;
        if(model.checkable) item.checkable = model.checkable;
    }

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
            delegate: Loader {
                property int adjoins: foo(repeater.count)
                function foo(count) {   //mm why do we need a named functon here?
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

                sourceComponent: delegate
                width: orientation == Qt.Vertical ? grid.widestItemWidth : item.width
                height: orientation == Qt.Vertical ? item.height : grid.talestItemHeight

                onLoaded: {
                    connectProperties(model, item);

                    if(buttonBlock.orientation == Qt.Vertical)    //mm Can't make this work without QTBUG-14957
                        grid.widestItemWidth = Math.max(grid.widestItemWidth, item.width);
                    else
                        grid.talestItemHeight = Math.max(grid.talestItemHeight, item.height);
                }
                Connections {
                    target:  item
                    onClicked: { print("Clicked " + index); buttonBlock.clicked(index) }
                }
            }
        }
    }
}
