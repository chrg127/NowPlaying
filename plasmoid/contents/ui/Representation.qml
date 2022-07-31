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
                color: plasmoid.configuration.secondaryColor
                font.pixelSize: 16
                font.bold: true
                font.family: plasmoid.configuration.fontFamily
            }

            Label {
                id: nowPlayingLabel2
                Layout.alignment: Qt.AlignRight
                text: "PLAYING"
                lineHeight: 0.8
                color: plasmoid.configuration.secondaryColor
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
                    /* color: plasmoid.configuration.mainColor */
                    background: null
                    onClicked: {
                        root.mediaPrev()
                    }
                }

                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    id: playButton
                    contentItem: PlasmaCore.IconItem {
                        source: mediaSource.playbackStatus === "Playing" ? "media-playback-pause"
                                                                         : "media-playback-start"
                    }
                    padding: 0
                    /* color: plasmoid.configuration.mainColor */
                    background: null
                    onClicked: {
                        root.mediaToggle()
                    }
                }

                Button {
                    Layout.preferredWidth: nowPlayingLabel2.width / 3
                    contentItem: PlasmaCore.IconItem {
                        source: "media-skip-forward"
                    }
                    padding: 0
                    /* color: plasmoid.configuration.mainColor */
                    background: null
                    onClicked: {
                        root.mediaNext()
                    }
                }
            }
        }
    }

    // This is that little vertical bar between "NOW PLAYING" and the music info.
    Rectangle {
        id: separator
        width: 1
        color: plasmoid.configuration.mainColor
        Layout.fillHeight: true
    }

    function formatPosition(pos, len) {
        function pad(num, size) {
            num = num.toString();
            while (num.length < size)
                num = "0" + num;
            return num;
        }
        var mins = Math.floor(pos / 1000000 / 60)
        var secs = Math.floor(pos / 1000000 % 60)
        var max_mins = Math.floor(len / 1000000 / 60)
        var max_secs = Math.floor(len / 1000000 % 60)
        return "%1:%2/%3:%4".arg(pad(mins, 2))
                            .arg(pad(secs, 2))
                            .arg(pad(max_mins, 2))
                            .arg(pad(max_secs, 2))
    }

    // The actual music information.
    ColumnLayout {
        Layout.fillWidth: true
        id: infoColumn

        PlasmaComponents.Label {
            font.family: plasmoid.configuration.fontFamily
            text: plasmoid.configuration.firstRowInfo === "name"   ? mediaSource.track
                : plasmoid.configuration.firstRowInfo === "artist" ? mediaSource.artist
                : plasmoid.configuration.firstRowInfo === "album"  ? mediaSource.album
                : plasmoid.configuration.firstRowInfo === "pos"    ? formatPosition(mediaSource.position, mediaSource.length)
                : ""
            Layout.fillWidth: true
            font.pixelSize: 28
            color: plasmoid.configuration.mainColor
            lineHeight: 0.8
            font.bold: true
            elide: Text.ElideRight
        }

        PlasmaComponents.Label {
            font.family: plasmoid.configuration.fontFamily
            elide: Text.ElideRight
            Layout.maximumWidth: 300
            Layout.fillWidth: true
            text: plasmoid.configuration.secondRowInfo === "name"   ? mediaSource.track
                : plasmoid.configuration.secondRowInfo === "artist" ? mediaSource.artist
                : plasmoid.configuration.secondRowInfo === "album"  ? mediaSource.album
                : plasmoid.configuration.secondRowInfo === "pos"    ? formatPosition(mediaSource.position, mediaSource.length)
                : ""
            font.pixelSize: 26
            color: plasmoid.configuration.mainColor
            lineHeight: 0.8
        }
    }
}
