import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Shapes 1.12
import "Material"

Item {
    id: root

    property alias currentMark: currentMark
    property alias iteration: iteration
    property alias averageMark: averageMark
    property alias canvas: canvas

    property bool hasValues: false

    Label {
        id: iteration
        visible: hasValues

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20

        text: "-"
        font.pointSize: currentMark.font.pointSize
        color: Colors.indigo800
    }

    Label {
        id: iterationLabel
        visible: iteration.visible

        anchors.bottom: iteration.top
        anchors.bottomMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5

        text: qsTr("Test Serial\nNumber")
        font.pointSize: 14
        horizontalAlignment: "AlignHCenter"
        color: iteration.color
    }

    Label {
        id: currentMark
        visible: hasValues

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 20

        text: "-"
        font.pointSize: 35
        color: Colors.green800
    }

    Label {
        id: currentMarkLabel
        visible: currentMark.visible

        anchors.bottom: currentMark.top
        anchors.bottomMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        width: iterationLabel.width

        text: qsTr("Current\nScore")
        font.pointSize: iterationLabel.font.pointSize
        horizontalAlignment: "AlignHCenter"
        color: currentMark.color
    }

    Label {
        id: averageMark

        visible: hasValues

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        text: "-"
        font.pointSize: currentMark.font.pointSize
        color: Colors.deepOrange800
    }

    Label {
        visible: averageMark.visible

        anchors.verticalCenter: averageMark.verticalCenter
        anchors.right: averageMark.left
        anchors.rightMargin: 15
        text: qsTr("Overall Score")
        font.pointSize: currentMarkLabel.font.pointSize
        color: averageMark.color
    }

    Canvas {
        id: canvas
        anchors.top: parent.top
        anchors.bottom: averageMark.top
        anchors.left: iterationLabel.right
        anchors.leftMargin: 5
        anchors.right: currentMarkLabel.left
        anchors.rightMargin: 5
    }

    Shape {
        id: targetHintShape

        visible: !hasValues

        width: 18
        height: 35
        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.verticalCenter: canvas.verticalCenter

        ShapePath {
            id: path
            fillColor: targetHint.color
            fillRule: ShapePath.WindingFill
            startX: targetHintShape.width / 2
            startY: 4
            PathLine { x: targetHintShape.width; y: 0 }
            PathLine { x: targetHintShape.width / 2; y: targetHintShape.height / 2 }
            PathLine { x: 0; y: 0 }
            PathLine { x: path.startX; y: path.startY }
        }
    }

    Label {
        id: targetHint

        visible: targetHintShape.visible

        anchors.horizontalCenter: targetHintShape.horizontalCenter
        anchors.top: targetHintShape.bottom
        anchors.topMargin: 5

        text: qsTr("Reference  Target of Singing")
        font.pointSize: 11
        font.underline: true
        font.bold: true
        color: Theme.secondaryDark.titleColor
    }
}
