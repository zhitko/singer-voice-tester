#include "backend.h"

#include <cmath>

#include <QDebug>
#include <QGuiApplication>
#include <QTemporaryFile>
#include <QQmlFile>
#include <QDataStream>

#include <inton-core/include/intoncore.h>
#include <inton-core/include/utils.h>

#include "applicationconfig.h"
#include "qml/qmlpoint.h"
#include <limits>


const int WAVE_LENGTH = 1000;

Backend::Backend(QObject *parent)
    : QObject(parent),
    core(nullptr),
    sound(nullptr)
{
    this->path = "";

    this->initializeRecorder();
    this->initializeAudio();
}

Backend::~Backend()
{
    qDebug() << "~Backend";

    if(this->core != nullptr) delete this->core;
}

bool Backend::isMobile()
{
#ifdef ANDROID
    return true;
#else
    return false;
#endif
}

void Backend::reinitialize()
{
    this->path = "";
    this->template_path = "";
    this->initializeCore(true);
}

QVariantList Backend::getWaveData(QString path)
{
    this->initializeRecordCore(path);

    auto storage = this->core->getRecord();

    auto data = storage->getWaveNormalized();
    auto resized_data = IntonCore::resizeVectorByMinMax(data, WAVE_LENGTH);
    qDebug() << "getWaveData: file size: " << data.size();
    qDebug() << "getWaveData: file size: " << resized_data.size();

    QVariantList waveData;

    for (ulong i=0; i<resized_data.size(); i++) {
        waveData.append(QVariant::fromValue(QmlPoint(i, resized_data[i])));
    }

    return waveData;
}

QVariant Backend::getWaveLength(QString path)
{
    this->initializeRecordCore(path);

    auto storage = this->core->getRecord();
    auto wave = storage->getWave();

    return QVariant::fromValue(1.0 * wave.size() / ApplicationConfig::RecordingFrequency);
}

QVariantList Backend::getPitchData(QString path, bool isMale, bool cutted)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    qDebug() << "getPitchData: try getRecord";
    auto storage = this->core->getRecord();
    qDebug() << "getPitchData: try getPitch";
    std::vector<double> data;
    if (cutted)
    {
        data = storage->getPitchCutted();
    } else {
        data = storage->getPitch();
    }
    qDebug() << "getPitchData: try resizeVector";
    auto resized_data = IntonCore::resizeVector(data, WAVE_LENGTH);
    qDebug() << "getPitchData: file size: " << data.size();
    qDebug() << "getPitchData: file size: " << resized_data.size();

    QVariantList pitchData;

    for (ulong i=0; i<resized_data.size(); i++) {
        pitchData.append(QVariant::fromValue(QmlPoint(i, resized_data[i])));
    }

    return pitchData;
}

QVariantList Backend::getPitchOcatavesNormalizedData(QString path, bool isMale, bool cutted)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setOctavesConfig(
        this->getOctavesSetting(isMale)
    );

    qDebug() << "getPitchNormalizedData: try getTemplate";
    auto storage = this->core->getRecord();
    qDebug() << "getPitchNormalizedData: try getPitch";
    std::vector<double> data;
    if (cutted)
    {
        data = storage->getPitchOctavesNormalizedCutted();
    } else {
        data = storage->getPitchOctavesNormalized();
    }
    qDebug() << "getPitchNormalizedData: try resizeVector";
    auto resized_data = IntonCore::resizeVector(data, WAVE_LENGTH);
    qDebug() << "getPitchNormalizedData: file size: " << data.size();
    qDebug() << "getPitchNormalizedData: file size: " << resized_data.size();

    QVariantList pitchData;

    for (ulong i=0; i<resized_data.size(); i++) {
        pitchData.append(QVariant::fromValue(QmlPoint(i, resized_data[i])));
    }

    return pitchData;
}

