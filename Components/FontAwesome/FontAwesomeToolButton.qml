import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
    id: root

    property alias button: button
    property alias icon: awesome.icon
    property alias font: awesome.font
    property alias color: awesome.color
    property alias type: awesome.type
    property alias hintText: hint.text
    property alias hintColor: hint.color

    property int baseSize: 22

    width: 32
    height: 32

    FontAwesomeIcon {
        id: awesome
        font.pointSize: button.hovered ? baseSize + 4 : baseSize
        anchors.centerIn: parent
    }

    ToolButton {
        id: button
        anchors.fill: parent
    }

    Label {
        id: hint

        anchors.top: button.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: button.horizontalCenter

        visible: button.hovered
    }
}
