/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the examples of the Qt Toolkit.
**
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOTgall
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qmldesktopviewer.h"
#include "loggerwidget.h"
#include <qdeclarativeview.h>
#include <qdeclarativecontext.h>
#include <qdeclarativeengine.h>
#include <qdeclarative.h>

#include <QWidget>
#include <QApplication>
#include <QTranslator>
#include <QLayout>
#include <QMenuBar>
#include <QMenu>
#include <QAction>
#include <QFileDialog>
#include <QInputDialog>
#include <QGraphicsObject>
#include <QKeyEvent>
#include <QLocale>
#include <QDebug>

#ifdef GL_SUPPORTED
#include <QGLWidget>
#endif

QT_BEGIN_NAMESPACE

QmlDesktopViewer::QmlDesktopViewer() :
    _engine(new QDeclarativeEngine(this)), _rootObject(new QDeclarativeItem)
{
    _engine->setParent(this);
    QmlDesktopViewer::registerTypes();

    connect(_engine, SIGNAL(quit()), this, SLOT(quit()));
}

QmlDesktopViewer::~QmlDesktopViewer()
{
}

void QmlDesktopViewer::addLibraryPath(const QString& lib)
{
    engine()->addImportPath(lib);
}

void QmlDesktopViewer::addPluginPath(const QString& plugin)
{
    engine()->addPluginPath(plugin);
}

void QmlDesktopViewer::statusChanged()
{
}

bool QmlDesktopViewer::open(const QString& file_or_url)
{
    currentFileOrUrl = file_or_url;

    QUrl url;
    QFileInfo fi(file_or_url);
    if (fi.exists())
        url = QUrl::fromLocalFile(fi.absoluteFilePath());
    else
        url = QUrl(file_or_url);

    delete rootObject();
    engine()->clearComponentCache();
    QDeclarativeContext *ctxt = rootContext();
    ctxt->setContextProperty("qmlDesktopViewer", this);
    ctxt->setContextProperty("qmlDesktopViewerFolder", QDir::currentPath());

    QString fileName = url.toLocalFile();
    if (!fileName.isEmpty()) {
        fi.setFile(fileName);
        if (fi.exists()) {
            if (fi.suffix().toLower() != QLatin1String("qml")) {
                qWarning() << "qml cannot open non-QML file" << fileName;
                return false;
            }
        } else {
            qWarning() << "qml cannot find file:" << fileName;
            return false;
        }
    }

    execute(url);

    return true;
}

void QmlDesktopViewer::registerTypes()
{
    static bool registered = false;

    if (!registered) {
        // registering only for exposing the DeviceOrientation::Orientation enum
//        qmlRegisterUncreatableType<QDesktopItem>("Qt",4,7,"Desktop", QLatin1String("Do not create objects of type Desktop"));
//        qmlRegisterUncreatableType<QDesktopItem>("QtQuick",1,0,"Desktop",QLatin1String("Do not create objects of type Desktop"));
        registered = true;
    }
}

void QmlDesktopViewer::execute(QUrl url)
{
    _component = new QDeclarativeComponent(_engine, url, this);
    if (!_component->isLoading()) {
        continueExecute();
    } else {
        QObject::connect(_component, SIGNAL(statusChanged(QDeclarativeComponent::Status)), this, SLOT(continueExecute()));
    }
}

void QmlDesktopViewer::continueExecute()
{
    disconnect(_component, SIGNAL(statusChanged(QDeclarativeComponent::Status)), this, SLOT(continueExecute()));

    if (_component->isError()) {
        QList<QDeclarativeError> errorList = _component->errors();
        foreach (const QDeclarativeError &error, errorList) {
            qWarning() << error;
        }
        emit statusChanged(_component->status());
        return;
    }

    QObject *obj = _component->create();
    obj->setParent(_engine);

    if(_component->isError()) {
        QList<QDeclarativeError> errorList = _component->errors();
        foreach (const QDeclarativeError &error, errorList) {
            qWarning() << error;
        }
        emit statusChanged(_component->status());
        return;
    }

    _rootObject = qobject_cast<QGraphicsObject*>(obj);
    Q_ASSERT(_rootObject);
    emit statusChanged(_component->status());
}

void QmlDesktopViewer::quit()
{
    qApp->quit();
}

QT_END_NAMESPACE


