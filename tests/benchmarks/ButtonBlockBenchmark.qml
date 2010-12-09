import QtQuick 1.0
import QmlTime 1.0 as QmlTime
import "../../components" as QtComponents

Item {
    QmlTime.Timer {
        component: QtComponents.ButtonBlock {
            model: ListModel {
                ListElement { text: "Button A" }
                ListElement { text: "Button B" }
                ListElement { text: "Button C" }
            }
        }
    }
}
