import QtQuick 2.14

import "../../App"

OpenFileButtonForm {
    id: root

    button.onClicked: {
        console.log("Click open file button")
        Bus.openFileDialog()

        var today = new Date()
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds()
        var dateTime = date+' '+time
        Bus.setResultItem("1. Recording started", dateTime)
        Bus.setResultItem("2. End of the recording", "")
    }
}
