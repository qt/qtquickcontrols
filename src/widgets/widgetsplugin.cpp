/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Dialogs module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include <QtQml/qqmlextensionplugin.h>
#include <QtQml/qqml.h>
#include "qquickqmessagebox_p.h"
#include "qquickqfiledialog_p.h"
#include "qquickqcolordialog_p.h"
#include "qquickqfontdialog_p.h"

QT_BEGIN_NAMESPACE

/*!
    \qmlmodule QtQuick.PrivateWidgets 1
    \title QWidget QML Types
    \ingroup qmlmodules
    \brief Provides QML types for certain QWidgets
    \internal

    This QML module contains types which should not be depended upon in Qt Quick
    applications, but are available if the Widgets module is linked. It is
    recommended to load components from this module conditionally, if at all,
    and to provide fallback implementations in case they fail to load.

    \code
    import QtQuick.PrivateWidgets 1.1
    \endcode

    \since 5.1
*/

class QtQuick2PrivateWidgetsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")

public:
    virtual void registerTypes(const char *uri)
    {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("QtQuick.PrivateWidgets"));

        qmlRegisterType<QQuickQMessageBox>(uri, 1, 1, "QtMessageDialog");
        qmlRegisterType<QQuickQFileDialog>(uri, 1, 0, "QtFileDialog");
        qmlRegisterType<QQuickQColorDialog>(uri, 1, 0, "QtColorDialog");
        qmlRegisterType<QQuickQFontDialog>(uri, 1, 1, "QtFontDialog");
    }
};

QT_END_NAMESPACE

#include "widgetsplugin.moc"