QVariantList Backend::getPitchNormalizedData(QString path, bool isMale, bool cutted)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    qDebug() << "getPitchNormalizedData: try getTemplate";
    auto storage = this->core->getRecord();
    qDebug() << "getPitchNormalizedData: try getPitch";
    std::vector<double> data;
    if (cutted)
    {
        data = storage->getPitchNormalizedCutted();
    } else {
        data = storage->getPitchNormalized();
    }
    qDebug() << "getPitchNormalizedData: try resizeVector";
    auto resized_data = IntonCore::resizeVector(data, WAVE_LENGTH);
    qDebug() << "getPitchNormalizedData: file size: " << data.size();
    qDebug() << "getPitchNormalizedData: file size: " << resized_data.size();

    QVariantList pitchData;

    for (ulong i=0; i<resized_data.size(); i++) {
        pitchData.append(QVariant::fromValue(QmlPoint(i, resized_data[i])));
    }

    return pitchData;
}

QVariant Backend::getPitchMinMax(bool isMale)
{
    if (this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZE_BY_OCTAVES).toBool())
    {
        return QVariant::fromValue(QPoint(0,this->getOctavesSetting(isMale).size()));
    } else if (this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZED).toBool())
    {
        return QVariant::fromValue(QPoint(0,1));
    } else {
        return QVariant::fromValue(QPoint(
            this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                           ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble(),
            this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                           ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble()
        ));
    }
}

QVariantList Backend::getPitchFullData(QString path, bool isMale)
{
    QVariantList pitch;

    if (this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZE_BY_OCTAVES).toBool())
    {
        pitch = getPitchOcatavesNormalizedData(path, isMale);
    } else if (this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZED).toBool())
    {
        pitch = getPitchNormalizedData(path, isMale);
    } else {
        pitch = getPitchData(path, isMale);
    }

    return pitch;
}

QVariantList Backend::getPitchDataCutted(QString path, bool isMale)
{
    qDebug() << this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME);
    qDebug() << this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT);
    qDebug() << this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME);
    qDebug() << this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT);

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    QVariantList pitch;

    if (this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZE_BY_OCTAVES).toBool())
    {
        pitch = getPitchOcatavesNormalizedData(path, isMale, true);
    } else if (this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZED).toBool())
    {
        pitch = getPitchNormalizedData(path, isMale, true);
    } else {
        pitch = getPitchData(path, isMale, true);
    }

    return pitch;
}

QVariantList getDerivativeCount(IntonCore::Storage *storage,
                                bool isNormalizedByOctaves,
                                bool isNormalized,
                                bool isCutted)
{
    qDebug() << "getDerivativeCount " << isCutted;
    std::vector<double> data;

    if (isNormalizedByOctaves && !isCutted)
    {
        qDebug() << "getDerivativeCount: getPitchOctavesNormalizedDerivative";
        data = storage->getPitchOctavesNormalizedDerivative();
    } else if (isNormalized && !isCutted)
    {
        qDebug() << "getDerivativeCount: getPitchNormalizedDerivative";
        data = storage->getPitchNormalizedDerivative();
    } else if (isNormalizedByOctaves && isCutted)
    {
        qDebug() << "getDerivativeCount: getPitchOctavesNormalizedCuttedDerivative";
        data = storage->getPitchOctavesNormalizedCuttedDerivative();
    } else if (isNormalized && isCutted)
    {
        qDebug() << "getDerivativeCount: getPitchNormalizedCuttedDerivative";
        data = storage->getPitchNormalizedCuttedDerivative();
    } else {
        qDebug() << "getDerivativeCount: getPitchDerivative";
        data = storage->getPitchDerivative();
    }

    int less_zero = 0;
    int eq_zero = 0;
    int more_zero = 0;

    for (auto &it: data)
    {
        if (it < 0)
        {
            less_zero++;
        } else if (it > 0)
        {
            more_zero++;
        } else
        {
            eq_zero++;
        }
    }

    //double max = (less_zero>eq_zero) ? ((less_zero>more_zero) ? less_zero : more_zero) : ((eq_zero>more_zero) ? eq_zero : more_zero) ;
    double max = more_zero>less_zero ? more_zero : less_zero;

    qDebug() << "getDerivativeCount less_zero" << less_zero;
    qDebug() << "getDerivativeCount more_zero" << more_zero;
    qDebug() << "getDerivativeCount eq_zero" << eq_zero;
    qDebug() << "getDerivativeCount max" << max;

    QVariantList count;
    //count.append(eq_zero / max);
    count.append(more_zero / max);
    count.append(less_zero / max);

    return count;
}

