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
import com.sagiadinos.garlic.creator.restclient 1.0

ApplicationWindow
{
    id: root
    visible: true
    width: 640; height: 480
    property string token: ""
    header: ToolBar
    {
        RowLayout
        {
            TextField
            {
                id: playerIP
                horizontalAlignment: TextInput.AlignLeft
                placeholderText: qsTr("Enter Player IP")
                width: 10
                validator: RegExpValidator{regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/}
                selectByMouse: true
              //  text: "192.168.1.106"
            }
            ToolButton
            {
                id: btConnect
                text: qsTr("connect")
                onClicked:
                {
                    determineToken();//restClient.determineToken(playerIP.text);
                }
                function determineToken()
                {
                    var xmlhttp = new XMLHttpRequest();
                    var url = "http://" + playerIP.text + ":8080/v2/oauth2/token";
                    var params = "grant_type=password&username=admin&password=";
                    btConnect.text = qsTr("trying …");
                    xmlhttp.onreadystatechange=function()
                    {
                        if (xmlhttp.readyState == 4)
                        {
                            if (xmlhttp.status == 200)
                            {
                                var obj = JSON.parse(xmlhttp.responseText);
                                root.token = obj.access_token;
                                playerIP.color = "green";
                                sendSmilData.enabled = true;
                            }
                            else
                            {
                                root.token = "";
                                playerIP.color = "red";
                                sendSmilData.enabled = false;
                            }
                            btConnect.text = qsTr("connect");
                        }
                    }
                    xmlhttp.open("POST", url, true);
                    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    xmlhttp.setRequestHeader("Content-length", params.length);
                    xmlhttp.setRequestHeader("Connection", "close");
                    xmlhttp.send(params);
                }

            }
            ToolButton
            {
                id: sendSmilData
                text: qsTr("send SMIL")
                enabled: false;
                onClicked:
                {
                    restClient.setToken(root.token);
                    restClient.setIP(playerIP.text);
                    var smil_content = "";
                    for(var i = 0; i < playlistModel.count; i++)
                    {
                        var str = playlistModel.get(i).file_url;
                        if (playlistModel.get(i).file_type != "website")
                            restClient.addMediaQueue(playlistModel.get(i).file_url);

                        var file_name = str.slice(str.lastIndexOf("/")+1);

                        // write smil content with relative media directory path
                        var smil_tag = "";
                        var dur      = "";
                        if (playlistModel.get(i).duration > 0)
                        {
                            dur = 'dur="' + playlistModel.get(i).duration +'s"'
                        }

                        switch (playlistModel.get(i).file_type)
                        {
                            case "image":
                                 smil_tag = "\t\t\t" + '<img src="' + file_name + '" ' + dur + ' />' + "\n"
                                break;
                            case "video":
                                smil_tag = "\t\t\t" + '<video src="' + file_name + '" ' + dur + ' />' + "\n"
                                break;
                            case "audio":
                                smil_tag = "\t\t\t" + '<audio src="' + file_name + '" ' + dur + ' />' + "\n"
                                break;
                            case "webwidget":
                                smil_tag = "\t\t\t" + '<ref src="' + file_name + '" ' + dur + ' type="application/widget" />' + "\n"
                                break;
                            case "website":
                                smil_tag = "\t\t\t" + '<ref src="' + str + '" ' + dur + ' type="text/html" />' + "\n"
                                break;

                        }
                        smil_content += smil_tag;
                    }
                    var path = StandardPaths.writableLocation(StandardPaths.CacheLocation);
                    fileSystem.createIndexSmil(path + "/index.smil", smil_content);
                    restClient.addMediaQueue(path + "/index.smil");
                    restClient.sendMedia();
                }
            }
        }

    }
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
/*          ToolButton
          {
              text: qsTr("Options")
          }
*/       }
    }
    SaveDialog        {id: selectFolderDialog}
    FileSystem        {id: fileSystem}
    RestClient        {id: restClient}
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
