import QtQuick 1.1
import QtDesktop 0.1

ApplicationWindow {
    id: window
    width: 640
    height: 400

    SystemPalette { id: palette }

    Settings { // Store persistant settings here
        property alias width: window.width
        property alias height: window.height
    }

    toolBar: ToolBar{
        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            ToolButton {
                iconSource: "images/media-skip-backward.png"
            }
            ToolButton {
                iconSource: "images/media-playback-pause.png"
            }
            ToolButton {
                iconSource: "images/media-skip-forward.png"
            }
            Label{
                text: "0:00"
            }
            Slider{
                id: slider
                Layout.horizontalSizePolicy: Layout.Expanding
            }
            Label{
                text: "4:00"
            }
            TextField {
                id: searchedit
                styleHint: "rounded"
            }
        }
    }

    statusBar: StatusBar {
        Label {
            anchors.centerIn: parent
            text: "Currently playing track"
        }
    }

    SplitterRow {
        anchors.fill: parent
        handleWidth: 1
        Item {
            width: 160
            Splitter.maximumWidth: 200
            Splitter.minimumWidth: 50
            TableView {
                id: view
                frame: false
                alternateRowColor: false
                backgroundColor: palette.alternateBase
                anchors.top: parent.top
                anchors.bottom: albumview.top
                TableColumn{
                    title: "Playlists"
                    role: "name"
                    elideMode: Text.ElideRight
                }
                model: ListModel {
                    Component.onCompleted: {
                        for (var i = 0 ; i < 10 ; ++i)
                            append( {"name" : "Playlist "+i})
                    }
                }
            }
            Image {
                id: albumview
                anchors.bottom: parent.bottom
                width: parent.width
                height: parent.width
                fillMode: Image.PreserveAspectCrop
                clip: true
                source: "images/album.jpg"
                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: palette.dark
                }
            }
        }
        TableView {
            frame: false
            TableColumn{
                title: "Track"
                role: "name"
            }
            TableColumn{
                title: "Artist"
                role: "artist"
            }
            TableColumn{
                title: "Album"
                role: "album"
            }
            model: ListModel {
                Component.onCompleted: {
                    for (var i = 0 ; i < 100 ; ++i)
                        append( {"name" : "Track "+i,
                                 "artist" : "Artist "+i,
                                 "album" : "Album "+i})
                }
            }
        }
    }
}
