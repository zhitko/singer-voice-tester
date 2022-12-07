import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

RecordForm {
    id: root
    objectName: Enum.pageRecord

    property bool startRecording: false

    StackView.onActivated: {
        console.log("RecordForm.StackView.onActivated", root.startRecording)
        Bus.hideAllBottomActions()
        Bus.showOpenButton = true && Bus.canOpenButton
        Bus.showOpenTemplateButton = true

        if (root.startRecording === true) {
            recordButton.checked = true
        }
    }

    maleButton.onClicked: {
        Bus.isMale = true
    }

    femaleButton.onClicked: {
        Bus.isMale = false
    }
}
