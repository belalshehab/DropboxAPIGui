# This Python file uses the following encoding: utf-8
import sys
import psutil
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtCore import QUrl, QTimer, QAbstractListModel
from PySide2.QtCore import QObject, Signal, Slot, Property, Qt

import dropbox
from dropbox.files import WriteMode
from dropbox.exceptions import ApiError, AuthError


class DBXModel(QAbstractListModel):
    def __init__(self):
        QAbstractListModel.__init__(self)
        self.__token = ""
        self.__dbx = None
        self.__data = []

    tokenChanged = Signal(str)
    
    def get_token(self):
        return self.__token

    @Slot(str)
    def set_token(self, token):
        if self.__token == token:
            return
        print("newToken")
        self.__token = token
        self.tokenChanged.emit(self.__token)
        self.__dbx = dropbox.Dropbox(token)
        try:
            self.__dbx.users_get_current_account()
            self.update()
        except AuthError as err:
            print(err)

    token = Property(str, get_token, set_token, notify=tokenChanged)
        
    @Slot()
    def update(self):
        try:
            print("Trying to get data")
            self.__data = self.__dbx.files_list_folder('').entries
            print(self.__data)
            self.beginResetModel()
            self.endResetModel()
        except AuthError as err:
            print("err")

    def rowCount(self, parent):
        return len(self.__data)

    def data(self, index, role):
        if role == Qt.DisplayRole and index.row() >= 0 and index.row() < len(self.__data) and index.column() == 0:
            print(self.__data[index.row()].name)
            return self.__data[index.row()].name
        else:
            print("else")
            return None

    @Slot(int)
    def download(self, index):
        try:
            self.__dbx.files_download_to_file(self.__data[index].name, "/" + self.__data[index].name)
        except ApiError as err:
            print(err)

    @Slot(str)
    def upload(self, filePath):
        filePath = filePath[8:]
        name = filePath[filePath.rfind("/") : ]
        print( "name" + name)
        
        with open(filePath, 'rb') as f:
            d = f.read()
            print(len(d))

            try:
                self.__dbx.files_upload(d, name, mode=WriteMode('overwrite'))
            except ApiError as err:
                # This checks for the specific error where a user doesn't have
                # enough Dropbox space quota to upload this file
                if (err.error.is_path() and
                        err.error.get_path().reason.is_insufficient_space()):
                    sys.exit("ERROR: Cannot back up; insufficient space.")
                elif err.user_message_text:
                    print(err.user_message_text)
                    sys.exit()
                else:
                    print(err)
                    sys.exit()