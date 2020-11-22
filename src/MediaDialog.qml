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
import QtQuick 2.0
import Qt.labs.platform 1.1 // must before Controls else Menubar not work
import QtQuick.Controls 2.12

FileDialog
{
    id: addFileDialog
    title: qsTr("Choose some files")
    fileMode: FileDialog.OpenFiles // for multiple Files
    folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation);
    nameFilters: [ "Supported files (*.jpg *.png *.gif *.mp4 *.mkv *.mov *.avi *.wmv *.ts *.mp3 *.ogg *.wav *.wgt)", "All files (*)" ]
    onAccepted:
    {
       for(var i in addFileDialog.files)
       {
           var extension =  addFileDialog.files[i].split('.').pop();
           switch (extension)
           {
                case "jpg":
                case "gif":
                case "png":
                    playlistModel.append({"thumbnail_url":  addFileDialog.files[i], "file_url": addFileDialog.files[i], "duration": 10, "file_type": "image"});
                    break;
                case "mp4":
                case "mkv":
                case "mov":
                case "avi":
                case "wmv":
                case "ts":
                    playlistModel.append({"thumbnail_url":  "qrc:/icons/video.png", "file_url": addFileDialog.files[i], "duration": 0, "file_type": "video"});
                    break;
                case "mp3":
                case "ogg":
                case "wav":
                    playlistModel.append({"thumbnail_url":  "qrc:/icons/audio.png", "file_url": addFileDialog.files[i], "duration": 0, "file_type": "audio"});
                    break;
                case "wgt":
                    playlistModel.append({"thumbnail_url":  "qrc:/icons/html5.png", "file_url": addFileDialog.files[i], "duration": 10, "file_type": "webwidget"});
                    break;
           }

       }
    }
    onRejected: addFileDialog.visible = false
}
