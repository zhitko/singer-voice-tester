#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>

#include <QDir>
#include <QFile>
#include <QDateTime>
#include <QTextStream>
#include <QDebug>

#include "backend.h"
#include "applicationconfig.h"

void cleanDataDir();
void copyTestDataFilesForAndroid();

static const QtMessageHandler QT_DEFAULT_MESSAGE_HANDLER = qInstallMessageHandler(0);

void logToFile(const QString message)
{
    QFile file("logs.txt");
    if (file.open(QIODevice::WriteOnly | QIODevice::Text | QIODevice::Append)) {
        QTextStream stream(&file);
        stream << message << endl;
    }
}

void messageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    QString message = QString("%1: %2").arg(
        QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss:zzz "),
        QString(localMsg.constData())
        );
    logToFile(message);

    (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, message);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    qInstallMessageHandler(messageOutput);

    QApplication app(argc, argv);

    qmlRegisterType<Backend>("intondemo.backend", 1, 0, "Backend");

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

#ifdef ANDROID
    copyTestDataFilesForAndroid();
#endif

    auto result = QApplication::exec();

#ifdef ANDROID
    cleanDataDir();
#endif

    return result;
}

#ifdef ANDROID
#include <QtAndroid>

void copyTestDataFilesForAndroid()
{
    const QVector<QString> permissions(
                {"android.permission.WRITE_EXTERNAL_STORAGE",
                 "android.permission.READ_EXTERNAL_STORAGE"}
    );
    for (const QString &permission : permissions) {
        auto result = QtAndroid::checkPermission(permission);
        if (result == QtAndroid::PermissionResult::Denied) {
            auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
            if (resultHash[permission] == QtAndroid::PermissionResult::Denied) {
                return;
            }
        }
    }

    qDebug() << "copyTestDataFilesForAndroid";

    const QString src = "assets:/SingerVoiceTester";
    qDebug() << "copyTestDataFilesForAndroid src: " << src;

    const QString dst = QStandardPaths::standardLocations(QStandardPaths::DownloadLocation).at(0) +
            QDir::separator() + "SingerVoiceTester";
    qDebug() << "copyTestDataFilesForAndroid dst: " << dst;

    QDir srcDir(src);
    if (!srcDir.exists())
    {
        qDebug() << "copyTestDataFilesForAndroid srcDir: Not Exists";
        return;
    }

    QDir dstDir(dst);
    if (!dstDir.exists())
    {
        qDebug() << "copyTestDataFilesForAndroid dstDir: Not Exists";
        auto dstDirRes = dstDir.mkpath(dst);
        qDebug() << "copyTestDataFilesForAndroid dstDir: " << dstDirRes;
    }

    foreach (QString f, srcDir.entryList(QDir::Files)) {
        auto copyRes = QFile::copy(src + QDir::separator() + f, dst + QDir::separator() + f);
        qDebug() << "copyTestDataFilesForAndroid QFile::copy f: " << f;
        qDebug() << "copyTestDataFilesForAndroid QFile::copy copyRes: " << copyRes;
    }
}
#else
void copyTestDataFilesForAndroid()
{
    qDebug() << "copyTestDataFilesForAndroid - Skip";
}
#endif

void cleanDataDir()
{
    QDir dataDir(ApplicationConfig::GetFullDataPath());
    QStringList allFiles = dataDir.entryList(ApplicationConfig::WaveFileFilter, QDir::NoDotAndDotDot | QDir::Files);

    foreach(auto file, allFiles)
    {
        QDir dir;
        dir.remove(dataDir.absoluteFilePath(file));
    }
}
