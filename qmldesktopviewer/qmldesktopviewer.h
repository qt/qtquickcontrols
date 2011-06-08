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

#ifndef QMLDESKTOPVIEWER_H
#define QMLDESKTOPVIEWER_H

#include <QMainWindow>
#include <QTimer>
#include <QTime>
#include <QList>
#include <QtDeclarative>
#include <QDebug>

//#include "loggerwidget.h"

QT_BEGIN_NAMESPACE

class QDeclarativeView;
class QTranslator;
class QActionGroup;
class QMenuBar;
class LoggerWidget;

class QDesktop : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int width READ width)
    Q_PROPERTY(int height READ height)

public:
    QDesktop(QObject* obj) : QObject(obj) {}

    int width() const
    {
        return 1280;
    }

    int height() const
    {
        return 860;
    }

    static QDesktop *qmlAttachedProperties(QObject *obj) {
        qDebug() << "qmlAttachedProperties called";
        return new QDesktop(obj);
    }
};

class QDeclarativeViewer
    : public QMainWindow
{
    Q_OBJECT

public:
    QDeclarativeViewer(QWidget *parent = 0, Qt::WindowFlags flags = 0);
    ~QDeclarativeViewer();

    static void registerTypes();

    void addLibraryPath(const QString& lib);
    void addPluginPath(const QString& plugin);
    void setUseGL(bool use);

    QDeclarativeView *view() const;
    LoggerWidget *loggerWidget() const;
    QString currentFile() const { return currentFileOrUrl; }

public slots:
    void sceneResized(QSize size);
    bool open(const QString&);
    void openFile();
    void openUrl();
    void reload();
    void statusChanged();
    void launch(const QString &);

protected:
    virtual void keyPressEvent(QKeyEvent *);
    virtual bool event(QEvent *);
    void createMenu();

private slots:
    void appAboutToQuit();

    void showLoggerWindow(bool show);
    void loggerWidgetOpened();
    void loggerWidgetClosed();

private:
    void updateSizeHints(bool initial = false);

    LoggerWidget *loggerWindow;
    QDeclarativeView *canvas;
    QSize initialSize;
    QString currentFileOrUrl;
    QAction *_showLoggerWindow;

    QTranslator *translator;
    void loadTranslationFile(const QString& directory);
};

QML_DECLARE_TYPEINFO(QDesktop, QML_HAS_ATTACHED_PROPERTIES)

QT_END_NAMESPACE

#endif // QMLDESKTOPVIEWER_H
