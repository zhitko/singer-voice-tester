import QtQuick 2.4

import "../../App"

AnimatedRecordButtonForm {
    id: root

    property int frame: 0

    Timer {
        id: timer
        interval: 500;
        repeat: true
        onTriggered: {
            root.icon.source = "qrc:/Assets/Images/speech-active-%1-icon.png".arg(frame)
            frame ++
            if (frame > 3) frame = 0
        }
    }

    function getDatetime() {
        var today = new Date()
        var date = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate()
        var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds()
        return date+' '+time
    }

    function startRecording() {
        var dateTime = getDatetime()

        Bus.startRecord()
        timer.start()
        root.icon.source = "qrc:/Assets/Images/speech-active-0-icon.png"
        Bus.setResultItem("1. Recording started", dateTime)
    }

    function stopRecording() {
        var dateTime = getDatetime()

        Bus.stopRecord()
        timer.stop()
        root.icon.source = "qrc:/Assets/Images/speech-icon.png"
        Bus.setResultItem("2. End of the recording", dateTime)
    }

    onCheckedChanged: {
        if (checked) {
            startRecording()
        } else {
            stopRecording()
        }
    }
}