QVariantList Backend::getPitchDerivativeCount(QString path, bool isMale, bool isFull)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    qDebug() << "getPitchNormalizedData: try getTemplate";
    auto storage = this->core->getRecord();

    auto data = getDerivativeCount(storage,
                                   this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZE_BY_OCTAVES).toBool(),
                                   this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZED).toBool(),
                                   !isFull);

    return data;
}

QVariantList Backend::getTemplatePitchDerivativeCount(QString path, bool isMale, bool isFull)
{
    this->initializeTemplateCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    qDebug() << "getPitchNormalizedData: try getTemplate";
    auto storage = this->core->getTemplate();

    auto data = getDerivativeCount(storage,
                                   this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZE_BY_OCTAVES).toBool(),
                                   this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_NORMALIZED).toBool(),
                                   !isFull);

    return data;
}

QVariantList calculatePitchSegmentsCount(
        IntonCore::Storage * storage,
        std::list<double> actaves,
        bool cutted,
        bool mean,
        double threshold)
{
    auto pitch = storage->getPitch();

    qDebug() << "calculatePitchSegmentsCount: cutted " << cutted;
    qDebug() << "calculatePitchSegmentsCount: threshold " << threshold;
    if (cutted)
    {
        auto intensity = storage->getIntensity();
        auto data = storage->getAutoSegmentsByIntensitySmoothed();
        qDebug() << "getPitchDataCutted count " << data.size();

        uint32_t pos = 0;
        for (auto &it: data)
        {
            auto to = IntonCore::normalizeValue(it.first, intensity.size(), pitch.size());
            for (auto i = pos; i <= to && i < pitch.size(); i++)
            {
                pitch[i] = 0;
            }
            pos = to + IntonCore::normalizeValue(it.second, intensity.size(), pitch.size());
        }

        for (auto i = pos; i < pitch.size(); i++)
        {
            pitch[i] = 0;
        }
    }

    QMap<int, int> counts;

    int max = 0;

    qDebug() << "calculatePitchSegmentsCount: mean " << mean;
    if (!mean)
    {
        for (ulong i=0; i<pitch.size(); i++)
        {
            int j = 0;
            for (double &actave : actaves)
            {
                if (pitch[i] != 0 && pitch[i] < actave)
                {
                    counts[j] = counts.value(j, 0) + 1;
                    if (max < counts[j]) max = counts[j];
                    break;
                }
                j ++;
            }
        }
    }

    if (mean)
    {
        double min = *min_element(pitch.begin(), pitch.end());
        qDebug() << "calculatePitchSegmentsCount: min " << min;

        int count = 0;
        double sum = 0;

        for (double &element : pitch)
        {
            if (element == min) {
                if (count != 0) {
                    double mean_value = sum / (count+1);
                    int j = -1;
                    for (double &actave : actaves)
                    {
                        j++;
                        if (actave > mean_value) break;
                    }
                    counts[j] = counts.value(j, 0) + 1;
                    if (max < counts[j]) max = counts[j];
                    count = 0;
                    sum = 0;
                }
            } else {
                sum += element;
                count++;
            }
        }
    }

    QVariantList result;

    for (int i=0; i<actaves.size(); i++)
    {
        double value = 1.0 * counts.value(i, 0) / max;
        if (value < threshold)
        {
            result.append(0);
        } else {
            value = (value-threshold)/(1.0-threshold);
            result.append(value);
        }


    }

    result.append(max);

    return result;
}

QVariantList Backend::getTemplatePitchFrequencySegmentsCount(QString path, bool isMale, bool isFull)
{
    this->initializeTemplateCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto threshold = this->getSettingValue(ApplicationConfig::SETTINGS_HISTOGRAM_THRESHOLD).toDouble();

    auto storage = this->core->getTemplate();

    auto actaves = this->getOctavesSetting(isMale, isFull);

    auto mean = this->getSettingValue(ApplicationConfig::SETTINGS_OCTAVES_HISTOGRAM_MEAN).toBool();

    auto result = calculatePitchSegmentsCount(storage, actaves, true, mean, threshold);

    return result;
}

