import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components/"
import "../../Components/Buttons"
import "../../Components/FontAwesome"
import "../../Components/Material"

Page {
    id: root
    title: qsTr("Home")

    property alias testButton: testButton
    property alias trainingButton: trainingButton

    ColumnLayout {
        id: head
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: welcomeText
            Layout.alignment: "AlignHCenter"
            Layout.fillWidth: true
            Layout.minimumHeight: 130
            Layout.maximumHeight: 130
            color: Colors.transparent

            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 40
                anchors.bottomMargin: 40
                color: Theme.primaryLight.color
            }

            Image {
                id: wave
                anchors.fill: parent
                horizontalAlignment: Image.AlignLeft
                fillMode: Image.TileHorizontally
                source: "qrc:///Assets/Images/wave_long.png"
            }

            Label {
                anchors.centerIn: parent
                text: qsTr("Welcome to Singer Voice Tester")
                font.pointSize: 20
                wrapMode: Text.WordWrap
                horizontalAlignment: "AlignHCenter"
                color: Theme.primaryDark.titleColor
            }
        }

        Image {
            id: piano
            Layout.alignment: "AlignHCenter"
            Layout.fillWidth: true
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignLeft
            Layout.maximumHeight: 60
            source: "qrc:///Assets/Images/piano-keys.png"
        }
    }

    ColumnLayout {
        spacing: 25
        anchors.top: head.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 100
        anchors.right: parent.right
        anchors.rightMargin: 100
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20

        LabelToolButton {
            id: testButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("<b>Determine</b> <br> <i>Your Voice Type</i>")
            font.pointSize: 15
        }

        LabelToolButton {
            id: trainingButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("<b>Practice</b> <br> <i>Your Singing Voice</i>")
            font.pointSize: 15
        }
    }
}
