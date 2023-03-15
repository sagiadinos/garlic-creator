#include "restclient.h"

RestClient::RestClient(QObject *parent)
    : QObject{parent}
{
    manager_token.reset(new QNetworkAccessManager(this));
    connect(manager_token.data(), SIGNAL(finished(QNetworkReply*)), SLOT(finishedTokenRequest(QNetworkReply*)));
}

void RestClient::determineToken(QString i)
{
    ip = i;
    QNetworkRequest request;
    request.setUrl(QUrl("http://" + ip + ":8080/v2/oauth2/token"));
    QUrlQuery query;
    query.addQueryItem("grant_type","password");
    query.addQueryItem("username","admin");
    query.addQueryItem("password","");
    QByteArray post_data = query.toString(QUrl::FullyEncoded).toUtf8();
    manager_token.data()->post(request, post_data);
}

void RestClient::addMediaQueue(QString file_path)
{
    QFileInfo fi(file_path.mid(7));
    if (!fi.exists())
        return;
    MediaQueue.enqueue(fi);
}

void RestClient::sendMedia()
{  
    if (MediaQueue.empty())
        return;

    QFileInfo fi;
    fi = MediaQueue.dequeue();

    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    QHttpPart downloadPath;
    downloadPath.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"downloadPath\""));
    QString val = "/user-data/media/" + fi.fileName();
    downloadPath.setBody(val.toUtf8());

    QHttpPart fileSize;
    fileSize.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"fileSize\""));
    val = QString::number(fi.size());
    fileSize.setBody(val.toUtf8());

    QHttpPart filePart;
    filePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));
    filePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"data\"; filename=\""+fi.fileName()+"\""));
    QFile *file = new QFile(fi.absoluteFilePath());
    file->open(QIODevice::ReadOnly);
    filePart.setBodyDevice(file);
    file->setParent(multiPart);

    multiPart->append(downloadPath);
    multiPart->append(fileSize);
    multiPart->append(filePart);

    QUrl url(QUrl("http://" + ip + ":8080/v2/files/new?access_token=" + token));
    QNetworkRequest request(url);

    manager_media.reset(new QNetworkAccessManager(this));
    QNetworkReply *reply = manager_media.data()->post(request, multiPart);
    multiPart->setParent(reply);

    connect(manager_media.data(), SIGNAL(finished(QNetworkReply*)), SLOT(finishedMediaUpload(QNetworkReply*)));
}

void RestClient::play()
{
    QUrl url(QUrl("http://" + ip + ":8080/v2/app/exec?access_token=" + token));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject obj;
    obj["uri"] = "http://" + ip + ":8080/v2/user-data/index.smil";
    obj["packageName"] = "com.iadea.player.SmilActivity";
    obj["className"] = "com.iadea.player";
    QJsonDocument doc(obj);
    QByteArray post_data = doc.toJson();

    manager_play.reset(new QNetworkAccessManager(this));
    manager_play.data()->post(request, post_data);
}

void RestClient::setToken(QString t)
{
    token = t;
}

void RestClient::setIP(QString i)
{
    ip = i;
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

void RestClient::finishedMediaUpload(QNetworkReply *reply)
{
    if (reply->error())
        qDebug() << reply->readAll();

    sendMedia();
}
