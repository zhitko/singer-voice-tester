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
    qDebug() << "Backend::getWaveFilesList allFiles: " << allFiles;

    QVariantList fileList;

    foreach(auto file, allFiles)
    {
        QmlFileInfo info(dataDir.absoluteFilePath(file));
        qDebug() << "Backend::getWaveFilesList: " << info.getName() << " : " << info.getPath();

        fileList.append(QVariant::fromValue(info));
    }

    return fileList;
}

void Backend::deleteWaveFile(QString path)
{
    qDebug() << "Backend::deleteWaveFile: " << path;
    QFile file (path.toLocal8Bit());
    file.remove();
}

#ifdef ANDROID
#include <QtAndroid>
bool requestAndroidExternalStoragePermissions() {
    const QVector<QString> permissions(
                {"android.permission.WRITE_EXTERNAL_STORAGE",
                 "android.permission.READ_EXTERNAL_STORAGE"}
    );
    for (const QString &permission : permissions) {
        auto result = QtAndroid::checkPermission(permission);
        if (result == QtAndroid::PermissionResult::Denied) {
            auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
            if (resultHash[permission] == QtAndroid::PermissionResult::Denied) {
                return false;
            }
        }
    }
    return true;
}
#endif

QString Backend::openFileDialog()
{
#ifdef ANDROID
    const QString path = QStandardPaths::standardLocations(QStandardPaths::DownloadLocation).at(0) +
            QDir::separator() + "SingerVoiceTester";
    qDebug() << "Backend::openFileDialog path: " << path;
    QString fileName = "";
    if (requestAndroidExternalStoragePermissions()) {
        auto fileUrl = QFileDialog::getOpenFileUrl(nullptr,
                                    tr("Open File"),
                                    path,
                                    tr("Wave (*.*)"));
        qDebug() << "Backend::openFileDialog fileUrl: " << fileUrl;
        fileName = fileUrl.toString();
    }
#else
    const QString path = ApplicationConfig::GetFullTestsPath();
    qDebug() << "Backend::openFileDialog path: " << path;
    auto fileName = QFileDialog::getOpenFileName(nullptr,
        tr("Open File"),
        path,
        tr("Wave (*.wav)"));
#endif
    qDebug() << "Backend::openFileDialog: " << fileName;

    return fileName;
}
