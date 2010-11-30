import QtQuick 1.0
import QmlTime 1.0 as QmlTime
import "../.." as QtComponents

Item {
    property variant choiceListModel: ListModel {
        ListElement { content: "Choice One" }
        ListElement { content: "Choice Two" }
        ListElement { content: "Choice Three" }
        ListElement { content: "Choice Four" }
        ListElement { content: "Choice Five" }
        ListElement { content: "Choice Six" }
        ListElement { content: "Choice Seven" }
        ListElement { content: "Choice Eight" }
    }

    QmlTime.Timer {
        component: QtComponents.ChoiceList {
            model: choiceListModel
//            delegate:
        }
    }
}
