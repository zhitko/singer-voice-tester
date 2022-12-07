import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.14

import "../App"
import "Material"

ColumnLayout {
    Image {
        id: piano
        source: "qrc:///Assets/Images/piano.png"
        Layout.preferredHeight: 60
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
                text: qsTr("Major")
                color: Theme.primary.textColor
            }
        }
        Rectangle {
            color: Theme.primary.color
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            Label {
                anchors.centerIn: parent
                text: qsTr("Minor")
                color: Theme.primary.textColor
            }
        }
        Rectangle {
            color: Theme.primary.color
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            Label {
                anchors.centerIn: parent
                text: qsTr("First")
                color: Theme.primary.textColor
            }
        }
        Rectangle {
            color: Theme.primary.color
            Layout.fillWidth: true
            Layout.preferredHeight: 20
            Label {
                anchors.centerIn: parent
                text: qsTr("Second")
                color: Theme.primary.textColor
            }
        }
    }
}
