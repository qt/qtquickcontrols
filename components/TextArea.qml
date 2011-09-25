import QtQuick 1.1
import "custom" as Components

ScrollArea {
    id:area
    color: "white"
    width: 280
    height: 120
    contentWidth: edit.paintedWidth + (2 * documentMargins)

    property alias text: edit.text
    property alias wrapMode: edit.wrapMode
    property alias readOnly: edit.readOnly
    property bool tabChangesFocus: false
    property alias font: edit.font
    property alias activeFocusOnPress: edit.activeFocusOnPress

    highlightOnFocus: true
    property int documentMargins: 4
    frame: true

    function append (string) {
        text += "\n" + string
        verticalScrollBar.value = verticalScrollBar.maximumValue
    }

    Item {
        anchors.left: parent.left
        anchors.top: parent.top
        height: edit.paintedHeight + area.height - viewportHeight + 2 * documentMargins + 4
        anchors.margins: documentMargins

        TextEdit {
            id: edit
            wrapMode: TextEdit.WordWrap;
            width: area.width
            height: area.height
            selectByMouse: true
            readOnly: false
            color: syspal.text

            SystemPalette {
                id: syspal
                colorGroup: enabled ? SystemPalette.Active : SystemPalette.Disabled
            }

            KeyNavigation.priority: KeyNavigation.BeforeItem
            KeyNavigation.tab: area.tabChangesFocus ? area.KeyNavigation.tab : null
            KeyNavigation.backtab: area.tabChangesFocus ? area.KeyNavigation.backtab : null

            onPaintedSizeChanged: {
                area.contentWidth = paintedWidth + (2 * documentMargins)
            }

            // keep textcursor within scrollarea
            onCursorPositionChanged: {
                if (cursorRectangle.y >= area.contentY + area.viewportHeight - 1.5*cursorRectangle.height - documentMargins)
                    area.contentY = cursorRectangle.y - area.viewportHeight + 1.5*cursorRectangle.height + documentMargins
                else if (cursorRectangle.y < area.contentY)
                    area.contentY = cursorRectangle.y

                if (cursorRectangle.x >= area.contentX + area.viewportWidth - documentMargins) {
                    area.contentX = cursorRectangle.x - area.viewportWidth + documentMargins
                } else if (cursorRectangle.x < area.contentX)
                    area.contentX = cursorRectangle.x
            }
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_PageUp) {
            verticalValue = verticalValue - area.height
        } else if (event.key == Qt.Key_PageDown)
            verticalValue = verticalValue + area.height
    }

    Component.onCompleted: edit.width = area.viewportWidth - (2 * documentMargins)
}
