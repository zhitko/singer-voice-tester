pragma Singleton
import QtQuick 2.14

Item {
    readonly property string pageHome: "../Pages/Home/Home.qml"
    readonly property string pageSettings: "../Pages/Settings/Settings.qml"
    readonly property string pageRecord: "../Pages/Record/Record.qml"
    readonly property string pageRecording: "../Pages/Recording/Recording.qml"
    readonly property string pageResults: "../Pages/Results/Results.qml"
    readonly property string pagePolicy: "../Pages/Policy/Policy.qml"

    readonly property string pageTest: "../Pages/Test/Test.qml"
    readonly property string pageTraining: "../Pages/Training/Training.qml"


    readonly property string modeTest: "mode_test"
    readonly property string modeTraining: "mode_training"
}