QVariantList Backend::getPitchFrequencySegmentsCount(QString path, bool isMale, bool isFull)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto threshold = this->getSettingValue(ApplicationConfig::SETTINGS_HISTOGRAM_THRESHOLD).toDouble();

    auto storage = this->core->getRecord();

    auto actaves = this->getOctavesSetting(isMale, isFull);

    auto mean = this->getSettingValue(ApplicationConfig::SETTINGS_OCTAVES_HISTOGRAM_MEAN).toBool();

    auto result = calculatePitchSegmentsCount(storage, actaves, true, mean, threshold);

    return result;
}

QVariantList Backend::getPitchFrequencyCount(QString path, bool isMale)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto threshold = this->getSettingValue(ApplicationConfig::SETTINGS_HISTOGRAM_THRESHOLD).toDouble();

    auto storage = this->core->getRecord();

    auto actaves = this->getOctavesSetting(isMale);

    auto mean = this->getSettingValue(ApplicationConfig::SETTINGS_OCTAVES_HISTOGRAM_MEAN).toBool();

    auto result = calculatePitchSegmentsCount(storage, actaves, false, mean, threshold);

    return result;
}

QVariantList Backend::getTemplatePitchFrequencyCount(QString path, bool isMale)
{
    this->initializeTemplateCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto threshold = this->getSettingValue(ApplicationConfig::SETTINGS_HISTOGRAM_THRESHOLD).toDouble();

    auto storage = this->core->getTemplate();

    auto actaves = this->getOctavesSetting(isMale);

    auto mean = this->getSettingValue(ApplicationConfig::SETTINGS_OCTAVES_HISTOGRAM_MEAN).toBool();

    auto result = calculatePitchSegmentsCount(storage, actaves, false, mean, threshold);

    return result;
}

QVariantList Backend::getOctavesOptimazedCategories(bool isMale)
{
    auto actaves = this->getOctavesSetting(isMale);

    const int MAX_CATEGORIES = 1;
    int actavesSize = actaves.size();
    int count = 1;

    qDebug() << "actavesSize = " << actavesSize;

    if (actavesSize <= MAX_CATEGORIES) {
        return this->getOctavesCategories(isMale, false);
    }

    for (int i=MAX_CATEGORIES; i>0; i--)
    {
        count = actavesSize / i;
        if (actavesSize % i == 0) break;
    }

    qDebug() << "count = " << count;

    QVariantList result;

    QString value = "";
    QString currentValue = QString::number(actaves.front());
    int index = 0;
    bool start = false;


    for (auto &it: actaves)
    {
        index++;

        if (!start) {
            value = currentValue;// + " ... ";
            start = true;
        }

        if (index == count)
        {
            //value += QString::number(it);
            currentValue = QString::number(it);
            result.append(value);
            start = false;
            index = 0;
        }
    }

    return result;
}

QVariantList Backend::getOctavesCategories(bool isMale, bool isFull)
{
    auto actaves = this->getOctavesSetting(isMale, isFull);

    QVariantList result;

    for (auto &it: actaves)
    {
        result.append(it);
    }

    return result;
}

double CG(QVariantList data, int min, int max)
{
    auto sumNF0 = 0.0;
    auto sumF0 = 0.0;
    auto CG = 0.0;
    auto x = 0.0;
    for (int i=min; i<(max-1); i++)
    {
        x = data.at(i).toDouble();
        sumF0 += x;
        sumNF0 += x * (i+1);
    }
    qDebug() << "GC sumF0 " << sumF0;
    if (sumF0 != 0 && sumF0 == sumF0)
    {
        CG = sumNF0 / sumF0;
    }

    return CG;
}

double CG2(QVariantList data, int min, int max)
{
    auto sumNF0 = 0.0;
    auto sumF0 = 0.0;
    auto CG = 0.0;
    auto x = 0.0;
    for (int i=min; i<(max-1); i++)
    {
        x = data.at(i).toDouble() * data.at(i).toDouble();
        sumF0 += x;
        sumNF0 += x * (i+1);
    }
    qDebug() << "GC sumF0 " << sumF0;
    if (sumF0 != 0 && sumF0 == sumF0)
    {
        CG = sumNF0 / sumF0;
    }

    return CG;
}

