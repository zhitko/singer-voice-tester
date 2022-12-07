#include "backend.h"

#include <QDebug>
#include <QDir>
#include <QFileDialog>
#include <QStandardPaths>

#include "qml/qmlfileinfo.h"
#include "applicationconfig.h"

const char SEP = ';';
const char LINE_END = '\n';

QString Backend::getSavedResults()
{
    QFile file(ApplicationConfig::GetFullResultsPath());
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return "";

    QTextStream in(&file);
    QString results = "";
    bool newLine = true;

    while(!in.atEnd()) {
        newLine = true;
        auto elements = in.readLine().split(SEP);
        for (auto &it: elements)
        {
            results += (newLine ? "\n" : ": ") + it;
            newLine = !newLine;
        }
        results += LINE_END;
    }

    file.close();

    qDebug() << "getSavedResults\n" << results;

    return results;
}

void Backend::saveResult(QVariantMap result)
{
    qDebug() << "result: " << result;

    QFile file(ApplicationConfig::GetFullResultsPath());
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append))
        return;
    QTextStream out(&file);
    for(auto it = result.begin(); it != result.end(); ++it)
    {
        out << it.key() << SEP << it.value().toString() << SEP;
    }
    out << LINE_END;
    file.close();
}
