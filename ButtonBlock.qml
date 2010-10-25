import Qt 4.7

Rectangle {
    id: block
    width: grid.width+20
    height: grid.height+20
    color: "blue"

    signal clicked
    property alias model: repeater.model
    property Component buttonTemplate: Button { checkable: true }
//    property Component customStyle: null
//    property list<Item> selected
//    property variant selected: new Array();

    Grid {
        id: grid
        columns: 3
        anchors.centerIn: parent
        Repeater {
            id: repeater
            delegate: Loader {
                sourceComponent: buttonTemplate
                onLoaded: {
//                    if(customStyle != null) { item.background = customStyle.background; item.content = customStyle.content }
                    if(model.text) item.text = model.text
                    if(model.icon) item.icon = model.icon
                    if(model.enabled) item.enabled = model.enabled
                    if(model.checkable) item.checkable = model.checkable
                }
                Connections {
                    target:  item
                    onClicked: { print("Clicked " + index); block.clicked(index) }
//                    onCheckedChanged: { selected.push(item); print(selected.length) }
                }
            }
        }
    }
}
