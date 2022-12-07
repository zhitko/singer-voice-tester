import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtCharts 2.3

ChartView {
    id: root
    height: 50

    property alias octavesMarksSeries: octavesMarksSeries
    property alias octavesMarksCategorisX: octavesMarksCategorisX
    property alias octavesMarksCategorisY: octavesMarksCategorisY

    margins.bottom: 0
    margins.top: 0
    margins.left: 30
    margins.right: 30

    legend.visible: false

    BarSeries {
        id: octavesMarksSeries
        barWidth: 1
        axisX: BarCategoryAxis {
            id: octavesMarksCategorisX
            labelsFont.pointSize: 0
            visible: false
        }
        axisY: ValueAxis {
            id: octavesMarksCategorisY
            labelsFont.pointSize: 8
            max: 5
            min: 0
            tickCount: 2
            visible: false
        }
    }
}