double CG05(QVariantList data, int min, int max)
{
    auto sumNF0 = 0.0;
    auto sumF0 = 0.0;
    auto CG = 0.0;
    auto x = 0.0;
    for (int i=min; i<(max-1); i++)
    {
        x = sqrt(data.at(i).toDouble());
        sumF0 += x;
        sumNF0 += x * (i+1);
    }
    qDebug() << "GC sumF0 " << sumF0;
    if (sumF0 != 0 && sumF0 == sumF0)
    {
        CG = sumNF0 / sumF0;
    }

    return CG;
}

QVariantList getOcavesMetrics(QVariantList data, std::list<double> octaves)
{
    qDebug() << "getOcavesMetrics data: " << data.size();

    auto origN0 = CG2(data, 0, data.size());
    auto N0 = round(origN0);
    auto origN0m = CG05(data, 0, N0-1);
    auto origN0p = CG05(data, N0+1, data.size());

    qDebug() << "getOcavesMetrics N0: " << origN0;
    qDebug() << "getOcavesMetrics N0-: " << origN0m;
    qDebug() << "getOcavesMetrics N0+: " << origN0p;

    double F0Min = octaves.front();
    double F0Step = (octaves.back() - octaves.front())/(octaves.size()-1);
    qDebug() << "getOcavesMetrics F0Min: " << F0Min;
    qDebug() << "getOcavesMetrics F0Step: " << F0Step;

    auto RF0 = origN0*F0Step+F0Min;

    auto DN = origN0p - origN0m;
    auto DF0 = (origN0p*F0Step+F0Min) - (origN0m*F0Step+F0Min);

    auto AN = (origN0p + origN0m) - 2*origN0;
    auto AF0 = AN*F0Step;

    qDebug() << "getOcavesMetrics RF0: " << RF0;
    qDebug() << "getOcavesMetrics DN: " << DN;
    qDebug() << "getOcavesMetrics DF0: " << DF0;
    qDebug() << "getOcavesMetrics AN: " << AN;
    qDebug() << "getOcavesMetrics AF0: " << AF0;

    QVariantList result;
    result.append(N0);             // 0  round N0
    result.append(round(origN0m)); // 1  round N0m
    result.append(round(origN0p)); // 2  round N0p
    result.append(RF0);            // 3  N0 in Hz
    result.append(DN);             // 4
    result.append(DF0);            // 5  DN in Hz
    result.append(AN);             // 6
    result.append(AF0);            // 7  AN in Hz
    result.append(origN0);         // 8  N0
    result.append(origN0m);        // 9  N0-
    result.append(origN0p);        // 10 N0+
    return result;
}

QVariantList Backend::getPitchOcavesMetrics(QString path, bool isMale, bool cutted, bool isFull)
{
    this->initializeRecordCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto storage = this->core->getRecord();

    auto actaves = this->getOctavesSetting(isMale, isFull);

    auto mean = this->getSettingValue(ApplicationConfig::SETTINGS_OCTAVES_HISTOGRAM_MEAN).toBool();
    auto threshold = this->getSettingValue(ApplicationConfig::SETTINGS_HISTOGRAM_THRESHOLD).toDouble();

    auto data = calculatePitchSegmentsCount(storage, actaves, cutted, mean, threshold);

    auto result = getOcavesMetrics(data, actaves);

    return result;
}

QVariantList Backend::getTemplateOcavesMetrics(QString path, bool isMale, bool cutted, bool isFull)
{
    this->initializeTemplateCore(path);

    this->core->setPitchConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_ALGORITHM).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_OUTPUT_FORMAT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_FRAME_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_RAPT_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SWIPE_THRESHOLD).toDouble(),
        this->getSettingValue(ApplicationConfig::SETTINGS_PITCH_SAMPLING_FREQUENCY).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MINIMUM_F0_FEMALE).toDouble(),
        this->getSettingValue(isFull ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE :
                              isMale ? ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_MALE :
                                       ApplicationConfig::SETTINGS_PITCH_MAXIMUM_F0_FEMALE).toDouble()
    );

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto storage = this->core->getTemplate();

    auto octaves = this->getOctavesSetting(isMale, isFull);

    auto mean = this->getSettingValue(ApplicationConfig::SETTINGS_OCTAVES_HISTOGRAM_MEAN).toBool();
    auto threshold = this->getSettingValue(ApplicationConfig::SETTINGS_HISTOGRAM_THRESHOLD).toDouble();

    auto data = calculatePitchSegmentsCount(storage, octaves, cutted, mean, threshold);

    auto result = getOcavesMetrics(data, octaves);

    return result;
}

