import QtQuick 2.4
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

RowLayout {
    property var theModel
    property int startIndex
    property string infoValue

    Label {
        text: i18n("Show:")
    }

    ComboBox {
        model: theModel
        currentIndex: startIndex
        textRole: "text"
        onCurrentIndexChanged: {
            var current = model.get(currentIndex)
            if (current) {
                infoValue = current.value
            }
        }
    }
}

