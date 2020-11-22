#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include "filesystem.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("SmilControl");

    QApplication app(argc, argv);

    qmlRegisterType<FileSystem>("com.sagiadinos.garlic.creator.filesystem", 1, 0, "FileSystem");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
