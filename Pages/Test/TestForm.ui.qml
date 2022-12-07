import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtCharts 2.3
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components"
import "../../Components/FontAwesome"

Page {
    id: root
    title: qsTr("Determine Your Voice Type")

    VoiceHeader {
        id: voiceHeader

        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.left: parent.left
    }

    VoiceChart {
        id: chart

        anchors.top: voiceHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: piano.top
    }

    PianoFooter {
        id: piano

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: chart.left
        anchors.leftMargin: chart.plotArea.x - 1
        width: chart.plotArea.width + 2
    }
}
