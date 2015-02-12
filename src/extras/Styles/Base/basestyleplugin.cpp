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
#include "basestyleplugin.h"

QT_BEGIN_NAMESPACE

QtQuickExtrasStylesPlugin::QtQuickExtrasStylesPlugin(QObject *parent) :
    QQmlExtensionPlugin(parent)
{
}

void QtQuickExtrasStylesPlugin::registerTypes(const char *uri)
{
    Q_INIT_RESOURCE(basestyle);
    const QString prefix = "qrc:/ExtrasImports/QtQuick/Extras/Styles";
    // register version 1.0
    qmlRegisterType(QUrl(prefix + "/Base/CircularButtonStyle.qml"), uri, 1, 0, "CircularButtonStyle");
    qmlRegisterType(QUrl(prefix + "/Base/CircularGaugeStyle.qml"), uri, 1, 0, "CircularGaugeStyle");
    qmlRegisterType(QUrl(prefix + "/Base/CircularTickmarkLabelStyle.qml"), uri, 1, 0, "CircularTickmarkLabelStyle");
    qmlRegisterType(QUrl(prefix + "/Base/CommonStyleHelper.qml"), uri, 1, 0, "CommonStyleHelper");
    qmlRegisterType(QUrl(prefix + "/Base/DelayButtonStyle.qml"), uri, 1, 0, "DelayButtonStyle");
    qmlRegisterType(QUrl(prefix + "/Base/DialStyle.qml"), uri, 1, 0, "DialStyle");
    qmlRegisterType(QUrl(prefix + "/Base/GaugeStyle.qml"), uri, 1, 0, "GaugeStyle");
    qmlRegisterType(QUrl(prefix + "/Base/HandleStyleHelper.qml"), uri, 1, 0, "HandleStyleHelper");
    qmlRegisterType(QUrl(prefix + "/Base/HandleStyle.qml"), uri, 1, 0, "HandleStyle");
    qmlRegisterType(QUrl(prefix + "/Base/PieMenuStyle.qml"), uri, 1, 0, "PieMenuStyle");
    qmlRegisterType(QUrl(prefix + "/Base/ToggleButtonStyle.qml"), uri, 1, 0, "ToggleButtonStyle");
    // register version 1.1
    qmlRegisterType(QUrl(prefix + "/Base/DialStyle.qml"), uri, 1, 1, "DialStyle");
    qmlRegisterType(QUrl(prefix + "/Base/StatusIndicatorStyle.qml"), uri, 1, 1, "StatusIndicatorStyle");
    // register version 1.2
    qmlRegisterType(QUrl(prefix + "/Base/TumblerStyle.qml"), uri, 1, 2, "TumblerStyle");
    // register version 1.3
    qmlRegisterType(QUrl(prefix + "/Base/PieMenuStyle.qml"), uri, 1, 3, "PieMenuStyle");
}

QT_END_NAMESPACE
