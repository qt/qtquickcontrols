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

#include "qdeclarative.h"
#include "qmldesktopviewer.h"
#include "qdeclarativeengine.h"
#include "loggerwidget.h"
#include <QWidget>
#include <QDir>
#include <QApplication>
#include <QTranslator>
#include <QDebug>
#include <QMessageBox>
#include <QAtomicInt>
#include <QFileOpenEvent>

QT_USE_NAMESPACE

QtMsgHandler systemMsgOutput = 0;

static QmlDesktopViewer *openFile(const QString &fileName);

QString warnings;
void exitApp(int i)
{
#ifdef Q_OS_WIN
    // Debugging output is not visible by default on Windows -
    // therefore show modal dialog with errors instead.
    if (!warnings.isEmpty()) {
        QMessageBox::warning(0, QApplication::tr("Qt QML Viewer"), warnings);
    }
#endif
    exit(i);
}

QWeakPointer<LoggerWidget> logger;
static QAtomicInt recursiveLock(0);

void myMessageOutput(QtMsgType type, const char *msg)
{
    QString strMsg = QString::fromLatin1(msg);

    if (!QCoreApplication::closingDown()) {
        if (!logger.isNull()) {
            if (recursiveLock.testAndSetOrdered(0, 1)) {
                QMetaObject::invokeMethod(logger.data(), "append", Q_ARG(QString, strMsg));
                recursiveLock = 0;
            }
        } else {
            warnings += strMsg;
            warnings += QLatin1Char('\n');
        }
    }

    if (systemMsgOutput) {
        systemMsgOutput(type, msg);
    } else { // Unix
        fprintf(stderr, "%s\n", msg);
        fflush(stderr);
    }
}

static QmlDesktopViewer* globalViewer = 0;

// The qml file that is shown if the user didn't specify a QML file
QString initialFile = "qrc:/startup/startup.qml";

void usage()
{
    qWarning("Usage: qmlviewer [options] <filename>");
    qWarning(" ");
    qWarning(" options:");
    qWarning("  -v, -version ............................. display version");
    qWarning("  -warnings [show|hide]..................... show warnings in a separate log window");
    qWarning("  -translation <translationfile> ........... set the language to run in");
    qWarning("  -I <directory> ........................... prepend to the module import search path,");
    qWarning("                                             display path if <directory> is empty");
    qWarning("  -P <directory> ........................... prepend to the plugin search path");
#if defined(Q_WS_MAC)
    qWarning("  -no-opengl ............................... don't use a QGLWidget for the viewport");
#else
    qWarning("  -opengl .................................. use a QGLWidget for the viewport");
#endif
    qWarning(" ");
    qWarning(" Press F1 for interactive help");

    exitApp(1);
}

enum WarningsConfig { ShowWarnings, HideWarnings, DefaultWarnings };

struct ViewerOptions
{
    ViewerOptions()
        : useGL(false),
          warningsConfig(DefaultWarnings),
          sizeToView(true)
    {
#if defined(Q_WS_MAC)
        useGL = true;
#endif
    }

    QStringList imports;
    QStringList plugins;
    QString translationFile;
    bool useGL;
    WarningsConfig warningsConfig;
    bool sizeToView;
};

static ViewerOptions opts;
static QStringList fileNames;

class Application : public QApplication
{
    Q_OBJECT
public:
    Application(int &argc, char **&argv)
        : QApplication(argc, argv)
    {}

protected:
    bool event(QEvent *ev)
    {
        if (ev->type() != QEvent::FileOpen)
            return QApplication::event(ev);

        QFileOpenEvent *fev = static_cast<QFileOpenEvent *>(ev);

        globalViewer->open(fev->file());

        return true;
    }

private Q_SLOTS:
    void showInitialViewer()
    {
        QApplication::processEvents();

        QmlDesktopViewer *viewer = globalViewer;
        if (!viewer)
            return;
    }
};

