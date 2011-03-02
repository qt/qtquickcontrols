import QtQuick 1.0
import "custom" as Components
import "plugin"

QStyleBackground {
    id:toolbar
    width:200
    height: styleitem.sizeFromContents(32, 32).height
    style: QStyleItem{id:styleitem; elementType:"toolbar"}
}

