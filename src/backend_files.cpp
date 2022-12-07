#include "backend.h"

#include <QDebug>
#include <QDir>
#include <QFileDialog>
#include <QStandardPaths>

#include "qml/qmlfileinfo.h"
#include "applicationconfig.h"

QVariantList Backend::getWaveFilesList()
{
    QDir dataDir(ApplicationConfig::GetFullDataPath());
    QStringList allFiles = dataDir.entryList(ApplicationConfig::WaveFileFilter, QDir::NoDotAndDotDot | QDir::Files);
    qDebug() << "Found files: " << allFiles;

    QVariantList fileList;

    foreach(auto file, allFiles)
    {
        QmlFileInfo info(dataDir.absoluteFilePath(file));
        qDebug() << "File: " << info.getName() << " : " << info.getPath();

        fileList.append(QVariant::fromValue(info));
    }

    return fileList;
}

void Backend::deleteWaveFile(QString path)
{
    qDebug() << "deleteWaveFile " << path;
    QFile file (path.toLocal8Bit());
    file.remove();
}

QString Backend::openFileDialog()
{
#ifdef ANDROID
    auto fileUrl = QFileDialog::getOpenFileUrl(nullptr,
                                tr("Open File"),
                                ApplicationConfig::GetFullTestsPath(),
                                tr("Wave (*.wav)"));
    qDebug() << "openFileDialog: " << fileUrl;
    auto fileName = fileUrl.toString();
#else
    auto fileName = QFileDialog::getOpenFileName(nullptr,
        tr("Open File"),
        ApplicationConfig::GetFullTestsPath(),
        tr("Wave (*.wav)"));
#endif
    qDebug() << "openFileDialog: " << fileName;

    return fileName;
}
