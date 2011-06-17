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

QmlDesktopViewer::QmlDesktopViewer()
      : _window(new QWindow(this))
      ,  loggerWindow(new LoggerWidget(this))
      , _showLoggerWindow(0)
      , translator(0)
{
    QmlDesktopViewer::registerTypes();
    setWindowTitle(tr("Qt QML Viewer"));

    view()->setAttribute(Qt::WA_OpaquePaintEvent);
    view()->setAttribute(Qt::WA_NoSystemBackground);

    view()->setFocus();

    QObject::connect(view(), SIGNAL(sceneResized(QSize)), this, SLOT(sceneResized(QSize)));
    QObject::connect(view(), SIGNAL(statusChanged(QDeclarativeView::Status)), this, SLOT(statusChanged()));
    QObject::connect(view()->engine(), SIGNAL(quit()), this, SLOT(close()));

    QObject::connect(loggerWindow, SIGNAL(opened()), this, SLOT(loggerWidgetOpened()));
    QObject::connect(loggerWindow, SIGNAL(closed()), this, SLOT(loggerWidgetClosed()));

    createMenu();

    setCentralWidget(view());

    QObject::connect(qApp, SIGNAL(aboutToQuit()), this, SLOT(appAboutToQuit()));
}

QmlDesktopViewer::~QmlDesktopViewer()
{
    if (loggerWindow) {
        delete loggerWindow;
        loggerWindow = 0;
    }
}

LoggerWidget *QmlDesktopViewer::loggerWidget() const
{
    return loggerWindow;
}

void QmlDesktopViewer::createMenu()
{
    QAction *openAction = new QAction(tr("&Open..."), this);
    openAction->setShortcuts(QKeySequence::Open);
    connect(openAction, SIGNAL(triggered()), this, SLOT(openFile()));

    QAction *openUrlAction = new QAction(tr("Open &URL..."), this);
    connect(openUrlAction, SIGNAL(triggered()), this, SLOT(openUrl()));

    QAction *reloadAction = new QAction(tr("&Reload"), this);
    reloadAction->setShortcuts(QKeySequence::Refresh);
    connect(reloadAction, SIGNAL(triggered()), this, SLOT(reload()));

    _showLoggerWindow = new QAction(tr("Show Warnings"), this);
    _showLoggerWindow->setCheckable((true));
    _showLoggerWindow->setChecked(loggerWindow->isVisible());
    connect(_showLoggerWindow, SIGNAL(triggered(bool)), this, SLOT(showLoggerWindow(bool)));

    QAction *aboutAction = new QAction(tr("&About Qt..."), this);
    aboutAction->setMenuRole(QAction::AboutQtRole);
    connect(aboutAction, SIGNAL(triggered()), qApp, SLOT(aboutQt()));

    QAction *quitAction = new QAction(tr("&Quit"), this);
    quitAction->setMenuRole(QAction::QuitRole);
    quitAction->setShortcuts(QKeySequence::Quit);
    connect(quitAction, SIGNAL(triggered()), qApp, SLOT(quit()));

    QMenuBar *menu = menuBar();
    if (!menu)
        return;

    QMenu *fileMenu = menu->addMenu(tr("&File"));
    fileMenu->addAction(openAction);
    fileMenu->addAction(openUrlAction);
    fileMenu->addAction(reloadAction);
    fileMenu->addAction(_showLoggerWindow);
    fileMenu->addAction(quitAction);

    QMenu *helpMenu = menu->addMenu(tr("&Help"));
    helpMenu->addAction(aboutAction);
}

void QmlDesktopViewer::showLoggerWindow(bool show)
{
    loggerWindow->setVisible(show);
}

void QmlDesktopViewer::loggerWidgetOpened()
{
    _showLoggerWindow->setChecked(true);
}

void QmlDesktopViewer::loggerWidgetClosed()
{
    _showLoggerWindow->setChecked(false);
}

void QmlDesktopViewer::addLibraryPath(const QString& lib)
{
    view()->engine()->addImportPath(lib);
}

void QmlDesktopViewer::addPluginPath(const QString& plugin)
{
    view()->engine()->addPluginPath(plugin);
}

void QmlDesktopViewer::reload()
{
    open(currentFileOrUrl);
}

