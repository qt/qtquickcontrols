import QtQuick 1.0
import "../../../components" as Components
import "../plugin"

Components.TextArea {
    id:textarea
    leftMargin:12
    rightMargin:12
    minimumWidth:200
    desktopBehavior:true
    placeholderText:""

    // Align with button
    property int buttonHeight: buttonitem.sizeFromContents(100, 14).height
    QStyleItem { id:buttonitem; elementType:"button" }
    minimumHeight: buttonHeight

    background: QStyleBackground {
        anchors.fill:parent
        style: QStyleItem{
            elementType:"edit"
            sunken:true
            focus:textarea.activeFocus
        }
    }

    Item{
        id:focusFrame
        anchors.fill: textarea
        parent:textarea.parent
        visible:framestyle.styleHint("focuswidget")
        QStyleBackground{
            anchors.margins: -1
            anchors.rightMargin:-5
            anchors.bottomMargin:-5
            anchors.fill: parent
            visible:textarea.activeFocus
            style: QStyleItem {
                id:framestyle
                elementType:"focusframe"
            }
        }
    }
}
