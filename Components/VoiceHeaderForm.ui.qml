import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.14
import "Material"

import "FontAwesome"
import "../App"

ColumnLayout {
    property alias bass: bass
    property alias baritone: baritone
    property alias tenor: tenor
    property alias contralto: contralto
    property alias mezzosoprano: mezzosoprano
    property alias soprano: soprano

    property bool showSecond: false

    property int titleWidth: 40
    property int titleHeight: 90

    Rectangle {
        color: Theme.primary.color
        Layout.preferredHeight: titleHeight + 4
        Layout.fillWidth: true

        RowLayout {
            spacing: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.margins: 2
            visible: Bus.isMale

            VoiceHeaderTile {
                id: bass
                label.text: qsTr("Bass")
                Layout.fillWidth: true
                Layout.preferredWidth: titleWidth
                Layout.preferredHeight: titleHeight
                showSecond: root.showSecond
            }

            VoiceHeaderTile {
                id: baritone
                label.text: qsTr("Baritone")
                Layout.fillWidth: true
                Layout.preferredWidth: titleWidth
                Layout.preferredHeight: titleHeight
                showSecond: root.showSecond
            }

            VoiceHeaderTile {
                id: tenor
                label.text: qsTr("Tenor")
                Layout.fillWidth: true
                Layout.preferredWidth: titleWidth
                Layout.preferredHeight: titleHeight
                showSecond: root.showSecond
            }
        }

        RowLayout {
            spacing: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.margins: 2
            visible: !Bus.isMale

            VoiceHeaderTile {
                id: contralto
                label.text: qsTr("Contralto")
                Layout.fillWidth: true
                Layout.preferredWidth: titleWidth
                Layout.preferredHeight: titleHeight
                showSecond: root.showSecond
            }

            VoiceHeaderTile {
                id: mezzosoprano
                label.text: qsTr("Mezzo")
                Layout.fillWidth: true
                Layout.preferredWidth: titleWidth
                Layout.preferredHeight: titleHeight
                showSecond: root.showSecond
            }

            VoiceHeaderTile {
                id: soprano
                label.text: qsTr("Soprano")
                Layout.fillWidth: true
                Layout.preferredWidth: titleWidth
                Layout.preferredHeight: titleHeight
                showSecond: root.showSecond
            }
        }
    }
}
