/*************************************************************************************
    garlic-creator: SMIL Authoring for Digital Signage
    Copyright (C) 2020 Nikolaos Sagiadinos <ns@smil-control.com>
    This file is part of the garlic-creator source code

    This program is free software: you can redistribute it and/or  modify
    it under the terms of the GNU Affero General Public License, version 3,
    as published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*************************************************************************************/

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
    QFile file(file_path);

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
#ifdef Q_OS_WIN
    if (file_path.indexOf("file:///") != -1)
    {
        return file_path.mid(8);
    }
#else
    if (file_path.indexOf("file://") != -1)
    {
        return file_path.mid(7);
    }
#endif
}
