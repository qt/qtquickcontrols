/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#include <QtQml/qqmlextensionplugin.h>
#include <QtQml/qqml.h>
#include <QtQml/qqmlengine.h>

#include "qquickandroidstyle_p.h"
#include "qquickandroid9patch_p.h"

QT_BEGIN_NAMESPACE

class QtQuickControls1AndroidStylePlugin: public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)

public:
    QtQuickControls1AndroidStylePlugin(QObject *parent = 0) : QQmlExtensionPlugin(parent) { }
    void registerTypes(const char *uri);
};

void QtQuickControls1AndroidStylePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<QQuickAndroid9Patch1>(uri, 1, 0, "Android9Patch");
    qmlRegisterType<QQuickAndroidStyle1>(uri, 1, 0, "AndroidStyleBase");
}

QT_END_NAMESPACE

#include "plugin.moc"
