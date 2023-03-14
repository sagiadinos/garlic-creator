#include "restclient.h"

RestClient::RestClient(QObject *parent)
    : QObject{parent}
{
    manager_token.reset(new QNetworkAccessManager(this));
    connect(manager_token.data(), SIGNAL(finished(QNetworkReply*)), SLOT(finishedTokenRequest(QNetworkReply*)));

    manager_media.reset(new QNetworkAccessManager(this));
    manager_smil.reset(new QNetworkAccessManager(this));
}

void RestClient::determineToken(QString ip)
{
    QNetworkRequest request;
    request.setUrl(QUrl("http://" + ip + ":8080/v2/oauth2/token"));
    QUrlQuery query;
    query.addQueryItem("grant_type","password");
    query.addQueryItem("username","admin");
    query.addQueryItem("password","");
    QByteArray post_data = query.toString(QUrl::FullyEncoded).toUtf8();
    manager_token.data()->post(request, post_data);
}

void RestClient::sendMedia(QString source)
{

}

void RestClient::sendSMILIndex(QString source)
{

}

void RestClient::setToken(QString t)
{
    token = t;
}

void RestClient::finishedTokenRequest(QNetworkReply *reply)
{
    if (reply->error())
    {
        qDebug() << reply->errorString();
        return;
    }
    QString answer = reply->readAll();

    QJsonDocument jsonResponse = QJsonDocument::fromJson(answer.toUtf8());
    QJsonObject jsonObj = jsonResponse.object();

    token      = jsonObj["access_token"].toString();
    expires_in =  jsonObj["expires_in"].toString();
}
