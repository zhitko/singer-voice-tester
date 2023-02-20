import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../../App"
import "../../Components/"
import "../../Components/Buttons"
import "../../Components/FontAwesome"

Page {
    id: root
    title: qsTr("")

    FilesList {
        visible: !recordButton.checked && showFiles
        showAddButton: true
        anchors.fill: parent
    }
}
