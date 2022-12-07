pragma Singleton
import QtQuick 2.14

Item {
    readonly property int pageHeight: 600
    readonly property int pageWidth: 450

    readonly property int applicationHeight: pageHeight + 80
    readonly property int applicationWidth: pageWidth + 40

    readonly property int applicationMinHeight: 500
    readonly property int applicationMinWidth: 490
}
