import QtQuick 1.0
import QmlTime 1.0 as QmlTime
import "../.." as QtComponents

Item {
    QmlTime.Timer {
        component: QtComponents.Switch { }
    }
}
