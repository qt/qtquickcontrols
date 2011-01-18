import QtQuick 1.0
import QmlTime 1.0 as QmlTime
import "../../components" as QtComponents

Item {
    GridView { id: gridView }

    QmlTime.Timer {
        component: Item { QtComponents.ScrollIndicator { scrollItem: gridView }
        }
    }
}
