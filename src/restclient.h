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

class RestClient : public QObject
{
    Q_OBJECT
public:
    explicit RestClient(QObject *parent = nullptr);
    Q_INVOKABLE void determineToken(QString ip);
    Q_INVOKABLE void sendMedia(QString source);
    Q_INVOKABLE void sendSMILIndex(QString source);
    Q_INVOKABLE void setToken(QString t);

private:
    QString token = "";
    QString expires_in = "";
    QDateTime expire_date;
    QScopedPointer <QNetworkAccessManager>  manager_token, manager_media, manager_smil;
private slots:
    void finishedTokenRequest(QNetworkReply *reply);

signals:
    void connected(bool is_connected);

};

#endif // RESTCLIENT_H
