import QtQuick 1.0
import "custom" as Components
import "plugin"

ScrollArea {
    id:area
    color: "white"
    width: 280
    height: 120
    contentWidth: edit.paintedWidth + (2 * documentMargins)

    property alias text: edit.text
    property alias wrapMode: edit.wrapMode
    property alias readOnly: edit.readOnly

    highlightOnFocus: true
    property int documentMargins: 4
    frame: true

    Item {
        anchors.left: parent.left
        anchors.top: parent.top
        height: edit.paintedHeight + area.height - viewportHeight
        anchors.margins: documentMargins

        TextEdit {
            id: edit
            text: loremIpsum + loremIpsum;
            wrapMode: TextEdit.WordWrap;
            width: 200
            selectByMouse: true
            readOnly: false
            focus: true

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
