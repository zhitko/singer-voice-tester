#include "qmlsetting.h"

QmlSetting::QmlSetting()
    : QObject(nullptr)
{

}

QmlSetting::QmlSetting(const QmlSetting& qmlSetting)
    : QObject(qmlSetting.parent()), name(qmlSetting.name)
    , description(qmlSetting.description), value(qmlSetting.value)
    , key(qmlSetting.key), type(qmlSetting.type)
    , visibility(qmlSetting.visibility), editable(qmlSetting.editable)
{

}

QmlSetting::QmlSetting(
        QString key,
        QString type,
        QString name,
        QString value,
        QString description,
        bool visibility,
        bool editable,
        QObject *parent)
    : QObject(parent), key(key), type(type), name(name), description(description), value(value)
    , visibility(visibility), editable(editable)
{

}

QmlSetting &QmlSetting::operator=(const QmlSetting &qmlSetting)
{
    this->key = qmlSetting.key;
    this->type = qmlSetting.type;
    this->name = qmlSetting.name;
    this->description = qmlSetting.description;
    this->value = qmlSetting.value;
    this->visibility = qmlSetting.visibility;
    this->editable = qmlSetting.editable;
    return *this;
}

QString QmlSetting::getKey()
{
    return this->key;
}

QString QmlSetting::getType()
{
    return this->type;
}

QString QmlSetting::getName()
{
    return this->name;
}

QString QmlSetting::getDescription()
{
    return this->description;
}

bool QmlSetting::getVisibility()
{
    return this->visibility;
}

bool QmlSetting::getEditable()
{
    return this->editable;
}

QString QmlSetting::getValueString()
{
    return this->value;
}

double QmlSetting::getValueDouble()
{
    return this->value.toDouble();
}

int QmlSetting::getValueInteger()
{
    return this->value.toInt();
}
