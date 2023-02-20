import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

AddExampleForm {
    id: root
    objectName: Enum.pageTestRecord
    property bool fileRecorded: false
    property string filePath: ""

    StackView.onActivated: {
        console.log("AddExample onActivated")
        Bus.hideAllBottomActions()
    }

    recordButton.onRecordingStarted: (path) => {
        console.log("AddExample onRecordingStarted: ", path)
    }

    recordButton.onRecordingStopped: (path) => {
        console.log("AddExample onRecordingStopped: ", path)
        root.filePath = path
        var today = new Date()
        root.fileName = "%1-%2-%3-%4-%5-%6"
            .arg(today.getFullYear())
            .arg(today.getMonth()+1)
            .arg(today.getDate())
            .arg(today.getHours())
            .arg(today.getMinutes())
            .arg(today.getSeconds())
        root.fileRecorded = true
    }

    saveButton.button.onClicked: {
        console.log("AddExample saveButtonAction")
        if (root.fileName.trim().length === 0) return

        Bus.copyToExamples(filePath, root.fileName.trim())
        Bus.goBack()
    }
}
