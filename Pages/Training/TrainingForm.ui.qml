import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtCharts 2.3
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components"
import "../../Components/Material"
import "../../Components/FontAwesome"

Page {
    id: root
    title: qsTr("Practice Your Singing Voice")

    CompareCanvas {
        id: compareChart

        height: parent.height / 2.2

        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.left: parent.left
    }

    VoiceChart {
        id: chart

        anchors.top: compareChart.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: piano.top
        anchors.bottomMargin: -25
    }

    PianoFooterFull {
        id: piano

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: chart.left
        anchors.leftMargin: chart.plotArea.x - 1
        width: chart.plotArea.width + 2
    }
}
