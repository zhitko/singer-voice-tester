import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.14
import "Material"

import "FontAwesome"

Rectangle {
    id: root

    property alias firstTitle: firstTitle
    property alias secondTitle: secondTitle
    property alias label: label
    property real value1: -1.0
    property real value2: -1.0
    property bool showSecond: false

    property int marginValue: 2

    Rectangle {
        id: bars
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 1
        height: parent.height * 0.8

        Rectangle {
            id: firstBar
            anchors.left: parent.left
            anchors.leftMargin: root.marginValue
            anchors.bottom: parent.bottom
            anchors.bottomMargin: root.marginValue
            color: Theme.primaryLight.color
            width: root.showSecond ? (parent.width - root.marginValue*3) / 2 : (parent.width - root.marginValue*2)
            height: (parent.height - root.marginValue*2) * root.value1
        }

        Label {
            id: valueLabel1
            visible: false
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: firstBar.horizontalCenter
            text: root.value1.toFixed(2)
            color: Theme.primaryLight.textColor
        }

        Rectangle {
            id: secondBar
            visible: root.value2 !== -1.0
            anchors.right: parent.right
            anchors.rightMargin: root.marginValue
            anchors.bottom: parent.bottom
            anchors.bottomMargin: root.marginValue
            color: Theme.secondaryLight.color
            width: root.showSecond ? (parent.width - root.marginValue*3) / 2 : 0
            height: (parent.height - root.marginValue*2) * root.value2
        }

        Label {
            id: valueLabel2
            visible: false
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: secondBar.horizontalCenter
            text: root.showSecond ? root.value2.toFixed(2) : ""
            color: Theme.secondaryLight.textColor
        }
    }

    Rectangle {
        id: tile
        color: Colors.white
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: bars.bottom
        anchors.leftMargin: 3
        anchors.rightMargin: 3
        anchors.bottomMargin: 2

        Rectangle {
            id: firstTitle
            anchors.fill: parent
        }
        Rectangle {
            id: secondTitle
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: firstTitle.color === tile.color ? parent.width :
                            secondTitle.color == tile.color ? 0 : parent.width/2
        }
        Label {
            id: label
            anchors.fill: parent
            text: qsTr("")
            font.capitalization: "AllUppercase"
            font.bold: true
            horizontalAlignment: "AlignHCenter"
            color: Theme.backgound.textColor
        }
    }
}
