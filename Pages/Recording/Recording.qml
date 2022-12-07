import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

RecordingForm {
    id: root
    objectName: Enum.pageRecording

    StackView.onActivated: {
        console.log("RecordingForm.StackView.onActivated")
        Bus.hideAllBottomActions()
    }
}
