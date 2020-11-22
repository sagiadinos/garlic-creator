#ifndef FILESYSTEM_H
#define FILESYSTEM_H

#include <QObject>
#include <QDir>
#include <QTextStream>
#include <QRegularExpression>

class FileSystem : public QObject
{
    Q_OBJECT
public:
    FileSystem(QObject *parent = Q_NULLPTR);
    Q_INVOKABLE bool createDirectory(QString dir_name);
    Q_INVOKABLE void copyFile(QString source, QString destination);
    Q_INVOKABLE void createIndexSmil(QString destination, QString content);
    Q_INVOKABLE QString readFile(QString file_path);
private:
    QString cleanFilePath(QString file_path);
};

#endif // FILESYSTEM_H
