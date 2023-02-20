import QtQuick 2.14
import QtQuick.Controls 2.14

import "../FontAwesome"

ToolButton {
    id: recordButton
    checkable: true
    display: AbstractButton.IconOnly
    icon.source: "qrc:/Assets/Images/speech-icon.png"
    icon.height: recordButton.height * (hovered ? 0.65 : 0.6)
    icon.width: recordButton.width * (hovered ? 0.65 : 0.6)
    icon.color: "transparent"
}
