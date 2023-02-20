import QtQuick 2.14

Item {
    id: root

    property string text: ""
    property string type: FontAwesome.solid
    property string icon: FontAwesome.icons.faQuestionCircle
    property string color: "white"
    property string iconColor: "white"
    property alias iconPointSize: awesomeIcon.font.pointSize

    FontAwesomeIcon {
        id: awesomeIcon
        type: root.type
        icon: root.icon
        anchors.left: parent.left
        anchors.leftMargin: 10
        color: root.iconColor
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        text: root.text
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: awesomeIcon.verticalCenter
        anchors.left: awesomeIcon.right
        anchors.leftMargin: 10
        color: root.color
    }
}
