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
import QtQuick 2.12
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.1 // must before Controls else Menubar not work
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import com.sagiadinos.garlic.creator.filesystem 1.0

ApplicationWindow
{
    id: root
    visible: true
    width: 640; height: 480
    footer: ToolBar
    {
        RowLayout
        {
          anchors.fill: parent
          ToolButton
          {
              text: qsTr("Add Media")
              onClicked: addFileDialog.open()
          }
          ToolButton
          {
              text: qsTr("Add Uri (Website)")
              onClicked: addUriDialog.open()
          }
          ToolButton
          {
              text: qsTr("Export Playlist")
              onClicked: selectFolderDialog.open()
          }
          ToolButton
          {
              text: qsTr("Options")
          }
       }
    }
    SaveDialog        {id: selectFolderDialog}
    FileSystem        {id: fileSystem}
    UriDialog         {id: addUriDialog}
    MediaDialog       {id: addFileDialog}
    DragListViewItems {id: dragListViewItems}

    DelegateModel
    {
        id: visualModel
        model: playlistModel
        delegate: dragListViewItems
    }

    ListView
    {
       id: playlistView
       anchors { fill: parent; margins: 2 }

       model: visualModel

       spacing: 4
       cacheBuffer: 50
   }


    ListModel
    {
        id: playlistModel
    }
}
