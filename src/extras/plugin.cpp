/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Extras module of the Qt Toolkit.
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

#include "plugin.h"

#include <QtCore/qfile.h>

#include "qquickpicture_p.h"
#include "qquicktriggermode_p.h"
#include "Private/qquickcircularprogressbar_p.h"
#include "Private/qquickflatprogressbar_p.h"
#include "Private/qquickmousethief_p.h"
#include "Private/qquickmathutils_p.h"

static void initResources()
{
    Q_INIT_RESOURCE(extras);
}

QT_BEGIN_NAMESPACE

static QObject *registerMathUtilsSingleton(QQmlEngine *engine, QJSEngine *jsEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(jsEngine);
    return new QQuickMathUtils();
}

QtQuickExtrasPlugin::QtQuickExtrasPlugin(QObject *parent) :
    QQmlExtensionPlugin(parent)
{
}

void QtQuickExtrasPlugin::registerTypes(const char *uri)
{
    initResources();
    const QString prefix = "qrc:///ExtrasImports/QtQuick/Extras";
    // Register public API.
    qmlRegisterUncreatableType<QQuickActivationMode>(uri, 1, 0, "ActivationMode", QLatin1String("Do not create objects of type ActivationMode"));
    // register 1.0
    qmlRegisterType(QUrl(prefix + "/CircularGauge.qml"), uri, 1, 0, "CircularGauge");
    qmlRegisterType(QUrl(prefix + "/DelayButton.qml"), uri, 1, 0, "DelayButton");
    qmlRegisterType(QUrl(prefix + "/Dial.qml"), uri, 1, 0, "Dial");
    qmlRegisterType(QUrl(prefix + "/Gauge.qml"), uri, 1, 0, "Gauge");
    qmlRegisterType(QUrl(prefix + "/PieMenu.qml"), uri, 1, 0, "PieMenu");
    qmlRegisterType(QUrl(prefix + "/StatusIndicator.qml"), uri, 1, 0, "StatusIndicator");
    qmlRegisterType(QUrl(prefix + "/ToggleButton.qml"), uri, 1, 0, "ToggleButton");
    // register 1.1
    qmlRegisterType(QUrl(prefix + "/Dial.qml"), uri, 1, 1, "Dial");
    qmlRegisterType(QUrl(prefix + "/StatusIndicator.qml"), uri, 1, 1, "StatusIndicator");
    // register 1.2
    qmlRegisterType(QUrl(prefix + "/Tumbler.qml"), uri, 1, 2, "Tumbler");
    qmlRegisterType(QUrl(prefix + "/TumblerColumn.qml"), uri, 1, 2, "TumblerColumn");
    // register 1.3
    qmlRegisterUncreatableType<QQuickTriggerMode>(uri, 1, 3, "TriggerMode", QLatin1String("Do not create objects of type TriggerMode"));
    // register 1.4
    qmlRegisterType<QQuickPicture>(uri, 1, 4, "Picture");
}

void QtQuickExtrasPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    Q_UNUSED(engine);
    qmlRegisterType<QQuickMouseThief>("QtQuick.Extras.Private.CppUtils", 1, 0, "MouseThief");
    qmlRegisterType<QQuickCircularProgressBar>("QtQuick.Extras.Private.CppUtils", 1, 1, "CircularProgressBar");
    qmlRegisterType<QQuickFlatProgressBar>("QtQuick.Extras.Private.CppUtils", 1, 1, "FlatProgressBar");
    qmlRegisterSingletonType<QQuickMathUtils>("QtQuick.Extras.Private.CppUtils", 1, 0, "MathUtils", registerMathUtilsSingleton);

    const QString prefix = "qrc:///ExtrasImports/QtQuick/Extras";
    const char *private_uri = "QtQuick.Extras.Private";
    qmlRegisterType(QUrl(prefix + "/Private/CircularButton.qml"), private_uri, 1, 0, "CircularButton");
    qmlRegisterType(QUrl(prefix + "/Private/CircularButtonStyleHelper.qml"), private_uri, 1, 0, "CircularButtonStyleHelper");
    qmlRegisterType(QUrl(prefix + "/Private/CircularTickmarkLabel.qml"), private_uri, 1, 0, "CircularTickmarkLabel");
    qmlRegisterType(QUrl(prefix + "/Private/Handle.qml"), private_uri, 1, 0, "Handle");
    qmlRegisterType(QUrl(prefix + "/Private/PieMenuIcon.qml"), private_uri, 1, 0, "PieMenuIcon");
    qmlRegisterSingletonType(QUrl(prefix + "/Private/TextSingleton.qml"), private_uri, 1, 0, "TextSingleton");
}

QT_END_NAMESPACE
