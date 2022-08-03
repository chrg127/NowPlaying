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

    property string cfg_firstInfo
    property string cfg_firstFont
    property color  cfg_firstFontColor
    property bool   cfg_firstFontBold
    property bool   cfg_firstFontItalic
    property int    cfg_firstFontHeight
    property alias  cfg_firstShadowEnable: firstShadowCheckbox.checked
    property color  cfg_firstShadowColor
    property int    cfg_firstShadowRadius
    property int    cfg_firstShadowHoff
    property int    cfg_firstShadowVoff

    property string cfg_secondInfo
    property string cfg_secondFont
    property color  cfg_secondFontColor
    property bool   cfg_secondFontBold
    property bool   cfg_secondFontItalic
    property int    cfg_secondFontHeight
    property alias  cfg_secondShadowEnable: secondShadowCheckbox.checked
    property color  cfg_secondShadowColor
    property int    cfg_secondShadowRadius
    property int    cfg_secondShadowHoff
    property int    cfg_secondShadowVoff

    property string cfg_labelFont
    property color  cfg_labelFontColor
    property bool   cfg_labelFontBold
    property bool   cfg_labelFontItalic
    property int    cfg_labelFontHeight
    property alias  cfg_labelShadowEnable: labelShadowCheckbox.checked
    property color  cfg_labelShadowColor
    property int    cfg_labelShadowRadius
    property int    cfg_labelShadowHoff
    property int    cfg_labelShadowVoff

    property alias cfg_lineWidth: thicknessSpinBox.value
    property color cfg_lineColor
    property alias cfg_alignment: alignmentsComboBox.currentIndex
    property int   cfg_background
    property alias cfg_enableShortcuts: shortcutsCheckbox.checked

    function indexOf(list, toFind, def) {
        for (var i = 0; i < list.count; i++) {
            var obj = list.get(i)
            if (obj && obj.value === toFind) {
                return i
            }
        }
        return def
    }

    PlasmaCore.DataSource {
        id: mpris
        engine: "mpris2"
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

    ListModel {
        id: trackInfoModel
        ListElement { text: "Track name";          value: "name"   }
        ListElement { text: "Artist";              value: "artist" }
        ListElement { text: "Album";               value: "album"  }
        ListElement { text: "Position and length"; value: "pos"    }
    }

    ScrollView {
        id: scrollView

        ColumnLayout {
            id: layout
            anchors.fill: parent
            spacing: 30

            ColumnLayout {
                spacing: 10

                Label {
                    text: i18n("General settings")
                    font.bold: true
                    font.pixelSize: 17
                }

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

                RowLayout {
                    Label {
                        text: i18n("Media source:")
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
            }

            ColumnLayout {
                Label {
                    text: i18n("First row")
                    font.bold: true
                    font.pixelSize: 17
                }

                InfoBox {
                    theModel: trackInfoModel
                    startIndex: indexOf(theModel, cfg_firstInfo, 0)
                    infoValue: cfg_firstRowInfo
                    onInfoValueChanged: {
                        cfg_firstInfo = infoValue
                    }
                }

                FontConfig {
                    fontModel: fontsModel
                    colorValue:     cfg_firstFontColor
                    fontValue:      cfg_firstFont
                    boldValue:      cfg_firstFontBold
                    italicValue:    cfg_firstFontItalic
                    pxSizeValue:    cfg_firstFontHeight
                    onColorValueChanged: {
                        cfg_firstFontColor = colorValue
                    }
                    onFontValueChanged: {
                        cfg_firstFont = fontValue
                    }
                    onBoldValueChanged: {
                        cfg_firstFontBold = boldValue
                    }
                    onItalicValueChanged: {
                        cfg_firstFontItalic = italicValue
                    }
                    onPxSizeValueChanged: {
                        cfg_firstFontHeight = pxSizeValue
                    }
                }

                CheckBox {
                    id: firstShadowCheckbox
                    text: i18n("Enable shadow")
                    tristate: false
                    checked: cfg_firstShadowEnable
                }

                ShadowConfig {
                    enabled:        firstShadowCheckbox.checked
                    colorValue:     cfg_firstShadowColor
                    radiusValue:    cfg_firstShadowRadius
                    offsetXValue:   cfg_firstShadowHoff
                    offsetYValue:   cfg_firstShadowVoff
                    onColorValueChanged: {
                        cfg_firstShadowColor = colorValue
                    }
                    onRadiusValueChanged: {
                        cfg_firstShadowRadius = radiusValue
                    }
                    onOffsetXValueChanged: {
                        cfg_firstShadowHoff = offsetXValue
                    }
                    onOffsetYValueChanged: {
                        cfg_firstShadowVoff = offsetYValue
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: i18n("Second row")
                    font.bold: true
                    font.pixelSize: 17
                }

                InfoBox {
                    theModel: trackInfoModel
                    startIndex: indexOf(theModel, cfg_secondInfo, 0)
                    infoValue: cfg_secondRowInfo
                    onInfoValueChanged: {
                        cfg_secondInfo = infoValue
                    }
                }

                FontConfig {
                    fontModel: fontsModel
                    colorValue:     cfg_secondFontColor
                    fontValue:      cfg_secondFont
                    boldValue:      cfg_secondFontBold
                    italicValue:    cfg_secondFontItalic
                    pxSizeValue:    cfg_secondFontHeight
                    onColorValueChanged: {
                        cfg_secondFontColor = colorValue
                    }
                    onFontValueChanged: {
                        cfg_secondFont = fontValue
                    }
                    onBoldValueChanged: {
                        cfg_secondFontBold = boldValue
                    }
                    onItalicValueChanged: {
                        cfg_secondFontItalic = italicValue
                    }
                    onPxSizeValueChanged: {
                        cfg_secondFontHeight = pxSizeValue
                    }
                }

                CheckBox {
                    id: secondShadowCheckbox
                    text: i18n("Enable shadow")
                    tristate: false
                    checked: cfg_secondShadowEnable
                }

                ShadowConfig {
                    enabled:        secondShadowCheckbox.checked
                    colorValue:     cfg_secondShadowColor
                    radiusValue:    cfg_secondShadowRadius
                    offsetXValue:   cfg_secondShadowHoff
                    offsetYValue:   cfg_secondShadowVoff
                    onColorValueChanged: {
                        cfg_secondShadowColor = colorValue
                    }
                    onRadiusValueChanged: {
                        cfg_secondShadowRadius = radiusValue
                    }
                    onOffsetXValueChanged: {
                        cfg_secondShadowHoff = offsetXValue
                    }
                    onOffsetYValueChanged: {
                        cfg_secondShadowVoff = offsetYValue
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: i18n("NOW PLAYING label")
                    font.bold: true
                    font.pixelSize: 17
                }

                FontConfig {
                    fontModel: fontsModel
                    colorValue:     cfg_labelFontColor
                    fontValue:      cfg_labelFont
                    boldValue:      cfg_labelFontBold
                    italicValue:    cfg_labelFontItalic
                    pxSizeValue:    cfg_labelFontHeight
                    onColorValueChanged: {
                        cfg_labelFontColor = colorValue
                    }
                    onFontValueChanged: {
                        cfg_labelFont = fontValue
                    }
                    onBoldValueChanged: {
                        cfg_labelFontBold = boldValue
                    }
                    onItalicValueChanged: {
                        cfg_labelFontItalic = italicValue
                    }
                    onPxSizeValueChanged: {
                        cfg_labelFontHeight = pxSizeValue
                    }
                }

                CheckBox {
                    id: labelShadowCheckbox
                    text: i18n("Enable shadow")
                    tristate: false
                    checked: cfg_labelShadowEnable
                }

                ShadowConfig {
                    enabled:        labelShadowCheckbox.checked
                    colorValue:     cfg_labelShadowColor
                    radiusValue:    cfg_labelShadowRadius
                    offsetXValue:   cfg_labelShadowHoff
                    offsetYValue:   cfg_labelShadowVoff
                    onColorValueChanged: {
                        cfg_labelShadowColor = colorValue
                    }
                    onRadiusValueChanged: {
                        cfg_labelShadowRadius = radiusValue
                    }
                    onOffsetXValueChanged: {
                        cfg_labelShadowHoff = offsetXValue
                    }
                    onOffsetYValueChanged: {
                        cfg_labelShadowVoff = offsetYValue
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: i18n("Other")
                    font.bold: true
                    font.pixelSize: 17
                }

                CheckBox {
                    id: shortcutsCheckbox
                    text: i18n("Enable shortcuts")
                    tristate: false
                    checked: cfg_enableShortcuts
                }

                RowLayout {
                    Label {
                        text: i18n("Line thickness:")
                    }

                    SpinBox {
                        id: thicknessSpinBox
                        from: 0
                        to: 5
                    }
                }

                RowLayout {
                    Label {
                        text: i18n("Line color:")
                    }

                    ColorButton {
                        value: cfg_lineColor
                        onValueChanged: {
                            cfg_lineColor = value
                        }
                    }
                }

                RowLayout {
                    Label {
                        text: i18n("Alignment:")
                    }

                    ComboBox {
                        id: alignmentsComboBox
                        model: [
                            { text: i18n("Left"),  value: 0 },
                            { text: i18n("Right"), value: 1 }
                        ]
                        focus: true
                        currentIndex: 0
                        textRole: "text"
                    }
                }

                RowLayout {
                    Label {
                        text: i18n("Background hints:")
                    }

                    ComboBox {
                        id: backgroundComboBox
                        model: [
                            { text: i18n("None"),           value: 0 },
                            { text: i18n("Standard"),       value: 1 },
                            { text: i18n("Translucent"),    value: 2 },
                            { text: i18n("Shadowed"),       value: 4 }
                        ]
                        focus: true
                        textRole: "text"
                        currentIndex: 0
                        onCurrentIndexChanged: {
                            var current = model[currentIndex]
                            if (current) {
                                cfg_background = current.value
                                configRoot.configurationChanged()
                            }
                        }
                    }
                }
            }
        }
    }
}
