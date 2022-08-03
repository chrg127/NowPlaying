import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.12
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import QtGraphicalEffects 1.12

/*
 * This file describes the actual GUI of the plasmoid
 * (what people would normally call a 'View')
 */

RowLayout {
    id: fullView
    focus: true

    // This controls plasmoid shortcuts.
    Keys.onReleased: {
        if (!event.modifiers && plasmoid.configuration.enableShortcuts) {
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

    function formatPosition(pos, len) {
        function pad(num, size) {
            num = num.toString();
            while (num.length < size)
                num = "0" + num;
            return num;
        }
        function fmt(p) {
            var m = Math.floor(p / 1000000 / 60)
            var s = Math.floor(p / 1000000 % 60)
            return "%1:%2".arg(pad(m, 2)).arg(pad(s, 2))
        }
        return "%1/%2".arg(fmt(pos)).arg(fmt(len))
    }

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
                Layout.alignment: Qt.AlignLeft
                text: "NOW"
                lineHeight: 0.8
                font.family:    plasmoid.configuration.labelFont
                color:          plasmoid.configuration.labelFontColor
                font.bold:      plasmoid.configuration.labelFontBold
                font.italic:    plasmoid.configuration.labelFontItalic
                font.pixelSize: plasmoid.configuration.labelFontHeight
                layer.enabled: plasmoid.configuration.labelShadowEnable
                layer.effect: DropShadow {
                    color:              plasmoid.configuration.labelShadowColor
                    radius:             plasmoid.configuration.labelShadowRadius
                    horizontalOffset:   plasmoid.configuration.labelShadowHoff
                    verticalOffset:     plasmoid.configuration.labelShadowVoff
                    samples:            0
                }
            }

            Label {
                id: nowPlayingLabel2
                Layout.alignment: Qt.AlignLeft
                text: "PLAYING"
                lineHeight: 0.8
                font.family:    plasmoid.configuration.labelFont
                color:          plasmoid.configuration.labelFontColor
                font.bold:      plasmoid.configuration.labelFontBold
                font.italic:    plasmoid.configuration.labelFontItalic
                font.pixelSize: plasmoid.configuration.labelFontHeight
                layer.enabled: plasmoid.configuration.labelShadowEnable
                layer.effect: DropShadow {
                    color:              plasmoid.configuration.labelShadowColor
                    radius:             plasmoid.configuration.labelShadowRadius
                    horizontalOffset:   plasmoid.configuration.labelShadowHoff
                    verticalOffset:     plasmoid.configuration.labelShadowVoff
                    samples:            plasmoid.configuration.labelShadowRadius*2
                }
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
        width: plasmoid.configuration.lineWidth
        color: plasmoid.configuration.lineColor
        Layout.fillHeight: true
    }

    // The actual music information.
    ColumnLayout {
        Layout.fillWidth: true
        id: infoColumn

        PlasmaComponents.Label {
            Layout.fillWidth: true
            text: plasmoid.configuration.firstInfo === "name"   ? mediaSource.track
                : plasmoid.configuration.firstInfo === "artist" ? mediaSource.artist
                : plasmoid.configuration.firstInfo === "album"  ? mediaSource.album
                : plasmoid.configuration.firstInfo === "pos"    ? formatPosition(mediaSource.position, mediaSource.length)
                : ""
            font.family:    plasmoid.configuration.firstFont
            color:          plasmoid.configuration.firstFontColor
            font.bold:      plasmoid.configuration.firstFontBold
            font.italic:    plasmoid.configuration.firstFontItalic
            font.pixelSize: plasmoid.configuration.firstFontHeight
            lineHeight: 0.8
            elide: Text.ElideRight
            layer.enabled: plasmoid.configuration.firstShadowEnable
            layer.effect: DropShadow {
                color:              plasmoid.configuration.firstShadowColor
                radius:             plasmoid.configuration.firstShadowRadius
                horizontalOffset:   plasmoid.configuration.firstShadowHoff
                verticalOffset:     plasmoid.configuration.firstShadowVoff
                samples:            plasmoid.configuration.firstShadowRadius*2
            }
        }

        PlasmaComponents.Label {
            Layout.maximumWidth: 300
            Layout.fillWidth: true
            text: plasmoid.configuration.secondInfo === "name"   ? mediaSource.track
                : plasmoid.configuration.secondInfo === "artist" ? mediaSource.artist
                : plasmoid.configuration.secondInfo === "album"  ? mediaSource.album
                : plasmoid.configuration.secondInfo === "pos"    ? formatPosition(mediaSource.position, mediaSource.length)
                : ""
            font.family:    plasmoid.configuration.secondFont
            color:          plasmoid.configuration.secondFontColor
            font.bold:      plasmoid.configuration.secondFontBold
            font.italic:    plasmoid.configuration.secondFontItalic
            font.pixelSize: plasmoid.configuration.secondFontHeight
            lineHeight: 0.8
            elide: Text.ElideRight
            layer.enabled: plasmoid.configuration.secondShadowEnable
            layer.effect: DropShadow {
                color:              plasmoid.configuration.secondShadowColor
                radius:             plasmoid.configuration.secondShadowRadius
                horizontalOffset:   plasmoid.configuration.secondShadowHoff
                verticalOffset:     plasmoid.configuration.secondShadowVoff
                samples:            plasmoid.configuration.secondShadowRadius*2
            }
        }
    }
}
