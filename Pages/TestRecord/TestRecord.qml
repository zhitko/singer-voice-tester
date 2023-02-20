import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

TestRecordForm {
    id: root
    objectName: Enum.pageTestRecord

    property bool startRecording: false
    property bool showOpenButton: false

    StackView.onActivated: {
        console.log("TestRecordForm.StackView.onActivated", root.startRecording)
        Bus.hideAllBottomActions()
        Bus.showOpenButton = showOpenButton

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
