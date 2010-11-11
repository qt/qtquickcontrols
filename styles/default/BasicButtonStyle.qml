import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultContent

    property int minimumWidth: 40
    property int minimumHeight: 25

    property list<Component> elements: [
        Component {
            id: defaultBackground
            Item {
            }
        },
        Component {
            id: defaultContent
            Item {
            }
        }
    ]
}
