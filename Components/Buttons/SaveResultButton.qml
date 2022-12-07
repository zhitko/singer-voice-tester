import QtQuick 2.14

import "../../App"

SaveResultButtonForm {
    id: root

    button.onClicked: {
        console.log("Click save results button: ")

        Bus.saveResults()

        Bus.showSaveResultsButton = false
    }
}
