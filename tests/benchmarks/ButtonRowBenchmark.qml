import QtQuick 1.0
import QmlTime 1.0 as QmlTime
import "../../components" as QtComponents

Item {
    QmlTime.Timer {
        component: QtComponents.ButtonRow {
           QtComponents.Button { text: "Button A" }
           QtComponents.Button { text: "Buttom B" }
           QtComponents.Button { text: "Bottom C" }
        }
    }
}
