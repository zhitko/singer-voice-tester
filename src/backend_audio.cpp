#include "backend.h"

#include <QDebug>
#include <QSound>

#include "pcm_recorder.h"

void Backend::initializeRecorder()
{
    this->recorder = PcmRecorder::getInstance();
}

void Backend::initializeAudio()
{

}

void Backend::playWaveFile(QString path, bool stop)
{
    if (!stop)
    {
        if (!stop && this->sound) this->sound->deleteLater();
        this->sound = new QSound(path);
        this->sound->play();
    }
    else if (stop && this->sound)
    {
        this->sound->stop();
    }
}

QString Backend::startStopRecordWaveFile(bool reloadPath = true)
{
    QString path = "";
    if (!this->recorder->isRecording())
    {
        qDebug() << "Backend::startStopRecordWaveFile: start recording";
        path = this->recorder->startRecording();
        if (reloadPath) {
            this->path = path;
        }
    } else {
        qDebug() << "Backend::startStopRecordWaveFile: stop recording";
        WaveFile * file = this->recorder->stopRecording();
        path = file->filePath;
        qDebug() << "Backend::startStopRecordWaveFile: reset wave file " << file;
        if (reloadPath) {
            this->initializeCore();
            this->core->reloadRecord(file);
        }
    }

    qDebug() << "Backend::startStopRecordWaveFile: complete - " << path;
    return path;
}
