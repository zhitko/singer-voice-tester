import QtQuick 2.4

import "../App"
import "Material"

VoiceHeaderForm {
    id: root

    Component.onCompleted: {
        showSingerMetrics()
    }

    function showSingerMetrics() {
        let voices = []
        if (Bus.isMale) {
            voices = [root.tenor,
                      root.baritone,
                      root.bass]
        } else {
            voices = [root.contralto,
                      root.mezzosoprano,
                      root.soprano]
        }

        let templateMetrics = Bus.getTemplateSingerMetrics()
        if (templateMetrics.length !== 0) {
            console.log("VoiceHeaderForm:templateMetrics: ", templateMetrics)
            root.showSecond = true
            if (Bus.isMale) {
                root.tenor.value2 = templateMetrics[0]
                root.baritone.value2 = templateMetrics[1]
                root.bass.value2 = templateMetrics[2]
            } else {
                root.contralto.value2 = templateMetrics[0]
                root.mezzosoprano.value2 = templateMetrics[1]
                root.soprano.value2 = templateMetrics[2]
            }

            voices[templateMetrics[3]].secondTitle.color = Theme.secondaryLight.color
            voices[templateMetrics[3]].label.color = Theme.secondaryLight.textColor
        }

        let recordMetrics = Bus.getSingerMetrics(Bus.isMale)
        console.log("VoiceHeaderForm:recordMetrics: ", recordMetrics)
        if (Bus.isMale) {
            root.tenor.value1 = recordMetrics[0]
            root.baritone.value1 = recordMetrics[1]
            root.bass.value1 = recordMetrics[2]
        } else {
            root.contralto.value1 = recordMetrics[0]
            root.mezzosoprano.value1 = recordMetrics[1]
            root.soprano.value1 = recordMetrics[2]
        }

        voices[recordMetrics[3]].firstTitle.color = Theme.primaryLight.color
        voices[recordMetrics[3]].label.color = Theme.primaryLight.textColor
    }
}
