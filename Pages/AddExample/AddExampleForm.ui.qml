import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components/"
import "../../Components/Material"
import "../../Components/Buttons"
import "../../Components/FontAwesome"

Page {
    id: root
    title: qsTr("")

    property alias recordButton: recordButton
    property alias saveButton: saveButton
    property alias fileName: fileName.text

    Label {
        id: firstStepLabel

        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.top: parent.top
        anchors.topMargin: 20

        text: qsTr("1. Please sing the verse of the reference song")
        font.pointSize: 14
    }

    AnimatedRecordButton {
        id: recordButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: firstStepLabel.bottom
        height: 180
        width: height
        reloadPath: false
        enabled: !fileRecorded
        opacity: !fileRecorded ? 1 : 0.3
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
        opacity: !fileRecorded ? 1 : 0.3
    }

    Rectangle {
        id: firstLine

        anchors.top: recordButtonHint.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 10
        anchors.right: parent.right
        anchors.rightMargin: anchors.leftMargin
        height: 4

        color: Theme.primary.color
    }

    Label {
        id: secondStepLabel

        anchors.top: firstLine.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        text: qsTr("2. Set example name")
        font.pointSize: 14
    }

    TextField {
        id: fileName

        anchors.top: secondStepLabel.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        font.pointSize: 15
        enabled: fileRecorded
    }

    FontAwesomeToolButton {
        id: saveButton

        anchors.top: fileName.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        width: 100
        height: 70

        icon: FontAwesome.icons.faSave
        color: Theme.primary.color
        baseSize: 30
        button.enabled: fileRecorded
        opacity: fileRecorded ? 1 : 0.3
    }
}
