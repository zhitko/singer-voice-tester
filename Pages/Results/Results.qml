import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

ResultsForm {
    id: root
    objectName: Enum.pageResults

    StackView.onActivated: {
        console.log("RecordForm.StackView.onActivated")
        Bus.hideAllBottomActions()

        root.results = Bus.getSavedResults()
    }
}
