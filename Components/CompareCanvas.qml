import QtQuick 2.14

import "../App"
import "Material"

CompareCanvasForm {
    id: root

    property double limitX: 10
    property double limitY: 10
    property var recordData: []
    property var templateData: []

    Component.onCompleted: {
        loadSettings()
        loadData()
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

    function drawResultPoints(callback) {
        console.log("CompareCanvasForm.drawResultPoints")

        if (templateData.length !== 0) {
            root.hasValues = true

            let x = templateData[4] - recordData[4]; // Diapason
            let y = templateData[8] - recordData[8]; // Pitch
            console.log("CompareCanvasForm.drawResultPoints x ", x)
            console.log("CompareCanvasForm.drawResultPoints y ", y)            

            callback(x, y)
        }
    }

    function storePointHistory(callback) {
        return function(x, y) {
            console.log("CompareCanvasForm.storePointHistory x ", x)
            console.log("CompareCanvasForm.storePointHistory y ", y)
            Bus.addPointToHistory({ x: x, y: y })
            callback(x, y)
        }
    }

    function applyLimit(callback) {
        function limitMax(value, limit) {
            if (value > limit) return limit
            else if (value < -limit) return -limit
            else return value
        }

        return function(x, y) {
            console.log("CompareCanvasForm.applyLimit x: ", x)
            console.log("CompareCanvasForm.applyLimit y: ", y)

            let nx = limitMax(x, limitX) / limitX
            let ny = limitMax(y, limitY) / limitY * -1

            console.log("CompareCanvasForm.applyLimit nx: ", nx)
            console.log("CompareCanvasForm.applyLimit ny: ", ny)

            callback(nx, ny)
        }
    }

    function checkOutside(callback) {
        return function(x, y) {
            console.log("CompareCanvasForm.checkOutside x: ", x)
            console.log("CompareCanvasForm.checkOutside y: ", y)

            let c = 0.92
            let t = 2 * c / ( Math.sqrt(4*(x*x + y*y)*c))
            let xx = x * t
            let yy = y * t

            console.log("CompareCanvasForm.applyLimit xx: ", xx)
            console.log("CompareCanvasForm.applyLimit yy: ", yy)

            let outside = Math.abs(xx) < Math.abs(x)

            console.log("CompareCanvasForm.applyLimit outside: ", outside)

            if (outside) {
                callback(xx, yy)
            } else {
                callback(x, y)
            }
        }
    }

    function preparePoint(ctx, size, lineWidth, fillColor, strokeColor, centerX, centerY) {
        return function draw(x, y) {
            ctx.beginPath()
            ctx.arc(x*centerX + centerX, y*centerY + centerY, size, 0, 2 * Math.PI, false)
            ctx.fillStyle = fillColor
            ctx.fill()
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = strokeColor
            ctx.stroke()
        }
    }

    function drawMark(callback) {
        return function(x, y) {
            console.log("CompareCanvasForm.setMark x: ", x)
            console.log("CompareCanvasForm.setMark y: ", y)
            callback(x, y)

            let r = Math.sqrt(x*x + y*y)
            if (r > 1) r = 1
            const mark = 10 - r * 10
            console.log("CompareCanvasForm.setMark mark: ", mark)
            root.currentMark.text = mark.toFixed(0)
            Bus.addMarkToHistory(mark)
            root.iteration.text = Bus.getMarkHistory().length
            const averageMarkValue = Bus.getMarkAvg().toFixed(0)
            root.averageMark.text = averageMarkValue
            Bus.setResultItem("3. Overall Score", averageMarkValue)
            Bus.setResultItem("4. Tests Number", root.iteration.text)
        }
    }

    canvas.onPaint: {
        console.log("CompareCanvasForm:onPaint")
        var ctx = canvas.getContext("2d")

        const centerX = canvas.canvasSize.width/2
        const centerY = canvas.canvasSize.height/2
        const partSize = canvas.canvasSize.height/200
        const centerPointSize = partSize * 10
        const previousPointSize = partSize * 4
        const resultPointSize = partSize * 6

        var gradient = ctx.createRadialGradient(centerX, centerY, 0,
                                                centerX, centerY, centerX)
        gradient.addColorStop(0.25, Theme.secondaryDark.color)
        gradient.addColorStop(0.9, Theme.secondaryLight.color)
        gradient.addColorStop(1, Colors.transparent)
        ctx.fillStyle = gradient;
        ctx.rect(0, 0, canvas.canvasSize.width, canvas.canvasSize.height)
        ctx.fill()

        ctx.beginPath()
        ctx.arc(centerX, centerY, centerX - 6, 0, 2 * Math.PI, false)
        ctx.lineWidth = 12
        ctx.strokeStyle = Colors.red800
        ctx.stroke()

        preparePoint(ctx, centerPointSize, 2, Theme.primaryLight.color, Theme.primary.color, centerX, centerY)(0,0)

        let previousPoint = preparePoint(ctx, previousPointSize, 2, Colors.white, Colors.white, centerX, centerY)
        drawPreviousPoints(applyLimit(checkOutside(previousPoint)))

        let resultPoint = preparePoint(ctx, resultPointSize, 2, Theme.secondaryDark.color, Colors.white, centerX, centerY)
        drawResultPoints(storePointHistory(applyLimit(drawMark(checkOutside(resultPoint)))))
    }
}
