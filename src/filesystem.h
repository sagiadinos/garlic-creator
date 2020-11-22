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