QVariantList Backend::getSegmentsByIntensity(QString path)
{
    this->initializeRecordCore(path);

    this->core->setIntensityConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SHIFT).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt(),
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SMOOTH_FRAME).toUInt()
    );

    this->core->setSegmentsConfig(
        this->getSettingValue(ApplicationConfig::SETTINGS_SEGMENTS_SEGMENTS_LENGTH_LIMIT).toUInt()
    );

    auto storage = this->core->getRecord();
    auto intensity = storage->getIntensity();

    auto data = storage->getAutoSegmentsByIntensitySmoothed();
//    qDebug() << "Segments by intensity count " << data.size();

    QVariantList segments;

    for (auto &it: data)
    {
        it.first = IntonCore::normalizeValue(it.first, intensity.size(), WAVE_LENGTH);
        it.second = IntonCore::normalizeValue(it.second, intensity.size(), WAVE_LENGTH);
        segments.append(QVariant::fromValue(QmlPoint(it.first, it.first + it.second)));
    }

    return segments;
}

QVariantList calculateSingerMetrics(QVariantList segmentsCount,
                                    QMap<QString, QStringList> segments,
                                    QStringList voiceLables)
{
    qDebug() << "calculateSingerMetrics:segmentsCount " << segmentsCount;
    qDebug() << "calculateSingerMetrics:segmentsCount len " << segmentsCount.size();

    QVariantList metrics;
    int maxI = 0;
    double max = std::numeric_limits<double>::min();
    double min = std::numeric_limits<double>::max();

    for (int i=0; i<voiceLables.size(); i++)
    {
        auto voiceLable = voiceLables.at(i);
        auto voiceData = segments.value(voiceLable);
        qDebug() << "voiceData " << voiceData;
        qDebug() << "voiceData len " << voiceData.size();

        auto metric = 0.0;

        for (auto i=0; i<segmentsCount.size() && i<voiceData.size(); i++)
        {
            metric += voiceData.at(i).toDouble() * segmentsCount.at(i).toDouble();
        }

        qDebug() << "metric " << voiceLable << " " << metric;
        metrics.append(metric);

        if (max <= metric)
        {
            max = metric;
            maxI = i;
        }

        if (min > metric)
        {
            min = metric;
        }
    }

    metrics.append(maxI);

    for (int i=0; i<voiceLables.size(); i++)
    {
        auto metric = metrics.at(i).toDouble();
        metrics.replace(i, metric / max);
        qDebug() << "calculateSingerMetrics:metric " << i << ": " << metric;
    }

    return metrics;
}

QVariantList Backend::getSingerMetrics(QString path, bool isMale)
{
    auto segmentsCount = this->getPitchFrequencySegmentsCount(path, isMale);

    QStringList voiceLables;
    if (isMale)
    {
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_TENOR);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_BARITONE);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_BASS);
    } else {
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_CONTRALTO);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_MEZZOSOPRANO);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_SOPRANO);
    }

    QMap<QString, QStringList> segments;
    for (auto &voiceLable: voiceLables)
    {
        segments.insert(voiceLable,
                        this->getSettingValue(voiceLable)
                            .toString()
                            .split(ApplicationConfig::SETTINGS_TYPE_LIST_DELIMETER));
    }

    return calculateSingerMetrics(segmentsCount, segments, voiceLables);
}

