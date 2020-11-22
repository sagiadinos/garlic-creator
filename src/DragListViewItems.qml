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
import QtQml 2.12
import QtQuick.Controls 2.12
import QtQml.Models 2.12

Component
{
    id: dragListViewItems
    MouseArea
    {
        id: dragArea

        property bool held: false

        anchors { left: parent.left; right: parent.right }
        height: content.height

        drag.target: held ? content : undefined
        drag.axis: Drag.YAxis

        onPressAndHold: held = true
        onReleased: held = false

        Rectangle
        {
            id: content
            anchors
            {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            width: dragArea.width; height: column.implicitHeight + 4


            border.width: 1
            border.color: "#000000"

            color: dragArea.held ? "lightsteelblue" : "white"
            Behavior on color { ColorAnimation { duration: 100 } }

            radius: 2

            Drag.active: dragArea.held
            Drag.source: dragArea
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            states: State {
                when: dragArea.held

                ParentChange { target: content; parent: root.contentItem}
                AnchorChanges {
                    target: content
                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                }
            }

            Row
            {
                id: column
                anchors { fill: parent; margins: 2 }
                spacing: 1
                Rectangle
                {
                    color: dragArea.held ? "lightsteelblue" : "#cccccc"
                    Behavior on color { ColorAnimation { duration: 100 } }
                    width: 200
                    height: 100
                    Image
                    {
                        id: imageItem
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Image.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Image.AlignVCenter
                        fillMode: Image.Pad
                        sourceSize.width: 160
                        sourceSize.height: 90
                        source: thumbnail_url
                    }
                }
                Column
                {
                    Text
                    {
                      font.pixelSize: 10
                      text: file_url
                    }
                    Row
                    {
                        spacing:10
                        SpinBox
                        {
                          id: durationItem
                          to:99999
                          editable: true;
                          anchors.verticalCenter: parent.verticalCenter
                          font.pixelSize: 20
                          value: duration
                        }
                        Text
                        {
                          anchors.leftMargin: 400
                          anchors.verticalCenter: parent.verticalCenter
                          font.pixelSize: 20
                          text: qsTr("s")
                        }
                    }
                }
            }

        }
        DropArea
        {
            anchors { fill: parent; margins: 10 }

            onEntered:
            {
                var model_index = drag.source.DelegateModel.itemsIndex;
                var view_index = dragArea.DelegateModel.itemsIndex;
                visualModel.items.move(model_index, view_index); // change position in View
                playlistModel.move(model_index, view_index, 1) // change position in Model
            }
         }
    }

}

