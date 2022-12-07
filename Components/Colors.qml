pragma Singleton
import QtQuick 2.14

QtObject {
    readonly property string black: "#000000"
    readonly property string white: "#ffffff"
    readonly property string teal_blue: "#006E82"
    readonly property string purple: "#8214A0"
    readonly property string blue: "#005AC8"
    readonly property string brilliant_azure: "#3399ff"
    readonly property string royal_azure: "#0038a8"
    readonly property string true_azure: "#007fff"
    readonly property string pink: "#FA78FA"
    readonly property string aqua: "#14D2DC"
    readonly property string raspberry: "#AA0A3C"

    readonly property string green: "#008000"
    readonly property string light_green: "#90ee90"
    readonly property string dark_green: "#006400"
    readonly property string hunter_green: "#355e3b"
    readonly property string dark_sea_green: "#8fbc8f"

    readonly property string red: "#ff0000"
    readonly property string english_red: "#ab4b52"
    readonly property string spanish_crimson: "#e51a4c"

    readonly property string varmillion: "#FF825F"
    readonly property string yellow: "#EAD644"
    readonly property string banana_mania: "#FAE6BE"
    readonly property string dim_grey: "#696969"
    readonly property string gainsboro: "#dcdcdc"
    readonly property string light_grey: "#ededed"
    readonly property string silver: "#c0c0c0"
    readonly property string transparent: "transparent"

    function setAlpha(color, alpha) {
        return color.replace("#", "#"+alpha);
    }
}
