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
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/
 
#include <qqml.h>
#include "qstyleplugin.h"
#include "qstyleitem.h"
#include "qrangemodel.h"
#include "qtmenu.h"
#include "qtmenubar.h"
#include "qwindowitem.h"
#include "qwindowitem.h"
#include "qdesktopitem.h"
#include "qwheelarea.h"
#include "qcursorarea.h"
#include "qtooltiparea.h"
#include "qtsplitterbase.h"
#include <qqmlextensionplugin.h>

#include <qqmlengine.h>
#include <qquickimageprovider.h>
#include <QtWidgets/QApplication>
#include <QImage>

// Load icons from desktop theme
class DesktopIconProvider : public QQuickImageProvider
{
public:
    DesktopIconProvider()
        : QQuickImageProvider(QQuickImageProvider::Pixmap)
    {
    }

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        Q_UNUSED(requestedSize);
        Q_UNUSED(size);
        int pos = id.lastIndexOf('/');
        QString iconName = id.right(id.length() - pos);
        int width = requestedSize.width();
        return QIcon::fromTheme(iconName).pixmap(width);
    }
};


void StylePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<QStyleItem>(uri, 0, 2, "StyleItem");
    qmlRegisterType<QCursorArea>(uri, 0, 2, "CursorArea");
    qmlRegisterType<QTooltipArea>(uri, 0, 2, "TooltipArea");
    qmlRegisterType<QRangeModel>(uri, 0, 2, "RangeModel");
    qmlRegisterType<QWheelArea>(uri, 0, 2, "WheelArea");

    qmlRegisterType<QtMenu>(uri, 0, 2, "Menu");
    qmlRegisterType<QtMenuBar>(uri, 0, 2, "MenuBar");
    qmlRegisterType<QtMenuItem>(uri, 0, 2, "MenuItem");
    qmlRegisterType<QtMenuSeparator>(uri, 0, 2, "Separator");

    qmlRegisterType<QFileSystemModel>(uri, 0, 2, "FileSystemModel");
    qmlRegisterType<QtSplitterBase>(uri, 0, 2, "Splitter");
    qmlRegisterType<QWindowItem>("QtQuick", 2, 0, "Window"); // override built-in Window

    qmlRegisterUncreatableType<QtMenuBase>("uri", 0, 1, "NativeMenuBase", QLatin1String("Do not create objects of type NativeMenuBase"));
    qmlRegisterUncreatableType<QDesktopItem>(uri, 0,2,"Desktop", QLatin1String("Do not create objects of type Desktop"));
}

void StylePlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    engine->addImageProvider("desktoptheme", new DesktopIconProvider);
}
