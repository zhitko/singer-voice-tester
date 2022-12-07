import QtQuick 2.4
import QtQuick.Controls 2.14

import "./Material"

ToolButton {
    id: button

    property int active: 2
    property string primaryActiveColor: Theme.primary.color
    property string primaryHoverColor: Theme.primaryLight.color
    property string primaryPressColor: Theme.primaryDark.color
    property string secondaryActiveColor: Theme.secondary.color
    property string secondaryHoverColor: Theme.secondaryLight.color
    property string secondaryPressColor: Theme.secondaryDark.color
    property string labelColor: Theme.primary.titleColor

    contentItem: Label {
        text: button.text
        font: button.font
        opacity: (!enabled | active===0) ? 0.3 : 1.0
        color: labelColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: button.down ? secondaryPressColor :
               button.hovered ? secondaryHoverColor : secondaryActiveColor
        Rectangle {
            anchors.fill: parent
            anchors.leftMargin: (button.active===0) ? 0 : 10

            color: button.down ? primaryPressColor :
                   button.hovered ? primaryHoverColor : primaryActiveColor
        }
    }
}
