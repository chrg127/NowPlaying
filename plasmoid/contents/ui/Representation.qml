import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

/*
 * This file describes the actual GUI of the plasmoid
 * (what people would normally call a 'View')
 */

RowLayout {
    id: fullView
    focus: true

    // This controls plasmoid shortcuts.
    /*
    Keys.onReleased: {
        if (!event.modifiers) {
            event.accepted = true
            if (event.key === Qt.Key_Space || event.key === Qt.Key_K) {
                root.mediaToggle()
            } else if (event.key === Qt.Key_P) {
                root.mediaPrev()
            } else if (event.key === Qt.Key_N) {
                root.mediaNext()
            } else {
                event.accepted = false
            }
        }
    }
    */

    MouseArea {
        // Layout.alignment: Qt.AlignRight
        id: mediaControlsMouseArea
        height: separator.height
        width: nowPlayingColumn.width
        hoverEnabled: true

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0
            id: nowPlayingColumn

            // These two labels correspond to the 'NOW PLAYING' text
            Label {
                id: nowPlayingLabel1
                Layout.alignment: Qt.AlignRight
                text: "NOW"
                lineHeight: 0.8
                // color: "orange"
                font.pixelSize: 16
                font.bold: true
                font.family: plasmoid.configuration.fontFamily
            }

            Label {
                id: nowPlayingLabel2
                Layout.alignment: Qt.AlignRight
                text: "PLAYING"
                lineHeight: 0.8
                // color: "orange"
                font.bold: true
                font.pixelSize: 16
                font.family: plasmoid.configuration.fontFamily
            }

            // This refers to the small controls you can find when hovering on the left part of the widget.
            RowLayout {
                id: mediaControls
                opacity: mediaControlsMouseArea.containsMouse
                Behavior on opacity {
                    PropertyAnimation {
                        easing.type: Easing.InOutQuad
                        duration: 250
                    }
                }
                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    contentItem: PlasmaCore.IconItem {
                        source: "media-skip-backward"
                    }
                    padding: 0
                    background: null
                    onClicked: {
                        root.mediaPrev()
                        console.log("prev clicked")
                    }
                }
                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    id: playButton
                    contentItem: PlasmaCore.IconItem {
                        source: mediaSource.playbackStatus === "Playing" ? "media-playback-pause" : "media-playback-start"
                    }
                    padding: 0
                    background: null
                    onClicked: {
                        root.mediaToggle()
                        console.log("pause clicked")
                    }
                }
                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    contentItem: PlasmaCore.IconItem {
                        source: "media-skip-forward"
                    }
                    onClicked: {
                        root.mediaNext()
                        console.log(mediaSource.playbackStatus)
                        console.log("next clicked")
                    }
                    padding: 0
                    background: null
                }
            }
        }
    }

    // This is that little vertical bar between "NOW PLAYING" and the music info.
    Rectangle {
        id: separator
        width: 1
        // color: "black"
        Layout.fillHeight: true
    }

    // The actual music information.
    ColumnLayout {
        Layout.fillWidth: true
        id: infoColumn
        PlasmaComponents.Label {
            font.family: plasmoid.configuration.fontFamily
            text: mediaSource.track
            Layout.fillWidth: true
            font.pixelSize: 28
            // color: "red"
            lineHeight: 0.8
            font.bold: true
            elide: Text.ElideRight
        }
        PlasmaComponents.Label {
            font.family: plasmoid.configuration.fontFamily
            elide: Text.ElideRight
            Layout.maximumWidth: 300
            Layout.fillWidth: true
            text: mediaSource.album
            font.pixelSize: 26
            // color: "red"
            lineHeight: 0.8
        }
    }
}
