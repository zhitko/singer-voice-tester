import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.14

import "../App"
import "Material"

ColumnLayout {
    Image {
        id: piano
        source: Bus.isMale ? "qrc:///Assets/Images/piano-male.png" : "qrc:///Assets/Images/piano-female.png"
        Layout.preferredHeight: 80
        Layout.fillWidth: true
    }
    RowLayout {
        Layout.fillWidth: true
        Rectangle {
            color: Theme.primary.color
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            Label {
                anchors.centerIn: parent
                text: Bus.isMale ? qsTr("Major") : qsTr("Minor")
                color: Theme.primary.textColor
            }
        }
        Rectangle {
            color: Theme.primary.color
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            Label {
                anchors.centerIn: parent
                text: Bus.isMale ? qsTr("Minor") : qsTr("First")
                color: Theme.primary.textColor
            }
        }
        Rectangle {
            color: Theme.primary.color
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            Label {
                anchors.centerIn: parent
                text: Bus.isMale ? qsTr("First") : qsTr("Second")
                color: Theme.primary.textColor
            }
        }
    }
}
