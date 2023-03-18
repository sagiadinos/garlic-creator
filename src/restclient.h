#ifndef RESTCLIENT_H
#define RESTCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QJsonValue>
#include <QJsonDocument>
#include <QJsonObject>
#include <QVariantMap>
#include <QJsonArray>
#include <QFileInfo>
#include <QQueue>
#include <QHttpPart>

class RestClient : public QObject
{
    Q_OBJECT
public:
    explicit RestClient(QObject *parent = nullptr);
    Q_INVOKABLE void determineToken(QString ip);
    Q_INVOKABLE void addMediaQueue(QString file_path);
    Q_INVOKABLE void sendMedia();
    Q_INVOKABLE void setToken(QString t);
    Q_INVOKABLE void setIP(QString i);

private:
    QString token = "";
    QString ip    = "";
    QString expires_in = "";
    QDateTime expire_date;
    QScopedPointer <QNetworkAccessManager>  manager_token, manager_media, manager_play;
    QQueue<QFileInfo> MediaQueue;
    void play();
private slots:
    void finishedTokenRequest(QNetworkReply *reply);
    void finishedMediaUpload(QNetworkReply *reply);

signals:
    void connected(bool is_connected);

};

#endif // RESTCLIENT_H
