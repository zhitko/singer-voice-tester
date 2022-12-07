import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Styles 1.4
import QtCharts 2.3
import QtQuick.Layouts 1.14

ChartView {
    id: octaves

    legend.visible: false

    margins.bottom: 0
    margins.top: 0
    margins.left: 0
    margins.right: 30

    property alias octavesSeries: octavesSeries
    property alias octavesCategorisX: octavesCategorisX
    property alias octavesCategorisY: octavesCategorisY

    BarSeries {
        id: octavesSeries
        barWidth: 1
        axisX: BarCategoryAxis {
            id: octavesCategorisX
            labelsVisible: false
        }
        axisY: ValueAxis {
            id: octavesCategorisY
            max: 1
            min: 0
            labelsVisible: false
        }
    }
}
