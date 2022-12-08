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

    Canvas {
        id: canvas
        width: height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
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
            startX: targetHintShape.width / 2; startY: 4
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

    Label {
        id: currentMark

        visible: hasValues

        anchors.left: canvas.right
        anchors.leftMargin: 20
        anchors.verticalCenter: canvas.verticalCenter

        text: "-"
        font.pointSize: 35
        color: Colors.green800
    }

    Label {
        id: currentMarkLabel

        visible: currentMark.visible

        anchors.bottom: currentMark.top
        anchors.left: currentMark.left
        text: qsTr("Current\nScore")
        font.pointSize: 14
        color: currentMark.color
    }

    Label {
        id: iteration

        visible: hasValues

        anchors.right: canvas.left
        anchors.rightMargin: currentMark.anchors.leftMargin
        anchors.verticalCenter: canvas.verticalCenter

        text: "-"
        font.pointSize: currentMark.font.pointSize
        color: Colors.indigo800
    }

    Label {
        visible: iteration.visible

        anchors.bottom: iteration.top
        anchors.right: iteration.right
        text: qsTr("Test Serial\nNumber")
        font.pointSize: currentMarkLabel.font.pointSize
        horizontalAlignment: "AlignRight"
        color: iteration.color
    }

    Label {
        id: averageMark

        visible: hasValues

        anchors.horizontalCenter: canvas.horizontalCenter
        anchors.top: canvas.bottom

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
}
