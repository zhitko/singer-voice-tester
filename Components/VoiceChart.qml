import QtQuick 2.14
import QtQuick.Controls 2.14
import QtCharts 2.14

import "../App"
import "Material"

VoiceChartForm {
    id: root

    Component.onCompleted: {
        showOctaves()
    }

    function showOctaves() {
        console.log("VoiceChartForm.showOctaves: ", Bus.isMale)

        root.octavesSeries.clear()

        let octavesCategories = Bus.getOctavesCategories()
        console.log("VoiceChartForm.onCompleted octavesCategories: ", octavesCategories)
        octavesCategorisX.categories = octavesCategories

        let max1 = showOctavesData(Bus.getOctavesData(), Theme.primaryLight.color)
        let max2 = showOctavesData(Bus.getTemplateOctavesData(), Theme.secondaryLight.color)

        octavesCategorisY.max = max1 > max2 ? max1 : max2
    }

    function showOctavesData(data, color) {
        console.log("VoiceChartForm.showOctaves", data)

        let octavesData = []

        if (data.length === 0) return 0;
        let max = 0
        for (let i=0; i< data.length - 1; i++) {
            console.log("value: ", data[i])
            octavesData.push(data[i])
            if (data[i] > max) max = data[i]
        }
        console.log("max", max)

        let barSet = octavesSeries.append("VoiceChartForm.Record", octavesData)
        barSet.color = color

        return max
    }
}
