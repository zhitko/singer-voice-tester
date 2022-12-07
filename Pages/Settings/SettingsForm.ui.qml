import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components"

Page {
    id: root
    title: qsTr("Settings")

    property alias settingsModel: settingsModel
    property alias showAdvancedInput: showAdvancedInput
    property bool showAdvanced: false

    anchors.fill: parent

    ListModel {
        id: settingsModel
    }    

    Text {
        text: qsTr("Show advanced")
        font.pointSize: 10
        anchors.right: showAdvancedInput.left
        anchors.verticalCenter: showAdvancedInput.verticalCenter
    }
    Switch {
        id: showAdvancedInput
        anchors.top: parent.top
        anchors.right: parent.right
        font.pointSize: 10
    }

    ListView {
        id: list
        anchors.top: showAdvancedInput.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 10
        model: settingsModel
        spacing: 20
        delegate: SettingItem {
            width: list.width
            changed: settingChanged
        }
    }
}
