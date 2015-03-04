/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Layouts module of the Qt Toolkit.
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

#include "qquicklinearlayout_p.h"
#include "qquickstacklayout_p.h"

QT_BEGIN_NAMESPACE

//![class decl]
class QtQuickLayoutsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")
public:
    virtual void registerTypes(const char *uri)
    {
        Q_ASSERT(QLatin1String(uri) == QLatin1String("QtQuick.Layouts"));
        Q_UNUSED(uri);

        qmlRegisterType<QQuickRowLayout>(uri, 1, 0, "RowLayout");
        qmlRegisterType<QQuickColumnLayout>(uri, 1, 0, "ColumnLayout");
        qmlRegisterType<QQuickGridLayout>(uri, 1, 0, "GridLayout");
        qmlRegisterType<QQuickStackLayout>(uri, 1, 3, "StackLayout");
        qmlRegisterUncreatableType<QQuickLayout>(uri, 1, 0, "Layout",
                                                           QStringLiteral("Do not create objects of type Layout"));
        qmlRegisterUncreatableType<QQuickLayout>(uri, 1, 2, "Layout",
                                                           QStringLiteral("Do not create objects of type Layout"));
        qmlRegisterRevision<QQuickGridLayoutBase, 1>(uri, 1, 1);
    }
};
//![class decl]

QT_END_NAMESPACE

#include "plugin.moc"
