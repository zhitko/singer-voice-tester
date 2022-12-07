import QtQuick 2.14
import QtQuick.Controls 2.14

import "../../App"

SettingsForm {
    id: root
    objectName: Enum.pageSettings

    StackView.onActivated: {
        console.log("SettingsForm.StackView.onActivated")
        Bus.hideAllBottomActions()

        loadSettings()
    }

    function loadSettings() {
        let settings = Bus.getSettings()
        console.log("SettingsForm.loadSettings", settings)
        settingsModel.clear()
        for (let i in settings){
            if (settings[i].visibility || showAdvancedInput.checked) {
                settingsModel.append(
                    {
                        "name": settings[i].name,
                        "description": settings[i].description,
                        "value": settings[i].value,
                        "key": settings[i].key,
                        "type": settings[i].type,
                        "visibility": settings[i].visibility,
                        "editable": settings[i].editable
                    }
                )
                console.log("settingsModel",
                            settings[i].key,
                            settings[i].value,
                            settings[i].visibility,
                            settings[i].editable)
            }
        }
    }

    function settingChanged(name, value) {
        console.log("Settings Page: ", name, value)
        return Bus.setSettings(name, value)
    }

    showAdvancedInput.onCheckedChanged: {
        loadSettings()
    }

}
