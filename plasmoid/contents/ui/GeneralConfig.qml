import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11
import QtQuick.Dialogs 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "."

Item {
    id: configRoot

    signal configurationChanged
    property alias cfg_opacity: opacitySpinBox.value
    property string cfg_preferredSource
    property string cfg_fontFamily
    property color cfg_secondaryColor
    property color cfg_mainColor
    property color cfg_lineColor
    property string cfg_firstRowInfo
    property string cfg_secondRowInfo

    ColumnLayout {
        spacing: units.smallSpacing * 2

        RowLayout {
            Label {
                text: i18n("Opacity:")
            }

            SpinBox {
                id: opacitySpinBox
                from: 0
                to: 100
            }
        }

        PlasmaCore.DataSource {
            id: mpris
            engine: "mpris2"
        }

        RowLayout {
            Label {
                text: i18n("Preferred media source:")
            }

            ListModel {
                id: sourcesModel
                Component.onCompleted: {
                    var arr = []
                    var sources = mpris.sources
                    arr.push({ "text" : "Any" })
                    for (var i = 0, j = sources.length; i < j; ++i) {
                        if (sources[i] !== cfg_preferredSource) {
                            arr.push({ "text": sources[i] })
                        }
                    }
                    append(arr)
                }
            }

            ComboBox {
                id: sourcesComboBox
                model: sourcesModel
                focus: true
                currentIndex: 0
                textRole: "text"
                onCurrentIndexChanged: {
                    var current = model.get(currentIndex)
                    if (current) {
                        cfg_preferredSource = current.text === "Any" ? "@multiplex" : current.text
                        configRoot.configurationChanged()
                    }
                }
            }
        }

        RowLayout {
            Label {
                text: i18n("Font:")
            }

            ListModel {
                id: fontsModel
                Component.onCompleted: {
                    var arr = []
                    var fonts = Qt.fontFamilies()
                    arr.push({ "text": "Default (Noto Sans)", "value": "default" })
                    for (var i = 0, j = fonts.length; i < j; ++i) {
                        arr.push({ "text" : fonts[i], "value" : fonts[i] })
                    }
                    append(arr)
                }
            }

            ComboBox {
                id: fontFamilyComboBox
                model: fontsModel
                textRole: "text"
                currentIndex: 0
                onCurrentIndexChanged: {
                    var current = model.get(currentIndex)
                    if (current) {
                        cfg_fontFamily = current.value === "default" ? "Noto Sans" : current.value
                        configRoot.configurationChanged()
                    }
                }
            }
        }

        RowLayout {
            Label {
                text: i18n("Main color:")
            }

            ColorButton {
                id: otherColorButton
                value: cfg_mainColor
                onValueChanged: {
                    cfg_mainColor = value
                    configRoot.configurationChanged()
                }
            }

            Label {
                text: i18n("Secondary color:")
            }

            ColorButton {
                id: labelColorButton
                value: cfg_secondaryColor
                onValueChanged: {
                    cfg_secondaryColor = value
                }
            }
        }

        ListModel {
            id: trackInfoModel

            ListElement { text: "Track name";          value: "name"   }
            ListElement { text: "Artist";              value: "artist" }
            ListElement { text: "Album";               value: "album"  }
            ListElement { text: "Position and length"; value: "pos"    }
        }

        RowLayout {
            Label {
                text: i18n("First row:")
            }

            ComboBox {
                id: firstRowSelector
                model: trackInfoModel
                currentIndex: 0
                textRole: "text"
                onCurrentIndexChanged: {
                    var current = model.get(currentIndex)
                    if (current) {
                        cfg_firstRowInfo = current.value
                    }
                }
            }
        }

        RowLayout {
            Label {
                text: i18n("Second row:")
            }

            ComboBox {
                id: secondRowSelector
                model: trackInfoModel
                currentIndex: 2
                textRole: "text"
                onCurrentIndexChanged: {
                    var current = model.get(currentIndex)
                    if (current) {
                        cfg_secondRowInfo = current.value
                    }
                }
            }
        }
    }
}
