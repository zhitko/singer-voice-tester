import QtQuick 2.14
import QtQuick.Controls 2.14
import QtCharts 2.14

import "../../Components"
import "../../App"

TestForm {
    id: root
    objectName: Enum.pageTest

    StackView.onActivated: {
        console.log("PitchForm.StackView.onActivated")
        Bus.hideAllBottomActions()
        Bus.showPlayButton = Bus.recordPath !== ""
        Bus.showSaveResultsButton = Bus.recordPath !== ""
        Bus.showRecordButton = true
        Bus.showOpenButton = true && Bus.canOpenButton

        loadSettings()

        initializeData()
    }

    function initializeData() {
    }

    function loadSettings() {
        let settings = Bus.getSettingsMap()
    }
}
