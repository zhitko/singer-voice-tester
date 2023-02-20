import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

ColumnLayout {

    property var changed: null

    Text {
        id: label
        text: name
        font.bold: true
        font.pointSize: 15
        Layout.minimumWidth: 250
        wrapMode: Text.Wrap
    }

    TextField {
        id: input
        text: value
        font.pointSize: 15
        Layout.fillWidth: true
        visible: type !== "bool" && type !== "double_list"
        enabled: editable
        onTextChanged: {
            input.text = changed(key, input.text)
        }
    }

    TextArea {
        id: inputArea
        Layout.fillWidth: true
        text: value
        font.pointSize: 15
        wrapMode: "Wrap"
        width: 10
        visible: type === "double_list"
        enabled: editable
        onTextChanged: {
            input.text = changed(key, inputArea.text)
        }
    }

    Switch {
        id: inputSwitch
        font.pointSize: 15
        checked: value === "true"
        visible: type === "bool"
        enabled: editable
        onCheckedChanged: {
            changed(key, inputSwitch.checked)
        }
    }

    Text {
        id: descriptionHint
        text: description
        font.pointSize: 10
        font.italic: true
        wrapMode: Text.Wrap
    }
}
