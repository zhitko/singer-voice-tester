#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>

#include <QList>
#include <QVariant>
#include <QVariantList>

namespace IntonCore {
class Core;
}

class Recorder;
class PcmRecorder;
class Settings;

class QSound;

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);
    virtual ~Backend();

    Q_PROPERTY(QString path READ getPath WRITE setPath)

    Q_INVOKABLE bool isMobile();
    Q_INVOKABLE void reinitialize();

    // Settings API
    Q_INVOKABLE QVariant getSettingValue(QString id);
    Q_INVOKABLE QVariantList getSettings();
    Q_INVOKABLE QString setSettings(QString id, QString value);
    Q_INVOKABLE bool validateSettings(QString id, QString value);

    std::list<double> getOctavesSetting(bool isMale, bool isFull = false);

    // Files API
    Q_INVOKABLE QVariantList getWaveFilesList();
    Q_INVOKABLE void copyToExamples(QString filePath, QString name);
    Q_INVOKABLE void deleteWaveFile(QString path);
    Q_INVOKABLE void playWaveFile(QString path, bool stop);
    Q_INVOKABLE QString startStopRecordWaveFile(bool reloadPath);
    Q_INVOKABLE QString openFileDialog();

    Q_INVOKABLE QString getSavedResults();
    Q_INVOKABLE void saveResult(QVariantMap result);

    // WAVE file API
    Q_INVOKABLE QVariantList getWaveData(QString path);
    Q_INVOKABLE QVariant getWaveLength(QString path);

    // Pitch API
    Q_INVOKABLE QVariantList getPitchData(QString path, bool isMale, bool cutted = false);
    Q_INVOKABLE QVariantList getPitchNormalizedData(QString path, bool isMale, bool cutted = false);
    Q_INVOKABLE QVariantList getPitchOcatavesNormalizedData(QString path, bool isMale, bool cutted = false);
    Q_INVOKABLE QVariantList getPitchFullData(QString path, bool isMale);
    Q_INVOKABLE QVariantList getPitchDataCutted(QString path, bool isMale);
    Q_INVOKABLE QVariant getPitchMinMax(bool isMale);

    Q_INVOKABLE QVariantList getPitchFrequencySegmentsCount(QString path, bool isMale, bool isFull = false);
    Q_INVOKABLE QVariantList getTemplatePitchFrequencySegmentsCount(QString path, bool isMale, bool isFull = false);
    Q_INVOKABLE QVariantList getPitchFrequencyCount(QString path, bool isMale);
    Q_INVOKABLE QVariantList getTemplatePitchFrequencyCount(QString path, bool isMale);

    Q_INVOKABLE QVariantList getPitchOcavesMetrics(QString path, bool isMale, bool cutted, bool isFull = false);
    Q_INVOKABLE QVariantList getTemplateOcavesMetrics(QString path, bool isMale, bool cutted, bool isFull = false);

    Q_INVOKABLE QVariantList getPitchDerivativeCount(QString path, bool isMale, bool isFull);
    Q_INVOKABLE QVariantList getTemplatePitchDerivativeCount(QString path, bool isMale, bool isFull);

    Q_INVOKABLE QVariantList getOctavesCategories(bool isMale, bool isFull);
    Q_INVOKABLE QVariantList getOctavesOptimazedCategories(bool isMale);

    // Segments API
    Q_INVOKABLE QVariantList getSegmentsByIntensity(QString path);

    // System API
    Q_INVOKABLE void moveTemplateToRecord();
    Q_INVOKABLE void moveRecordToTemplate();

    // Singer API
    Q_INVOKABLE QVariantList getSingerMetrics(QString path, bool isMale);
    Q_INVOKABLE QVariantList getTemplateSingerMetrics(QString path, bool isMale);
public:
    QString getPath();
    void setPath(const QString& path);

private:
    IntonCore::Core *core;

    QString path;
    QString template_path;

    QSound *sound;

    PcmRecorder *recorder;

private:
    void initializeCore(bool reinit = false);
    void initializeRecordCore(const QString& path);
    void initializeTemplateCore(const QString& path);

    void initializeRecorder();
    void initializeAudio();

signals:

};

#endif // BACKEND_H
