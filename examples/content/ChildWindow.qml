import QtQuick 2.0
import QtDesktop 1.0

Window {
    id: window1

    width: 400
    height: 400

    title: "child window"

    Rectangle {
        color: syspal.window
        anchors.fill: parent

        Text {
            id: dimensionsText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: {
                if (Desktop.screenCount == 1) {
                    "You have only a single screen.\nThe dimensions of your screen are: " + Desktop.screenWidth + " x " + Desktop.screenHeight;
                } else {
                    var text = "You have " + Desktop.screenCount + " screens.\nThe dimensions of your screens are: "
                    for(var i=0; i<Desktop.screenCount; i++) {
                        text += "\n" + Desktop.screenGeometry(i).width + " x " + Desktop.screenGeometry(i).height
                    }
                    return text;
                }
            }
        }

        Text {
            id: availableDimensionsText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: dimensionsText.bottom
            width: parent.width
            horizontalAlignment: Text.AlignHCenter

            text: {
                var text = "The available dimensions of your screens are: "
                for(var i=0; i<Desktop.screenCount; i++) {
                    text += "\n" + Desktop.availableGeometry(i).width + " x " + Desktop.availableGeometry(i).height
                }
                return text;
            }
        }

        Text {
            id: closeText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: availableDimensionsText.bottom
            text: "This is a new Window, press the\nbutton below to close it again."
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: closeText.bottom
            id: closeWindowButton
            text:"Close"
            width: 98
            tooltip:"Press me, to close this window again"
            onClicked: window1.visible = false
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: closeWindowButton.bottom
            id: maximizeWindowButton
            text:"Maximize"
            width: 98
            tooltip:"Press me, to maximize this window again"
            onClicked: window1.windowState = Qt.WindowMaximized;
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: maximizeWindowButton.bottom
            id: normalizeWindowButton
            text:"Normalize"
            width: 98
            tooltip:"Press me, to normalize this window again"
            onClicked: window1.windowState = Qt.WindowNoState;
        }
        Button {
            anchors.horizontalCenter: closeText.horizontalCenter
            anchors.top: normalizeWindowButton.bottom
            id: minimizeWindowButton
            text:"Minimize"
            width: 98
            tooltip:"Press me, to minimize this window again"
            onClicked: window1.windowState = Qt.WindowMinimized;
        }
    }
}

