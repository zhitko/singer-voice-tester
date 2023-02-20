import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

TrainingRecordForm {
    id: root
    objectName: Enum.pageTrainingRecord

    property bool startRecording: false
    property bool showOpenButton: false

    StackView.onActivated: {
        console.log("TrainingRecordForm.StackView.onActivated", root.startRecording)
        Bus.hideAllBottomActions()
        Bus.showOpenButton = showOpenButton

        if (root.startRecording === true) {
            recordButton.checked = true
        }
    }
}
