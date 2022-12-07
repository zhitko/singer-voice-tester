import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

HomeForm {
    id: root
    objectName: Enum.pageHome

    StackView.onActivated: {
        console.log("HomeForm.StackView.onActivated")
        Bus.reinitialize()
        Bus.hideAllBottomActions()
    }

    testButton.onClicked: {
        Bus.goRecord(Enum.modeTest, false)
    }

    trainingButton.onClicked: {
        Bus.goRecord(Enum.modeTraining, false)
    }
}
