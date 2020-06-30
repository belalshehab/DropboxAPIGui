# This Python file uses the following encoding: utf-8
import sys, os
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine, qmlRegisterType
from PySide2.QtCore import QUrl

from dbx_model import DBXModel

if __name__ == "__main__":
    sys.argv += ['--style', 'material']

    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    qmlRegisterType(DBXModel, "dropbox", 1, 0, "DBX")

    engine.load(QUrl("main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())
