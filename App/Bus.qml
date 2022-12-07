pragma Singleton
import QtQuick 2.14

import intondemo.backend 1.0

Item {
    id: root

    property var stackView
    property var settings

    property bool showRecordButton: false
    property bool canRecordButton: true
    property bool showPlayButton: false
    property bool showSaveResultsButton: false
    property bool canPlayButton: true
    property bool showOpenButton: false
    property bool showOpenTemplateButton: false
    property bool canOpenButton: !backend.isMobile()
    property bool canOpenTemplateButton: true

    property string currentPage: ""

    property string recordPath: ""
    property string templatePath: ""
    property var results: ({})

    property var pointsHistory: []
    property var marksHistory: []

    property string applicationMode: Enum.modeTest

    property bool isMale: true

    Backend {
        id: backend
    }

    function getSettings() {
        console.log("Action.getSettings")
        return backend.getSettings()
    }

    function getSettingValue(id) {
        console.log("Action.getSettingValue")
        return backend.getSettingValue(id)
    }

    function getSettingsMap() {
        console.log("Action.getSettingsMap")
        let settings = getSettings()
        let settingsMap = {}

        settings.forEach(setting => {
            settingsMap[setting.key] = setting.value
        });

        return settingsMap
    }

    function setSettings(name, value) {
        console.log("Action.setSettings", name, value)
        return backend.setSettings(name, value)
    }

    function getSavedResults() {
        console.log("Action.getSavedResults")
        return backend.getSavedResults()
    }

    function saveResults() {
        console.log("Action.getSavedResults")
        return backend.saveResult(results)
    }

    function setResultItem(key, value) {
        console.log("Action.addResult", key, value)
        results[key] = value
    }

    /*---------------------------------------------------------
      History
      ---------------------------------------------------------*/
    function addPointToHistory(value) {
        root.pointsHistory.push(value)
    }

    function addMarkToHistory(value) {
        root.marksHistory.push(value)
    }

    function cleanPointHistory() {
        root.pointsHistory = []
    }

    function cleanMarkHistory() {
        root.marksHistory = []
    }

    function getPointHistory() {
        return root.pointsHistory
    }

    function getMarkHistory() {
        return root.marksHistory
    }

    function getMarkAvg() {
        return root.marksHistory.reduce((t, v) => { return t += v}) / root.marksHistory.length
    }

    function cleanHistory() {
        cleanPointHistory()
        cleanMarkHistory()
    }

    /*---------------------------------------------------------
      Actions
      ---------------------------------------------------------*/
    function setApplicationModePath(path) {
        if (root.applicationMode === Enum.modeTest) {
            setRecordPath(path)
        }

        if (root.applicationMode === Enum.modeTraining) {
            if (root.recordPath === "") {
                cleanHistory()
                setRecordPath(path)
            } else {
                setTemplatePath(path)
            }
        }
    }

    function setRecordPath(path) {
        root.recordPath = path
    }

    function setTemplatePath(path) {
        root.templatePath = path
    }

    function startRecord() {
        console.log("Action.startRecord")

        setApplicationModePath(backend.startStopRecordWaveFile())

        root.canRecordButton = false
        root.canPlayButton = false
        root.canOpenTemplateButton = false
        root.canOpenButton = false
    }

    function stopRecord() {
        console.log("Action.stopRecord")
        backend.startStopRecordWaveFile()

        stackView.pop()
        goApplicationModePage()

        root.canRecordButton = true
        root.canOpenTemplateButton = true
        root.canPlayButton = true
        root.canOpenButton = true && !backend.isMobile()
    }

    function playRecord(playing) {
        console.log("Action.playRecord : ", playing)
        if (root.recordPath !== "") {
            console.log("Try play file : ", root.recordPath)
            backend.playWaveFile(root.recordPath, playing)
        }
    }

    function openFileDialog() {
        console.log("Action.openFileDialog")
        let newPath = backend.openFileDialog()
        console.log("Action.openFileDialog: newPath = ", newPath)
        let isChanged = root.recordPath !== newPath
        console.log("Action.openFileDialog: isChanged = ", isChanged)

        if (isChanged) {
            setApplicationModePath(newPath)
            goApplicationModePage(true)
        }
    }

    function openTemplateFileDialog() {
        console.log("Action.openTemplateFileDialog")
        let newPath = backend.openFileDialog()
        console.log("Action.openTemplateFileDialog: newPath = ", newPath)
        let isChanged = root.templatePath !== newPath
        console.log("Action.openTemplateFileDialog: isChanged = ", isChanged)
        root.templatePath = newPath

        if (isChanged) {
            goApplicationModePage(true)
        }
    }

    /*---------------------------------------------------------
      Data processing
      ---------------------------------------------------------*/

    function getRecordLength() {
        if (root.recordPath !== "") {
            return backend.getWaveLength(root.recordPath)
        } else {
            return 0
        }
    }

    function getWaveData() {
        if (root.recordPath !== "") {
            return backend.getWaveData(root.recordPath)
        } else {
            return []
        }
    }

    function getSegmentsByIntensity() {
        if (root.recordPath !== "") {
            return backend.getSegmentsByIntensity(root.recordPath)
        } else {
            return []
        }
    }

    function getPitchData() {
        if (root.recordPath !== "") {
            return backend.getPitchDataCutted(root.recordPath, Bus.isMale)
        } else {
            return []
        }
    }

    function getFullPitchData() {
        if (root.recordPath !== "") {
            return backend.getPitchFullData(root.recordPath, Bus.isMale)
        } else {
            return []
        }
    }

    function getPitchMinMax() {
        return backend.getPitchMinMax(Bus.isMale)
    }

    function getOctavesData() {
        if (root.recordPath !== "") {
            return backend.getPitchFrequencySegmentsCount(root.recordPath, Bus.isMale, Bus.applicationMode === Enum.modeTraining)
        } else {
            return []
        }
    }

    function getTemplateOctavesData() {
        if (root.templatePath !== "") {
            return backend.getTemplatePitchFrequencySegmentsCount(root.templatePath, Bus.isMale, Bus.applicationMode === Enum.modeTraining)
        } else {
            return []
        }
    }

    function getOctavesCategories() {
        return backend.getOctavesCategories(Bus.isMale, Bus.applicationMode === Enum.modeTraining)
    }

    function getOctavesOptimazedCategories() {
        return backend.getOctavesOptimazedCategories(Bus.isMale)
    }

    function getSingerMetrics() {
        if (root.recordPath !== "") {
            return backend.getSingerMetrics(root.recordPath, Bus.isMale)
        } else {
            return []
        }
    }

    function getTemplateSingerMetrics() {
        if (root.templatePath !== "") {
            return backend.getTemplateSingerMetrics(root.templatePath, Bus.isMale)
        } else {
            return []
        }
    }

    function getFullOctavesData() {
        if (root.recordPath !== "") {
            return backend.getPitchFrequencyCount(root.recordPath, Bus.isMale)
        } else {
            return []
        }
    }

    function getFullTemplateOctavesData() {
        if (root.templatePath !== "") {
            return backend.getTemplatePitchFrequencyCount(root.templatePath, Bus.isMale)
        } else {
            return []
        }
    }

    function getDerivativeData(isFull) {
        if (root.recordPath !== "") {
            return backend.getPitchDerivativeCount(root.recordPath, Bus.isMale, isFull)
        } else {
            return []
        }
    }

    function getTemplateDerivativeData(isFull) {
        if (root.templatePath !== "") {
            return backend.getTemplatePitchDerivativeCount(root.templatePath, Bus.isMale, isFull)
        } else {
            return []
        }
    }

    function getPitchOcavesMetrics(cutted) {
        if (root.recordPath !== "") {
            return backend.getPitchOcavesMetrics(root.recordPath, Bus.isMale, cutted, Bus.applicationMode === Enum.modeTraining)
        } else {
            return []
        }
    }

    function getTemplateOcavesMetrics(cutted) {
        if (root.templatePath !== "") {
            return backend.getTemplateOcavesMetrics(root.templatePath, Bus.isMale, cutted, Bus.applicationMode === Enum.modeTraining)
        } else {
            return []
        }
    }

    /*---------------------------------------------------------
      Navigation
      ---------------------------------------------------------*/

    function isPage(page) {
        return currentPage === page
    }

    function goToPage(page, params = {}, force = false) {
        console.log("Bus.goToPage stackView.depth: ", stackView.depth)
        if (currentPage !== page || force) {
            currentPage = page
            stackView.push(page, params)
            console.warn("Bus.goToPage currentPage: ", currentPage)
            validatePage()
        }
    }

    function goBack() {
        if (stackView.depth > 1)
        {
            stackView.pop()
            currentPage = stackView.currentItem.objectName
            console.warn("Bus.goBack currentPage: ", currentPage)
            validatePage()
        }
    }

    function validatePage() {
        if (!currentPage) {
            console.warn("Current page do not have objectName: ", stackView.currentItem)
        }
    }

    function isHomePage() {
        return isPage(Enum.pageHome)
    }

    function goHome() {
        goToPage(Enum.pageHome)
    }

    function isRecordingPage() {
        return isPage(Enum.pageRecord)
    }

    function goRecording() {
        stackView.pop()
        goToPage(Enum.pageRecord, {showVoiceSelect: false}, true)
    }

    function goApplicationModePage(force = false) {
        if (applicationMode === Enum.modeTest)
            goTest(force)
        if (applicationMode === Enum.modeTraining)
            goTraining(force)
    }

    function isTestPage() {
        return isPage(Enum.pageTest)
    }

    function goTest(force = false) {
        goToPage(Enum.pageTest, {}, force)
    }

    function isTrainingPage() {
        return isPage(Enum.pageTraining)
    }

    function goTraining(force = false) {
        goToPage(Enum.pageTraining, {}, force)
    }

    function isSettingsPage() {
        return isPage(Enum.pageSettings)
    }

    function goSettings() {
        goToPage(Enum.pageSettings)
    }

    function isRecordPage() {
        return isPage(Enum.pageRecord)
    }

    function goRecord(mode, startRecording) {
        root.applicationMode = mode || root.applicationMode
        goToPage(Enum.pageRecord, {startRecording: startRecording, showVoiceSelect: applicationMode === Enum.modeTest})
    }

    function isResultsPage() {
        return isPage(Enum.pageResults)
    }

    function goResults() {
        goToPage(Enum.pageResults)
    }

    function isPolicyPage() {
        return isPage(Enum.pagePolicy)
    }

    function goPolicy() {
        goToPage(Enum.pagePolicy)
    }

    /*---------------------------------------------------------
      Helpers
      ---------------------------------------------------------*/

    function hideAllBottomActions() {
        root.showRecordButton = false
        root.showPlayButton = false
        root.showOpenButton = false
        root.showSaveResultsButton = false
    }

    function getTimer(interval, parent) {
        let timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", parent)
        timer.interval = interval
        return timer
    }

    function reinitialize() {
        console.log("Bus::reinitialize")
        root.recordPath = ""
        root.templatePath = ""
        backend.reinitialize()
    }

}
