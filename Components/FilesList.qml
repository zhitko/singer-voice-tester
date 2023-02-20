import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "FontAwesome"
import "Material"
import "../App"

Item {
    property bool enabled: true
    property bool showAddButton: true

    Component.onCompleted: {
        loadFiles()
    }

    function loadFiles() {
        let files = Bus.getExamples()
        console.log("FilesList loadFiles", root.files)
        listModel.clear()
        for(let i in files) {
            console.log("FilesList loadFiles", files[i].name)
            console.log("FilesList loadFiles", files[i].path)
            listModel.append(
                {
                    "name": files[i].name,
                    "value": files[i].path
                }
            )
        }
    }

    ListModel {
        id: listModel
    }

    Rectangle {
        id: line

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 10
        anchors.right: parent.right
        anchors.rightMargin: anchors.leftMargin
        height: 4

        color: Theme.primary.color
    }

    Label {
        id: title
        text: qsTr("Or open example file:")

        anchors.top: line.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ListView {
        id: list

        anchors.top: title.bottom
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

        model: listModel
        spacing: 5
        enabled: enabled
        delegate: ItemDelegate {
            width: list.width
            onClicked: {
                console.log("FilesList onClicked: ", value)
                Bus.setApplicationModePath(value)
                Bus.stackView.pop()
                Bus.goApplicationModePage(true)
            }

            FontAwesomeIconText {
                icon: FontAwesome.icons.faFileAlt
                text: name
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.backgound.textColor
                iconColor: Theme.backgound.textColor
                iconPointSize: hovered ? 26 : 22
            }
        }
    }

    FontAwesomeToolButton {
        id: addExample

        hintText: qsTr("Add an example")
        hintColor: Theme.backgound.textColor

        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        visible: showAddButton
        baseSize: 32

        type: FontAwesome.solid
        icon: FontAwesome.icons.faPlusCircle
        color: Theme.primary.color
        button.onClicked: Bus.goAddExample()
    }
}
