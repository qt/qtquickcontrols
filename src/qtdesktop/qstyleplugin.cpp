/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
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
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
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
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <qqml.h>
#include "qstyleplugin.h"
#include "qstyleitem.h"
#include "qrangemodel.h"
#include "qtmenu.h"
#include "qtmenubar.h"
#include "qdesktopitem.h"
#include "qwheelarea.h"
#include "qtsplitterbase.h"
#include "qquicklinearlayout.h"
#include "qquickcomponentsprivate.h"
#include "qfiledialogitem.h"
#include <qqmlextensionplugin.h>

#include <qqmlengine.h>
#include <qquickimageprovider.h>
#include <QtWidgets/QApplication>
#include <QtQuick/QQuickWindow>
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

QObject *registerPrivateModule(QQmlEngine *engine, QJSEngine *jsEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(jsEngine);
    return new QQuickComponentsPrivate();
}

void StylePlugin::registerTypes(const char *uri)
{

    // Unfortunately animations do not work on mac without this hack
#ifdef Q_OS_MAC
    setenv("QML_BAD_GUI_RENDER_LOOP", "1", 0);
#endif

    qmlRegisterSingletonType<QQuickComponentsPrivate>(uri, 1, 0, "PrivateHelper", registerPrivateModule);

    qmlRegisterType<QStyleItem>(uri, 1, 0, "StyleItem");
    qmlRegisterType<QRangeModel>(uri, 1, 0, "RangeModel");
    qmlRegisterType<QWheelArea>(uri, 1, 0, "WheelArea");

    qmlRegisterType<QtMenu>(uri, 1, 0, "Menu");
    qmlRegisterType<QtMenuBar>(uri, 1, 0, "MenuBar");
    qmlRegisterType<QtMenuItem>(uri, 1, 0, "MenuItem");
    qmlRegisterType<QtMenuSeparator>(uri, 1, 0, "Separator");

    qmlRegisterType<QQuickComponentsRowLayout>(uri, 1, 0, "RowLayout");
    qmlRegisterType<QQuickComponentsColumnLayout>(uri, 1, 0, "ColumnLayout");
    qmlRegisterUncreatableType<QQuickComponentsLayout>(uri, 1, 0, "Layout",
                                                       QLatin1String("Do not create objects of type Layout"));

    qmlRegisterType<QFileDialogItem>(uri, 1, 0, "FileDialog");

    qmlRegisterType<QFileSystemModel>(uri, 1, 0, "FileSystemModel");
    qmlRegisterType<QtSplitterBase>(uri, 1, 0, "Splitter");
    qmlRegisterType<QQuickWindow>(uri, 1, 0, "Window");

    qmlRegisterUncreatableType<QtMenuBase>(uri, 1, 0, "NativeMenuBase", QLatin1String("Do not create objects of type NativeMenuBase"));
    qmlRegisterUncreatableType<QDesktopItem>(uri, 1, 0,"Desktop", QLatin1String("Do not create objects of type Desktop"));
}

void StylePlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    engine->addImageProvider("desktoptheme", new DesktopIconProvider);
}
