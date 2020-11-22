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

Dialog
{
    id: addUriDialog
    title: "Enter Url"
    width: 600
    standardButtons: StandardButton.Ok | StandardButton.Cancel
    focus: true
    onAccepted:
    {
        if (newUrlInput.text != "")
        {
            playlistModel.append({"thumbnail_url":"qrc:/icons/web.png", "file_url": newUrlInput.text, "duration": 15, "file_type": "website"});
        }
    }

    Column
    {
        anchors.fill: parent
        TextField
        {
            id: newUrlInput
            width: parent.width
            focus: true
            onFocusChanged: console.log("Focus changed " + focus)
        }

    }

}
