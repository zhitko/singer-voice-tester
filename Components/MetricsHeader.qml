import QtQuick 2.4

import "../App"

MetricsHeaderForm {
    id: root

    Component.onCompleted: {
        showOctavesMetrics()
    }

    function showOctavesMetrics() {
        console.log("PitchForm.showOctavesMetrics")

        const n = 1;
        let recordData = Bus.getPitchOcavesMetrics(true)
        let templateData = Bus.getTemplateOcavesMetrics(true)

        const template = qsTr("Pitch: %1 \t Range: %2");

        console.log("PitchForm.showOctavesMetrics recordData ", recordData)
        console.log("PitchForm.showOctavesMetrics recordData[7] ", recordData[7])
        root.firstValue1.text = qsTr("Pitch: %1")
            .arg(recordData[8].toFixed(n))
        root.firstValue2.text = qsTr("Range: %1")
            .arg(recordData[4].toFixed(n))

        if (templateData.length !== 0) {
            console.log("PitchForm.showOctavesMetrics templateData ", templateData)
            console.log("PitchForm.showOctavesMetrics templateData[7] ", templateData[7])
            root.secondValue1.text = qsTr("Pitch: %1")
                .arg(templateData[8].toFixed(n))
            root.secondValue2.text = qsTr("Range: %1")
                .arg(templateData[4].toFixed(n))
        }

        Bus.setResultItem("5. C(F0)", recordData[8].toFixed(n))
        Bus.setResultItem("4. B(F0)", recordData[4].toFixed(n))
        Bus.setResultItem("3. A(F0)", recordData[6].toFixed(n))
    }

}
