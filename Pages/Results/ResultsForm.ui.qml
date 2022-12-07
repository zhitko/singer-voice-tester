import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

import "../../App"

Page {
    id: root
    title: qsTr("Results")

    property string results: ""

    ScrollView {
        id: scrollView
        padding: 10
        contentHeight: resultValue.height
        anchors.fill: parent

        Label {
            id: resultValue
            text: root.results
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