static void parseCommandLineOptions(const QStringList &arguments)
{
    for (int i = 1; i < arguments.count(); ++i) {
        bool lastArg = (i == arguments.count() - 1);
        QString arg = arguments.at(i);
        if (arg == QLatin1String("-v") || arg == QLatin1String("-version")) {
            qWarning("Qt QML Viewer version %s", QT_VERSION_STR);
            exitApp(0);
        } else if (arg == "-translation") {
            if (lastArg) usage();
            opts.translationFile = arguments.at(++i);
#if defined(Q_WS_MAC)
        } else if (arg == "-no-opengl") {
            opts.useGL = false;
#else
        } else if (arg == "-opengl") {
            opts.useGL = true;
#endif
        } else if (arg == "-warnings") {
            if (lastArg) usage();
            QString warningsStr = arguments.at(++i);
            if (warningsStr == QLatin1String("show")) {
                opts.warningsConfig = ShowWarnings;
            } else if (warningsStr == QLatin1String("hide")) {
                opts.warningsConfig = HideWarnings;
            } else {
                usage();
            }
        } else if (arg == "-I" || arg == "-L") {
            if (arg == "-L")
                qWarning("-L option provided for compatibility only, use -I instead");
            if (lastArg) {
                QDeclarativeEngine tmpEngine;
                QString paths = tmpEngine.importPathList().join(QLatin1String(":"));
                qWarning("Current search path: %s", paths.toLocal8Bit().constData());
                exitApp(0);
            }
            opts.imports << arguments.at(++i);
        } else if (arg == "-P") {
            if (lastArg) usage();
            opts.plugins << arguments.at(++i);
        } else if (!arg.startsWith('-')) {
            fileNames.append(arg);
        } else if (true || arg == "-help") {
            usage();
        }
    }

}

static QmlDesktopViewer *createViewer()
{
    QmlDesktopViewer *viewer = new QmlDesktopViewer;

    foreach (QString lib, opts.imports)
        viewer->addLibraryPath(lib);

    foreach (QString plugin, opts.plugins)
        viewer->addPluginPath(plugin);

    return viewer;
}

QmlDesktopViewer *openFile(const QString &fileName)
{
    globalViewer->open(fileName);
    return globalViewer;
}

int main(int argc, char ** argv)
{
    systemMsgOutput = qInstallMsgHandler(myMessageOutput);

#if defined (Q_WS_X11) || defined (Q_WS_MAC)
    //### default to using raster graphics backend for now
    bool gsSpecified = false;
    for (int i = 0; i < argc; ++i) {
        QString arg = argv[i];
        if (arg == "-graphicssystem") {
            gsSpecified = true;
            break;
        }
    }

    if (!gsSpecified)
        QApplication::setGraphicsSystem("raster");
#endif

    Application app(argc, argv);
    app.setApplicationName("QMLDesktop");
    app.setOrganizationName("Nokia");
    app.setOrganizationDomain("nokia.com");
//    app.setAttribute(Qt::AA_DontUseNativeMenuBar);

    QmlDesktopViewer::registerTypes();

    parseCommandLineOptions(app.arguments());

    QTranslator qmlTranslator;
    if (!opts.translationFile.isEmpty()) {
        if (qmlTranslator.load(opts.translationFile)) {
            app.installTranslator(&qmlTranslator);
        } else {
            qWarning() << "Could not load the translation file" << opts.translationFile;
        }
    }

    if (fileNames.isEmpty()) {
        QFile qmlapp(QLatin1String("qmlapp"));
        if (qmlapp.exists() && qmlapp.open(QFile::ReadOnly)) {
            QString content = QString::fromUtf8(qmlapp.readAll());
            qmlapp.close();

            int newline = content.indexOf(QLatin1Char('\n'));
            if (newline >= 0)
                fileNames += content.left(newline);
            else
                fileNames += content;
        }
    }

    globalViewer = createViewer();

    if (fileNames.isEmpty()) {
        // show the initial viewer delayed.
        // This prevents an initial viewer popping up while there
        // are FileOpen events coming through the event queue
        QTimer::singleShot(1, &app, SLOT(showInitialViewer()));
    } else {
        foreach (const QString &fileName, fileNames)
            openFile(fileName);
    }

    QObject::connect(&app, SIGNAL(lastWindowClosed()), globalViewer, SLOT(quit()));

    int ret = app.exec();
    delete globalViewer;
    return ret;
}

#include "main.moc"

