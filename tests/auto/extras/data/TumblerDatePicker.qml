import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Extras 1.4

Tumbler {
    id: tumbler

    readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    TumblerColumn {
        id: tumblerDayColumn

        function updateModel() {
            var previousIndex = tumblerDayColumn.currentIndex;
            var array = [];
            var newDays = tumbler.days[monthColumn.currentIndex];
            for (var i = 0; i < newDays; ++i) {
                array.push(i + 1);
            }
            model = array;
            tumbler.setCurrentIndexAt(0, Math.min(newDays - 1, previousIndex));
        }
    }
    TumblerColumn {
        id: monthColumn
        model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        onCurrentIndexChanged: tumblerDayColumn.updateModel()
    }
    TumblerColumn {
        model: ListModel {
            Component.onCompleted: {
                for (var i = 2000; i < 2100; ++i) {
                    append({value: i.toString()});
                }
            }
        }
    }
}
