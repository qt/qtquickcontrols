import Qt 4.7
import "../../../components" as Components

Components.CheckBox{
    // Should size depend on contents, or should contents depend on size?

    background: BorderImage {
        source: checked ? "image://theme/meegotouch-button-checkbox-background-selected":
                pressed ? "image://theme/meegotouch-button-checkbox-background-pressed":
                          "image://theme/meegotouch-button-checkbox-background"
        border.top: 12
        border.bottom: 12
        border.left: 12
        border.right: 12
    }
    checkmark: Item{} // Drawn as part of the background
}

