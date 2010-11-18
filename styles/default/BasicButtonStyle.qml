import Qt 4.7

QtObject {
    property Component background: defaultBackground
    property Component content: defaultContent

    property int preferredWidth: 40
    property int preferredHeight: 25

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
