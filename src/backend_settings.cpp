#include "backend.h"

#include <QDebug>
#include <QSettings>

#include "applicationconfig.h"
#include "qml/qmlsetting.h"

QVariant Backend::getSettingValue(QString id)
{
    QSettings settings(ApplicationConfig::GetFullSettingsPath(), QSettings::IniFormat);
    return settings.value(ApplicationConfig::SettingsValueKey(id));
}

QVariantList Backend::getSettings()
{
    QSettings settings(ApplicationConfig::GetFullSettingsPath(), QSettings::IniFormat);
    auto groups = settings.childGroups();

    auto version = settings.value(ApplicationConfig::SETTINGS_VERSION_KEY, "").toString() == ApplicationConfig::SETTINGS_VERSION_VALUE;

    QVariantList settingsList;
    for (const auto& kv : ApplicationConfig::DEFAULT_SETTINGS) {
        if (!groups.contains(kv.first) || !version)
        {
            qDebug() << "getSettings: missing setting = " << kv;
            settings.setValue(
                ApplicationConfig::SettingsValueKey(kv.first),
                kv.second.at(ApplicationConfig::SETTINGS_VAL)
            );
            settings.setValue(
                ApplicationConfig::SettingsNameKey(kv.first),
                kv.second.at(ApplicationConfig::SETTINGS_NAME)
            );
            settings.setValue(
                ApplicationConfig::SettingsDescKey(kv.first),
                kv.second.at(ApplicationConfig::SETTINGS_DESC)
            );
            settings.setValue(
                ApplicationConfig::SettingsTypeKey(kv.first),
                kv.second.at(ApplicationConfig::SETTINGS_TYPE)
            );
            settings.setValue(
                ApplicationConfig::SettingsVisibleKey(kv.first),
                kv.second.at(ApplicationConfig::SETTINGS_VISIBLE)
            );
            settings.setValue(
                ApplicationConfig::SettingsEditableKey(kv.first),
                kv.second.at(ApplicationConfig::SETTINGS_EDITABLE)
            );
        }

        qDebug() << kv.first << " " << settings.value(kv.first + "/" + ApplicationConfig::SETTINGS_EDITABLE).toString();
        settingsList.append(QVariant::fromValue(QmlSetting(
            kv.first,
            settings.value(ApplicationConfig::SettingsTypeKey(kv.first)).toString(),
            settings.value(ApplicationConfig::SettingsNameKey(kv.first)).toString(),
            settings.value(ApplicationConfig::SettingsValueKey(kv.first)).toString(),
            settings.value(ApplicationConfig::SettingsDescKey(kv.first)).toString(),
            settings.value(ApplicationConfig::SettingsVisibleKey(kv.first)).toBool(),
            settings.value(ApplicationConfig::SettingsEditableKey(kv.first)).toBool()
        )));
    }

    settings.setValue(ApplicationConfig::SETTINGS_VERSION_KEY, ApplicationConfig::SETTINGS_VERSION_VALUE);
    settings.sync();

    return settingsList;
}

QString Backend::setSettings(QString id, QString value)
{
    qDebug() << "setSettings: " << id << " " << value;

    QSettings settings(ApplicationConfig::GetFullSettingsPath(), QSettings::IniFormat);

    if (!this->validateSettings(id, value))
    {
        qDebug() << "validateSettings: failed";
        return settings.value(ApplicationConfig::SettingsValueKey(id)).toString();
    }

    if (value.isEmpty()) return value;

    settings.setValue(ApplicationConfig::SettingsValueKey(id), value);

    settings.sync();

    return value;
}

bool Backend::validateSettings(QString id, QString value)
{
    qDebug() << "validateSettings: " << id << " " << value;

    if (value.isEmpty()) return true;

    QSettings settings(ApplicationConfig::GetFullSettingsPath(), QSettings::IniFormat);

    auto type =settings.value(ApplicationConfig::SettingsTypeKey(id)).toString();

    bool result = true;
    if (type == ApplicationConfig::SETTINGS_TYPE_DOUBLE)
    {
        value.toDouble(&result);
    } else if (type == ApplicationConfig::SETTINGS_TYPE_INTEGER)
    {
        value.toInt(&result);
    } else if (type == ApplicationConfig::SETTINGS_TYPE_BOOL) {
        result = value == "true" || value == "false";
    } else if (type == ApplicationConfig::SETTINGS_TYPE_DOUBLE_LIST) {
        auto values = value.split(ApplicationConfig::SETTINGS_TYPE_LIST_DELIMETER);
        for (auto& v : values)
        {
            v.toDouble(&result);
            if (!result) return result;
        }
    }

    return result;
}

std::list<double> Backend::getOctavesSetting(bool isMale, bool isFull)
{
    std::list<double> octaves;

    auto actavesStr = this->getSettingValue(
        isFull ? ApplicationConfig::SETTINGS_PITCH_OCTAVES :
        isMale ? ApplicationConfig::SETTINGS_PITCH_OCTAVES_MALE : ApplicationConfig::SETTINGS_PITCH_OCTAVES_FEMALE)
        .toString()
        .split(ApplicationConfig::SETTINGS_TYPE_LIST_DELIMETER);
    qDebug() << "actavesStr" << actavesStr;

    for ( const auto& i : actavesStr  )
    {
        octaves.push_back(i.toDouble());
    }

    return octaves;
}
