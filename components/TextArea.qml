import QtQuick 1.0
import "custom" as Components
import "plugin"

ScrollArea {
    id:area
    color: "white"
    width: 280
    height: 120
    contentWidth: 200

    property alias text: edit.text
    property alias wrapMode: edit.wrapMode
    highlightOnFocus: true

    TextEdit {
        id: edit
        text: loremIpsum + loremIpsum;
        wrapMode: TextEdit.WordWrap;
        width: area.contentWidth
        selectByMouse:true
        focus:true

        // keep textcursor within scrollarea
        onCursorRectangleChanged:
            if (cursorRectangle.y >= area.contentY + area.height - 1.5*cursorRectangle.height)
                area.contentY = cursorRectangle.y - area.height + 1.5*cursorRectangle.height
            else if (cursorRectangle.y < area.contentY)
                area.contentY = cursorRectangle.y

    }
}
