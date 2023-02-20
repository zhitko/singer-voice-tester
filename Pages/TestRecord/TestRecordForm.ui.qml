import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components/"
import "../../Components/Buttons"
import "../../Components/FontAwesome"

Page {
    id: root
    title: qsTr("")

    property alias recordButton: recordButton
    property bool showVoiceSelect: true

    property alias maleButton: maleButton
    property alias femaleButton: femaleButton

    Label {
        id: voiceTypeLabel
        visible: !recordButton.checked && showVoiceSelect
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        text: qsTr("Please indicate your voice:")
        font.pointSize: 25
    }

    RowLayout {
        id: voiceTypeButtons
        anchors.top: voiceTypeLabel.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        LabelToolButton {
            id: maleButton
            visible: !recordButton.checked && showVoiceSelect
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 50
            text: qsTr("Male")
            active: Bus.isMale
            font.pointSize: 15
            Layout.minimumWidth: parent.width / 2
        }

        LabelToolButton {
            id: femaleButton
            visible: !recordButton.checked && showVoiceSelect
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 50
            text: qsTr("Female")
            active: !Bus.isMale
            font.pointSize: 15
            Layout.minimumWidth: parent.width / 2
        }
    }

    AnimatedRecordButton {
        id: recordButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: 180
        width: 180
    }

    Label {
        id: recordButtonHint
        anchors.top: recordButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        text: recordButton.checked ?
                  qsTr("Click to stop recording") :
                  qsTr("Click to start recording")
        font.pointSize: 15
        wrapMode: Text.WordWrap
        horizontalAlignment: "AlignHCenter"
    }
}
