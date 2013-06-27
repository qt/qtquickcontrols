/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "qquickrangemodel_p.h"
#include "qquickwheelarea_p.h"
#include "qquicktooltip_p.h"
#include "qquickcontrolsettings_p.h"
#include "qquickspinboxvalidator_p.h"
#include "qquickabstractstyle_p.h"
#include "qquickcontrolsprivate_p.h"

#ifndef QT_NO_WIDGETS
#include "qquickstyleitem_p.h"
#endif

#include <qqml.h>
#include <qqmlextensionplugin.h>

QT_BEGIN_NAMESPACE

class QtQuickControlsPrivatePlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")

public:
    void registerTypes(const char *uri);
};

void QtQuickControlsPrivatePlugin::registerTypes(const char *uri)
{
    qmlRegisterType<QQuickAbstractStyle>(uri, 1, 0, "AbstractStyle");
    qmlRegisterType<QQuickPadding>();
    qmlRegisterType<QQuickRangeModel>(uri, 1, 0, "RangeModel");
    qmlRegisterType<QQuickWheelArea>(uri, 1, 0, "WheelArea");
    qmlRegisterType<QQuickSpinBoxValidator>(uri, 1, 0, "SpinBoxValidator");
    qmlRegisterSingletonType<QQuickTooltip>(uri, 1, 0, "Tooltip", QQuickControlsPrivate::registerTooltipModule);
    qmlRegisterSingletonType<QQuickControlSettings>(uri, 1, 0, "Settings", QQuickControlsPrivate::registerSettingsModule);
#ifndef QT_NO_WIDGETS
    qmlRegisterType<QQuickStyleItem>(uri, 1, 0, "StyleItem");
#endif
}

QT_END_NAMESPACE

#include "plugin.moc"