QVariantList Backend::getTemplateSingerMetrics(QString path, bool isMale)
{
    auto segmentsCount = this->getTemplatePitchFrequencySegmentsCount(path, isMale);

    QStringList voiceLables;
    if (isMale)
    {
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_TENOR);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_BARITONE);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_BASS);
    } else {
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_CONTRALTO);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_MEZZOSOPRANO);
        voiceLables.append(ApplicationConfig::SETTINGS_VOICE_SOPRANO);
    }

    QMap<QString, QStringList> segments;
    for (auto &voiceLable: voiceLables)
    {
        segments.insert(voiceLable,
                        this->getSettingValue(voiceLable)
                            .toString()
                            .split(ApplicationConfig::SETTINGS_TYPE_LIST_DELIMETER));
    }

    return calculateSingerMetrics(segmentsCount, segments, voiceLables);
}

QString Backend::getPath()
{
    return this->path;
}

void Backend::setPath(const QString &path)
{
    qDebug() << "set path: " << path;
    this->path = path;
}

void Backend::initializeCore(bool reinit)
{
    qDebug() << "Backend::initializeCore " << reinit;
    if (this->core != nullptr && !reinit) return;

    if (this->core != nullptr)
    {
        qDebug() << "Backend::initializeCore: Delete core";
        delete this->core;
        this->core = nullptr;
    }

    QString recordsPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
    QString logPath = QDir(recordsPath).absoluteFilePath("core.log");
    qDebug() << "Backend::initializeCore: logPath: " << logPath;

    //Settings * settings = Settings::getInstance();

    qDebug() << "Backend::initializeCore: Initialize core: " << this->path;
    this->core = new IntonCore::Core(
        this->path.toStdString()//,
        //settings->getConfig()
    );
    qDebug() << "Backend::initializeCore: Initialize core complete";
}

void Backend::initializeRecordCore(const QString& path)
{
    qDebug() << "Backend::initializeRecordCore: path" << path;
    if (this->path == path)
    {
        qDebug() << "Backend::initializeRecordCore: ok";
        return;
    }
    qDebug() << "Backend::initializeRecordCore: old path" << this->path;

    if (!path.isEmpty())
    {
        qDebug() << "Backend::initializeRecordCore: initialize core" << path;
        this->initializeCore();
        if (path.startsWith("content:"))
        {
            QFile qfile(QQmlFile::urlToLocalFileOrQrc(path));
            if (!qfile.open(QFile::ReadOnly)) {
                qDebug() << "Backend::initializeRecordCore: failed to load file" << path;
                return;
            }

            auto temporary_file = QTemporaryFile::createNativeFile(qfile);
            auto full_path = temporary_file->fileName();
            qDebug() << "initializeCore: load wav file" << full_path;
            WaveFile * file = IntonCore::Helpers::openWaveFile(full_path.toStdString());
            qDebug() << "initializeCore: reload record" << full_path;

            this->core->reloadRecord(file);
        } else {
            qDebug() << "Backend::initializeRecordCore: load wav file" << path;
            WaveFile * file = IntonCore::Helpers::openWaveFile(path.toStdString());
            qDebug() << "Backend::initializeRecordCore: reload record" << path;
            this->core->reloadRecord(file);
        }
    }

    this->setPath(path);
}

void Backend::initializeTemplateCore(const QString& path)
{
    qDebug() << "initializeTemplateCore: path" << path;
    if (this->template_path == path)
    {
        qDebug() << "initializeTemplateCore: ok";
        return;
    }
    qDebug() << "initializeTemplateCore: old path" << this->template_path;

    if (!path.isEmpty())
    {
        qDebug() << "initializeTemplateCore: initialize core" << path;
        this->initializeCore();
        qDebug() << "initializeTemplateCore: load wav file" << path;
        WaveFile * file = IntonCore::Helpers::openWaveFile(path.toStdString());
        qDebug() << "initializeTemplateCore: reload template" << path;
        this->core->reloadTemplate(file);
    }

    this->setPath(path);
}

void Backend::moveTemplateToRecord()
{
    if (this->core == nullptr) return;
    qDebug() << "moveTemplateToRecord";
    auto storage = this->core->popTemplate();
    qDebug() << "storage: " << (storage == nullptr);
    this->core->setRecord(storage);
}

void Backend::moveRecordToTemplate()
{
    if (this->core == nullptr) return;
    qDebug() << "moveRecordToTemplate";
    auto storage = this->core->popRecord();
    qDebug() << "storage: " << (storage == nullptr);
    this->core->setTemplate(storage);
}
