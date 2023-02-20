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
    property bool firstRun: true

    AnimatedRecordButton {
        id: recordButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: 200
        width: 200
    }

    Rectangle {
        anchors.top: noteRectangle.bottom
        anchors.topMargin: -25
        anchors.horizontalCenter: noteRectangle.horizontalCenter
        rotation: 45
        height: 40
        width: 40
        visible: !recordButton.checked
        color: Theme.primaryLight.color
    }

    Rectangle {
        id: noteRectangle
        anchors.bottom: recordButton.top
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: anchors.leftMargin
        visible: !recordButton.checked
        color: Theme.primaryLight.color
        height: 100
        radius: 20

        Label {
            anchors.centerIn: parent

            text: firstRun ? qsTr("Please sing the verse <br> of the <b>Reference</b> song!") :
                             qsTr("Please sing the <b>Same Verse</b> <br> of the reference song <br> for <b>Testing</b>")
            textFormat: Text.StyledText
            font.pointSize: 15
            wrapMode: Text.WordWrap
            horizontalAlignment: "AlignHCenter"
            color: Theme.primaryLight.textColor
        }
    }

    Label {
        anchors.top: recordButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        text: recordButton.checked ? qsTr("Click to stop recording") :
                                     qsTr("Click to start recording")
        font.pointSize: 15
        wrapMode: Text.WordWrap
        horizontalAlignment: "AlignHCenter"
    }
}
