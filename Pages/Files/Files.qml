import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

FilesForm {
    id: root
    objectName: Enum.pageFiles

    StackView.onActivated: {
        console.log("FilesForm.StackView.onActivated")
        Bus.hideAllBottomActions()
        Bus.showOpenButton = true
    }
}
