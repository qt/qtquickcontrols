import QtQuick 1.0

QtObject {
    property Component background:
    Component {
        Image {
            opacity: running ? 1.0 : 0.7    //mm Should the rotation fade and stop when indicator is !enabled?
            source: "images/spinner.png";
            fillMode: Image.PreserveAspectFit
            smooth: true

            property int steps: 12
            property int rotationStep: 0
            rotation: rotationStep*(360/steps)
            NumberAnimation on rotationStep {
                running: busyIndicator.running; from: 0; to: steps; //mm see QTBUG-15652
                loops: Animation.Infinite; duration: 1000 // 1s per revolution
            }
        }
    }
}
