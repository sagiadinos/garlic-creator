#include "filesystem.h"

FileSystem::FileSystem(QObject *parent) : QObject(parent)
{

}

bool FileSystem::createDirectory(QString dir_name)
{
    dir_name = cleanFilePath(dir_name); // clean files:// from uri
    QDir dir(dir_name);
    if (!dir.exists())
    {
       return dir.mkpath(dir_name);
    }
    return false;
}

void FileSystem::copyFile(QString source, QString destination)
{
    source      = cleanFilePath(source);
    destination = cleanFilePath(destination);

    if (QFile::exists(destination))
    {
        QFile::remove(destination);
    }

    QFile::copy(source,destination);
}

void FileSystem::createIndexSmil(QString destination, QString content)
{
    QFile file(cleanFilePath(destination));
    QRegExp regExp( "{INSERT_ELEMENTS}", Qt::CaseInsensitive, QRegExp::RegExp );
    QString tpl = readFile(QStringLiteral(":/index.smil.tpl"));
    if (tpl.contains("{INSERT_ELEMENTS}"))
    {
        tpl = tpl.replace("{INSERT_ELEMENTS}", content);
    }
    if(file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        QTextStream stream(&file);
        stream << tpl << '\n';
        file.close();
    }
}

QString FileSystem::readFile(QString file_path)
{
    QFile file(cleanFilePath(file_path));

    if(!file.open(QIODevice::ReadOnly))
    {
        return "";
    }

    QTextStream in(&file);
    QString content = "";
    while(!in.atEnd())
    {
        content += in.readLine() + '\n';
    }
    file.close();
    return content;
}

QString FileSystem::cleanFilePath(QString file_path)
{
    if (file_path.indexOf("file://") != -1)
    {
        file_path = file_path.mid(7);
    }
    return file_path;
}
