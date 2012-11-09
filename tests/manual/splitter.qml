import QtQuick 2.0
import QtDesktop 1.0

ApplicationWindow {
    width: 400
    height: 200

    Row {
        SplitterColumn {
            width: 200
            height: 200

            Button {
                text: "Button 1"
            }
            Button {
                text: "Button 2"
            }
            Button {
                text: "Button 2"
            }
        }

        SplitterRow {
            width: 200
            height: 200

            Button {
                text: "Button 1"
            }
            Button {
                text: "Button 2"
            }
        }
    }
}
