import QtQuick 2.14

import "../App"
import "Material"

CompareCanvasForm {
    id: root

    property double limitX: 10
    property double limitY: 10
    property var recordData: []
    property var templateData: []
    property var currentPoint: ({})

    Component.onCompleted: {
        loadSettings()
        loadData()

        root.currentPoint = calculateMark()
        Bus.addPointToHistory(root.currentPoint)
        drawMark()
    }

    function loadSettings() {
        console.log("CompareCanvasForm.loadSettings")
        limitX = Bus.getSettingValue("CompareMaxX")
        limitY = Bus.getSettingValue("CompareMaxY")
        console.log("CompareCanvasForm.loadSettings limitX ", limitX)
        console.log("CompareCanvasForm.loadSettings limitY ", limitY)
    }

    function loadData() {
        console.log("CompareCanvasForm.loadData")
        recordData = Bus.getPitchOcavesMetrics(true)
        templateData = Bus.getTemplateOcavesMetrics(true)
        console.log("CompareCanvasForm.loadData recordData ", recordData)
        console.log("CompareCanvasForm.loadData templateData ", templateData)
    }

    function drawPreviousPoints(callback) {
        console.log("CompareCanvasForm.drawPreviousPoints: ", Bus.getPointHistory())
        Bus.getPointHistory().forEach(point => {
            console.log("CompareCanvasForm.drawPreviousPoints point: ", point)
            callback(point.x, point.y)
        })
    }

    function preparePoint(ctx, size, lineWidth, fillColor, strokeColor, centerX, centerY, minSize) {
        return function draw(x, y) {
            ctx.beginPath()
            ctx.arc(x*minSize + centerX, y*minSize + centerY, size, 0, 2 * Math.PI, false)
            ctx.fillStyle = fillColor
            ctx.fill()
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = strokeColor
            ctx.stroke()
        }
    }

    function calculateMark() {
        function limitMax(value, limit) {
            if (value > limit) return limit
            else if (value < -limit) return -limit
            else return value
        }

        if (templateData.length !== 0) {
            root.hasValues = true

            let x = templateData[4] - recordData[4]; // Range
            let y = templateData[8] - recordData[8]; // Pitch
            console.log("CompareCanvasForm.calculateMark x ", x)
            console.log("CompareCanvasForm.calculateMark y ", y)

            let nx = limitMax(x, limitX) / limitX
            let ny = limitMax(y, limitY) / limitY

            console.log("CompareCanvasForm.calculateMark nx: ", nx)
            console.log("CompareCanvasForm.calculateMark ny: ", ny)

            let m = Math.sqrt (1 / (x*x+y*y));
            let xx = x * m
            let yy = y * m

            console.log("CompareCanvasForm.applyLimit xx: ", xx)
            console.log("CompareCanvasForm.applyLimit yy: ", yy)

            let outside = Math.abs(xx) < Math.abs(x)

            console.log("CompareCanvasForm.applyLimit outside: ", outside)

            if (outside) {
                return { x: xx, y: yy }
            } else {
                return { x: x, y: y }
            }
        }
    }

    function drawMark() {
        root.currentMark.text = Bus.getMarkHistoryLastElement().toFixed(0)
        root.iteration.text = Bus.getMarkHistory().length
        root.averageMark.text = Bus.getMarkAvg().toFixed(0)
        Bus.setResultItem("3. Overall Score", root.averageMark.text)
        Bus.setResultItem("4. Tests Number", root.iteration.text)
    }

    canvas.onPaint: {
        console.log("CompareCanvasForm:onPaint")
        var ctx = canvas.getContext("2d")

        const centerX = canvas.canvasSize.width/2
        const centerY = canvas.canvasSize.height/2
        const minSize = centerX < centerY ? centerX : centerY
        const partSize = minSize/100
        const redLineSize = partSize * 10
        const centerPointSize = partSize * 8
        const previousPointSize = partSize * 4
        const resultPointSize = partSize * 6

        var gradient = ctx.createRadialGradient(centerX, centerY, 0,
                                                centerX, centerY, minSize)
        gradient.addColorStop(0.25, Theme.secondaryDark.color)
        gradient.addColorStop(0.9, Theme.secondaryLight.color)
        gradient.addColorStop(1, Colors.transparent)
        ctx.fillStyle = gradient;
        ctx.rect(0, 0, canvas.canvasSize.width, canvas.canvasSize.height)
        ctx.fill()

        ctx.beginPath()
        ctx.arc(centerX, centerY, minSize - redLineSize/2, 0, 2 * Math.PI, false)
        ctx.lineWidth = redLineSize
        ctx.strokeStyle = Colors.red800
        ctx.stroke()

        const minSizeForPoints = minSize - redLineSize/2

        preparePoint(ctx, centerPointSize, 2,
                     Theme.primaryLight.color, Theme.primary.color,
                     centerX, centerY, minSizeForPoints)(0,0)

        let previousPoint = preparePoint(
            ctx, previousPointSize, 2,
            Colors.white, Colors.white,
            centerX, centerY, minSizeForPoints
        )
        drawPreviousPoints(previousPoint)

        let resultPoint = preparePoint(
            ctx, resultPointSize, 2,
            Theme.secondaryDark.color,
            Colors.white, centerX, centerY, minSizeForPoints
        )
        resultPoint(root.currentPoint.x, root.currentPoint.y)
    }
}