void QmlDesktopViewer::openFile()
{
    QString cur = view()->source().toLocalFile();
    QString fileName = QFileDialog::getOpenFileName(this, tr("Open QML file"), cur, tr("QML Files (*.qml)"));
    if (!fileName.isEmpty()) {
        QFileInfo fi(fileName);
        open(fi.absoluteFilePath());
    }
}

void QmlDesktopViewer::openUrl()
{
    QString cur = view()->source().toLocalFile();
    QString url= QInputDialog::getText(this, tr("Open QML file"), tr("URL of main QML file:"), QLineEdit::Normal, cur);
    if (!url.isEmpty())
        open(url);
}

void QmlDesktopViewer::statusChanged()
{
    if (view()->status() == QDeclarativeView::Ready) {
        initializeSize();
    }
}

void QmlDesktopViewer::launch(const QString& file_or_url)
{
    QMetaObject::invokeMethod(this, "open", Qt::QueuedConnection, Q_ARG(QString, file_or_url));
}

void QmlDesktopViewer::loadTranslationFile(const QString& directory)
{
    if (!translator) {
        translator = new QTranslator(this);
        QApplication::installTranslator(translator);
    }

    translator->load(QLatin1String("qml_" )+QLocale::system().name(), directory + QLatin1String("/i18n"));
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
    setWindowTitle(tr("%1 - Qt QML Desktop Viewer").arg(file_or_url));

    delete view()->rootObject();
    view()->engine()->clearComponentCache();
    QDeclarativeContext *ctxt = view()->rootContext();
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

            QFileInfo fi(fileName);
            loadTranslationFile(fi.path());
        } else {
            qWarning() << "qml cannot find file:" << fileName;
            return false;
        }
    }

    view()->setSource(url);

    return true;
}

void QmlDesktopViewer::sceneResized(QSize)
{
}

void QmlDesktopViewer::keyPressEvent(QKeyEvent *event)
{
    if (event->key() == Qt::Key_F1 || (event->key() == Qt::Key_1)) {
        qDebug() << "F1 - help\n"
                 << "F5 - reload QML\n";
    } else if (event->key() == Qt::Key_F5 || (event->key() == Qt::Key_5)) {
        reload();
    }

    QWidget::keyPressEvent(event);
}

void QmlDesktopViewer::setUseGL(bool useGL)
{
#ifdef GL_SUPPORTED
    if (useGL) {
        QGLFormat format = QGLFormat::defaultFormat();
#ifdef Q_WS_MAC
        format.setSampleBuffers(true);
#else
        format.setSampleBuffers(false);
#endif

        QGLWidget *glWidget = new QGLWidget(format);
        //### potentially faster, but causes junk to appear if top-level is Item, not Rectangle
        //glWidget->setAutoFillBackground(false);

        setViewport(glWidget);
    }
#else
    Q_UNUSED(useGL)
#endif
}

void QmlDesktopViewer::initializeSize()
{
    QSize newWindowSize = view()->initialSize();
    if (!isFullScreen() && !isMaximized()) {
        view()->setFixedSize(newWindowSize);
        resize(1, 1);
        layout()->setSizeConstraint(QLayout::SetFixedSize);
        layout()->activate();
    }
    layout()->setSizeConstraint(QLayout::SetNoConstraint);
    layout()->activate();
    setMinimumSize(minimumSizeHint());
    setMaximumSize(QSize(QWIDGETSIZE_MAX, QWIDGETSIZE_MAX));
    view()->setMinimumSize(QSize(0,0));
    view()->setMaximumSize(QSize(QWIDGETSIZE_MAX, QWIDGETSIZE_MAX));
}

void QmlDesktopViewer::registerTypes()
{
    static bool registered = false;

    if (!registered) {
        qDebug() << "registerying types now";
        // registering only for exposing the DeviceOrientation::Orientation enum
        qmlRegisterUncreatableType<QDesktop>("Qt",4,7,"Desktop", QLatin1String("Do not create objects of type Desktop"));
        qmlRegisterUncreatableType<QDesktop>("QtQuick",1,0,"Desktop",QLatin1String("Do not create objects of type Desktop"));
        registered = true;
    }
}

void QmlDesktopViewer::appAboutToQuit()
{
    // avoid QGLContext errors about invalid contexts on exit
    view()->setViewport(0);

    // avoid crashes if messages are received after app has closed
    if (loggerWindow) {
        delete loggerWindow;
        loggerWindow = 0;
    }
}

QT_END_NAMESPACE


