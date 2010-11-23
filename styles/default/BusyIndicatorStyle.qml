import Qt 4.7

QtObject {
    property Component background:
    Component {
        id: defaultBackground
        Image {
            smooth:true
            source: "images/spinner.png";
            NumberAnimation on rotation {
                running: parent.running; from: 0; to: 360;
                loops: Animation.Infinite; duration: 2000
            }
            opacity: running ? 1.0 : 0.5
        }
    }
}
