import QtQuick 2.2
import QtQuick.Extras 1.4

Rectangle {
    width: 400
    height: 400

    PieMenu {
        Component.onCompleted: {
            visible = true;
            visible = false;
        }
    }
}
