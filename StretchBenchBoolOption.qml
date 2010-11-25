import Qt 4.7

Item {
    id: name

    property alias text: optionText.text
    property alias checked: optionCheckBox.checked

    anchors.left: parent.left
    anchors.right: parent.right
    height: row.height

    Item { id: row
        clip: true
        width: parent.width
        height: Math.max(optionText.height, optionCheckBox.height)
        Text { id: optionText; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter }
        CheckBox { id: optionCheckBox; anchors.right: parent.right }
    }
}
