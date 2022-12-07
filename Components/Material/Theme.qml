pragma Singleton
import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls.Material 2.14

Item {
    id: theme

    property Color backgound: Color{}
    property Color primary: Color{}
    property Color primaryLight: Color{}
    property Color primaryDark: Color{}
    property Color secondary: Color{}
    property Color secondaryLight: Color{}
    property Color secondaryDark: Color{}

    Component.onCompleted: {
        setColor(Colors.purple900)
    }

    function setColor(color) {
        function evalRangeColors(colorObj, colorObjDark, colorObjLight) {
            let range = Utilities.getColorRangeFromHex(colorObj.color)
            colorObjDark.color = range.darkHex
            colorObjLight.color = range.lightHex
        }

        function evalTextColors(colorObj) {
            let accessibility = Utilities.getAccessibilityValuesFromHex(colorObj.color)
            console.log("primaryColor", JSON.stringify(accessibility))
            colorObj.titleColor = accessibility.preferredTitleColor
            colorObj.textColor = accessibility.preferredNormalColor
        }

        theme.primary.color = color
        evalTextColors(theme.primary)
        console.log("setColor primary.color", primary.color)
        console.log("setColor primary.textColor", primary.textColor)
        console.log("setColor primary.titleColor", primary.titleColor)

        evalRangeColors(theme.primary, theme.primaryDark, theme.primaryLight)
        evalTextColors(theme.primaryDark)
        console.log("setColor primaryDark.color", primaryDark.color)
        console.log("setColor primaryDark.textColor", primaryDark.textColor)
        console.log("setColor primaryDark.titleColor", primaryDark.titleColor)
        evalTextColors(theme.primaryLight)
        console.log("setColor primaryLight.color", primaryLight.color)
        console.log("setColor primaryLight.textColor", primaryLight.textColor)
        console.log("setColor primaryLight.titleColor", primaryLight.titleColor)

        theme.secondary.color = Colors.green600
        evalTextColors(theme.secondary)
        console.log("setColor secondary.color", secondary.color)
        console.log("setColor secondary.textColor", secondary.textColor)
        console.log("setColor secondary.titleColor", secondary.titleColor)

        evalRangeColors(theme.secondary, theme.secondaryDark, theme.secondaryLight)
        evalTextColors(theme.secondaryDark)
        console.log("setColor secondaryDark.color", secondaryDark.color)
        console.log("setColor secondaryDark.textColor", secondaryDark.textColor)
        console.log("setColor secondaryDark.titleColor", secondaryDark.titleColor)
        evalTextColors(theme.secondaryLight)
        console.log("setColor secondaryLight.color", secondaryLight.color)
        console.log("setColor secondaryLight.textColor", secondaryLight.textColor)
        console.log("setColor secondaryLight.titleColor", secondaryLight.titleColor)

        theme.backgound.color = Colors.white
        evalTextColors(theme.backgound)
        console.log("setColor backgound.color", backgound.color)
        console.log("setColor backgound.textColor", backgound.textColor)
        console.log("setColor backgound.titleColor", backgound.titleColor)
    }

    function apply(obj) {
        obj.Material.primary = theme.primary.color
        obj.Material.foreground = theme.backgound.textColor
        obj.Material.background = theme.backgound.color
        obj.Material.accent = secondary.color
    }
}
