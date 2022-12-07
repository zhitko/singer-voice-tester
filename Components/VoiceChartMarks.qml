import QtQuick 2.14

import "../App"

VoiceChartMarksForm {
    id: root

    Component.onCompleted: {
        showOctaves()
    }

    function showOctaves() {
        octavesMarksCategorisX.categories = Bus.getOctavesCategories()
        showOctavesMarks()
    }

    function showOctavesMarks() {
        console.log("VoiceChartMarks.showOctavesMarks")
        root.octavesMarksSeries.clear()

        let recordData = Bus.getPitchOcavesMetrics(true)
        console.log("VoiceChartMarks.showOctavesMarks recordData", recordData)
        let recordSeries = []
        for (let i in octavesMarksCategorisX.categories) {
            recordSeries.push(0)
        }
        if (!!recordData[0]) recordSeries[recordData[0]-1] = 5
        if (!!recordData[1]) recordSeries[recordData[1]-1] = 3
        if (!!recordData[2]) recordSeries[recordData[2]-1] = 3
        console.log("VoiceChartMarks.showOctavesMarks Record", recordSeries)
        root.octavesMarksSeries.append("Record", recordSeries)

        let templateData = Bus.getTemplateOcavesMetrics(true)
        console.log("VoiceChartMarks.showOctavesMarks templateData", templateData)
        let temlateSeries = []
        if (templateData.length !== 0) {
            for (let i in octavesMarksCategorisX.categories) {
                temlateSeries.push(0)
            }
            if (!!templateData[0]) temlateSeries[templateData[0]-1] = 5
            if (!!templateData[1]) temlateSeries[templateData[1]-1] = 3
            if (!!templateData[2]) temlateSeries[templateData[2]-1] = 3
            console.log("VoiceChartMarks.showOctavesMarks Template", temlateSeries)
        }
        root.octavesMarksSeries.append("Template", temlateSeries)
    }

}
