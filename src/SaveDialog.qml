import QtQuick 2.0
import QtQuick.Dialogs 1.2
import Qt.labs.platform 1.1 // must before Controls else Menubar not work

FolderDialog
{
    id: selectFolderDialog
    title: qsTr("Choose a folder")
    folder: StandardPaths.writableLocation(StandardPaths.DesktopLocation);

    onAccepted:
    {
       // Create Directory from selectFolderDialog
       var media_dir = selectFolderDialog.currentFolder + "/media";
       fileSystem.createDirectory(media_dir);
       var smil_content = "";
       for(var i = 0; i < playlistModel.count; i++)
       {
           // copy files to media directory
           var str       = playlistModel.get(i).file_url;
           var file_name = str.slice(str.lastIndexOf("/")+1);
           fileSystem.copyFile(str, media_dir + "/" + file_name);
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
                    smil_tag = "\t\t\t" + '<img src="./media/' + file_name + '" ' + dur + ' />' + "\n"
                   break;
               case "video":
                   smil_tag = "\t\t\t" + '<video src="./media/' + file_name + '" ' + dur + ' />' + "\n"
                   break;
               case "audio":
                   smil_tag = "\t\t\t" + '<audio src="./media/' + file_name + '" ' + dur + ' />' + "\n"
                   break;
               case "webwidget":
                   smil_tag = "\t\t\t" + '<ref src="./media/' + file_name + '" ' + dur + ' type="application/widget" />' + "\n"
                   break;
               case "website":
                   smil_tag = "\t\t\t" + '<ref src="./media/' + str + '" ' + dur + ' type="text/html" />' + "\n"
                   break;

           }
           smil_content += smil_tag;
       }

       fileSystem.createIndexSmil(selectFolderDialog.currentFolder + "/index.smil", smil_content);
    }
    onRejected: selectFolderDialog.visible = false
}
