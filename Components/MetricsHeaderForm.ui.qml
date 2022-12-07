import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.14

import "FontAwesome"

ColumnLayout {
    id: mainLayout

    property alias firstValue1: firstValue1
    property alias firstValue2: firstValue2
    property alias secondValue1: secondValue1
    property alias secondValue2: secondValue2

    spacing: 10

    RowLayout {
        Layout.fillWidth: true

        Rectangle {
            id: firstBar
            color: Colors.brilliant_azure
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text {
            id: firstValue1
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            text: ""
            textFormat: Text.RichText
            font.pointSize: 12
        }

        Text {
            id: firstValue2
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            text: ""
            textFormat: Text.RichText
            font.pointSize: 12
        }

        Rectangle {
            color: firstBar.color
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    RowLayout {
        Layout.fillWidth: true
        visible: secondValue1.text != ""

        Rectangle {
            id: secondBar
            color: Colors.light_green
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Text {
            id: secondValue1
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            text: ""
            textFormat: Text.RichText
            font.pointSize: 12
        }

        Text {
            id: secondValue2
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            text: ""
            textFormat: Text.RichText
            font.pointSize: 12
        }

        Rectangle {
            color: secondBar.color
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
