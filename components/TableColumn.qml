import QtQuick 1.1

QtObject {
    property string title
    property string role
    property int width: 160
    property int x
    property bool visible: true
    property int elideMode: Text.ElideRight
    property int textAlignment: Text.AlignLeft
    property Component delegate
}
