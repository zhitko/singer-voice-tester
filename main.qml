import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14
import QtQuick.Layouts 1.14

import "App"
import "Components"
import "Components/FontAwesome"
import "Components/Material"

ApplicationWindow {
    id: window
    width: Config.applicationWidth
    height: Config.applicationHeight
    minimumWidth: Config.applicationMinWidth
    minimumHeight: Config.applicationMinHeight
    visible: true
    title: qsTr("Singer Voice Tester")

    Material.primary: Theme.primary.color
    Material.accent: Theme.secondary.color
    Material.foreground: Theme.backgound.textColor
    Material.background: Theme.backgound.color

    Component.onCompleted: {
        Bus.stackView = stackView
        Bus.getSettings()
        Bus.goHome()
    }

    StackView {
        id: stackView
        anchors.fill: parent
    }

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        RowLayout {
            anchors.fill: parent

            FontAwesomeToolButton {
                id: menuButton
                type: FontAwesome.solid
                icon: FontAwesome.icons.faBars
                Layout.alignment: Qt.AlignLeft
                button.onClicked: drawer.open()
                Layout.margins: 10
            }

            FontAwesomeToolButton {
                id: toolButton
                type: FontAwesome.solid
                icon: FontAwesome.icons.faArrowLeft
                Layout.alignment: Qt.AlignRight
                visible: stackView.depth > 1
                button.onClicked: Bus.goBack()
                Layout.margins: 10
            }
        }

        Label {
            text: stackView.currentItem ? stackView.currentItem.title : ""
            anchors.centerIn: parent
            color: Theme.primary.titleColor
        }
    }

    footer: BottomBar {
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height
        background: Rectangle {
            color: Theme.secondary.color
            Rectangle {
                anchors.fill: parent
                anchors.rightMargin: 10
                color: Theme.backgound.color
            }
        }

        Column {
            anchors.fill: parent

            Rectangle {
                color: Theme.primary.color
                height: 100
                width: drawer.width
                Label {
                    anchors.centerIn: parent
                    text: qsTr("Singer Voice Tester")
                    color: Theme.primary.titleColor
                    font.bold: true
                    font.pointSize: 20
                }
            }

            ItemDelegate {
                width: parent.width
                onClicked: {
                    Bus.goHome()
                    drawer.close()
                }

                FontAwesomeIconText {
                    icon: FontAwesome.icons.faHouseUser
                    text: qsTr("Home")
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.backgound.textColor
                    iconColor: Bus.isHomePage() ? Theme.secondary.color : Theme.backgound.textColor
                }
            }

            ItemDelegate {
                width: parent.width
                onClicked: {
                    Bus.goResults()
                    drawer.close()
                }

                FontAwesomeIconText {
                    icon: FontAwesome.icons.faHistory
                    text: qsTr("Results History")
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.backgound.textColor
                    iconColor: Bus.isResultsPage() ? Theme.secondary.color : Theme.backgound.textColor
                }
            }

            ItemDelegate {
                width: parent.width
                onClicked: {
                    Bus.goSettings()
                    drawer.close()
                }

                FontAwesomeIconText {
                    icon: FontAwesome.icons.faSlidersH
                    text: qsTr("Settings")
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.backgound.textColor
                    iconColor: Bus.isSettingsPage() ? Theme.secondary.color : Theme.backgound.textColor
                }
            }

            ItemDelegate {
                width: parent.width
                onClicked: {
                    Bus.goPolicy()
                    drawer.close()
                }

                FontAwesomeIconText {
                    icon: FontAwesome.icons.faFileAlt
                    text: qsTr("Privacy Policy")
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.backgound.textColor
                    iconColor: Bus.isPolicyPage() ? Theme.secondary.color : Theme.backgound.textColor
                }
            }
        }
    }
}
