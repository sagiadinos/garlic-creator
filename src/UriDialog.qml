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
