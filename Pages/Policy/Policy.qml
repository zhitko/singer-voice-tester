import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

PolicyForm {
    objectName: Enum.pagePolicy

    StackView.onActivated: {
        console.log("PolicyForm.StackView.onActivated")
        Bus.hideAllBottomActions()
    }
}
