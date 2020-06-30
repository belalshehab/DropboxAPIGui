import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Dialogs 1.0

import dropbox 1.0

ApplicationWindow {
    id: root
    width: 640
    height: 480
    color: "#333333"
    visible: true
    title: "CPU Load"
    Material.theme: Material.Dark

    FileDialog {
        id: fileDialog
        title: "Please choose a file to be uploaded"
        folder: shortcuts.home
        onAccepted: {
            dbx.upload(fileDialog.fileUrls)
        }
    }

    Label {
        id: label
        x: 275
        color: "#ffffff"
        text: qsTr("Simple Demo For Dropbox API")
        opacity: 0.7
        font.pointSize: 20
        font.family: "ROBOTO"
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        DeepLine{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.bottom
        }
    }


    RowLayout {
        id: rowLayout
        height: 50
        anchors.top: label.bottom
        anchors.topMargin: 30
        anchors.left: grayRectangle.left
        anchors.leftMargin: 0
        anchors.right: grayRectangle.right
        anchors.rightMargin: 0
        spacing: 10

        Label {
            id: label1
            color: "#f1f1f1"
            text: qsTr("TOKEN:")
            opacity: 0.7
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true
        }

        TextField {
            id: textField
            color: "#ffffff"
            opacity: 0.7
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

    GrayRectangle{
        id: grayRectangle
        anchors.bottomMargin: 10
        anchors.topMargin: 30
        anchors.rightMargin: 10
        anchors.top: rowLayout.bottom
        anchors.right: updateButton.left
        anchors.bottom: updateButton.top
        anchors.left: parent.left
        anchors.margins: 50

        Label {
            id: label2
            x: 275
            color: "#ffffff"
            text: qsTr("DropBox Files")
            opacity: 0.7
            font.pointSize: 20
            font.family: "ROBOTO"
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            DeepLine{
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.bottom
            }
        }
        ListView {
            id: listView
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            anchors.bottomMargin: 20
            anchors.top: label2.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 20

            spacing: 10
            ScrollBar.vertical: ScrollBar{ width: 6}

            model: DBX{
                id: dbx
                token: textField.text
            }
            delegate: Item{
                id: delegate
                height: 35
                width: parent.width
                RowLayout{
                    anchors.fill: parent
                    spacing: 2
                    Text {
                        id: name
                        text: model.display
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "#ffffff"
                        opacity: 0.7
                    }
                    Button{
                        text: "Download"
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        onClicked: dbx.download(model.index)
                    }
                }
                DeepLine{
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.bottom
                }
            }
        }
    }


    Button {
        id: updateButton
        text: qsTr("Update")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20

        onClicked: dbx.update()
    }

    Button {
        id: uploadButton
        x: 292
        y: 429
        text: qsTr("Upload File")
        anchors.right: updateButton.left
        anchors.rightMargin: 20
        anchors.bottom: updateButton.bottom
        anchors.bottomMargin: 0

        onClicked: fileDialog.open()
    }


}

/*##^##
Designer {
    D{i:1;anchors_y:42}D{i:2;anchors_width:428;anchors_x:71;anchors_y:94}
}
##^##*/
