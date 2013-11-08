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

#include "plugin.h"

#include "qquickaction_p.h"
#include "qquickexclusivegroup_p.h"
#include "qquickmenu_p.h"
#include "qquickmenubar_p.h"
#include "qquickstack_p.h"
#include "qquickdesktopiconprovider_p.h"
#include "qquickselectionmode_p.h"
#include "Private/qquickrangemodel_p.h"
#include "Private/qquickwheelarea_p.h"
#include "Private/qquicktooltip_p.h"
#include "Private/qquickcontrolsettings_p.h"
#include "Private/qquickspinboxvalidator_p.h"
#include "Private/qquickabstractstyle_p.h"
#include "Private/qquickcontrolsprivate_p.h"

#ifdef QT_WIDGETS_LIB
#include <QtQuick/qquickimageprovider.h>
#include "Private/qquickstyleitem_p.h"
#endif

QT_BEGIN_NAMESPACE

static const struct {
    const char *type;
    int major, minor;
} qmldir [] = {
    { "ApplicationWindow", 1, 0 },
    { "Button", 1, 0 },
    { "CheckBox", 1, 0 },
    { "ComboBox", 1, 0 },
    { "GroupBox", 1, 0 },
    { "Label", 1, 0 },
    { "MenuBar", 1, 0 },
    { "Menu", 1, 0 },
    { "StackView", 1, 0 },
    { "ProgressBar", 1, 0 },
    { "RadioButton", 1, 0 },
    { "ScrollView", 1, 0 },
    { "Slider", 1, 0 },
    { "SpinBox", 1, 0 },
    { "SplitView", 1, 0 },
    { "StackViewDelegate", 1, 0 },
    { "StackViewTransition", 1, 0 },
    { "StatusBar", 1, 0 },
    { "Switch", 1, 1 },
    { "Tab", 1, 0 },
    { "TabView", 1, 0 },
    { "TableView", 1, 0 },
    { "TableViewColumn", 1, 0 },
    { "TextArea", 1, 0 },
    { "TextField", 1, 0 },
    { "ToolBar", 1, 0 },
    { "ToolButton", 1, 0 },

    { "BusyIndicator", 1, 1 }
};

void QtQuickControlsPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<QQuickAction>(uri, 1, 0, "Action");
    qmlRegisterType<QQuickExclusiveGroup>(uri, 1, 0, "ExclusiveGroup");
    qmlRegisterType<QQuickMenu>(uri, 1, 0, "MenuPrivate");
    qmlRegisterType<QQuickMenuBar>(uri, 1, 0, "MenuBarPrivate");
    qmlRegisterType<QQuickMenuItem>(uri, 1, 0, "MenuItem");
    qmlRegisterUncreatableType<QQuickMenuItemType>(uri, 1, 0, "MenuItemType",
                                                   QLatin1String("Do not create objects of type MenuItemType"));
    qmlRegisterType<QQuickMenuSeparator>(uri, 1, 0, "MenuSeparator");
    qmlRegisterUncreatableType<QQuickMenuBase>(uri, 1, 0, "MenuBase",
                                               QLatin1String("Do not create objects of type MenuBase"));

    qmlRegisterUncreatableType<QQuickStack>(uri, 1, 0, "Stack", QLatin1String("Do not create objects of type Stack"));
    qmlRegisterUncreatableType<QQuickSelectionMode>(uri, 1, 1, "SelectionMode", QLatin1String("Do not create objects of type SelectionMode"));

    const QString filesLocation = fileLocation();
    for (int i = 0; i < int(sizeof(qmldir)/sizeof(qmldir[0])); i++)
        qmlRegisterType(QUrl(filesLocation + "/" + qmldir[i].type + ".qml"), uri, qmldir[i].major, qmldir[i].minor, qmldir[i].type);
}

void QtQuickControlsPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri);

    // Register private API
    const char *private_uri = "QtQuick.Controls.Private";
    qmlRegisterType<QQuickAbstractStyle>(private_uri, 1, 0, "AbstractStyle");
    qmlRegisterType<QQuickPadding>();
    qmlRegisterType<QQuickRangeModel>(private_uri, 1, 0, "RangeModel");
    qmlRegisterType<QQuickWheelArea>(private_uri, 1, 0, "WheelArea");
    qmlRegisterType<QQuickSpinBoxValidator>(private_uri, 1, 0, "SpinBoxValidator");
    qmlRegisterSingletonType<QQuickTooltip>(private_uri, 1, 0, "Tooltip", QQuickControlsPrivate::registerTooltipModule);
    qmlRegisterSingletonType<QQuickControlSettings>(private_uri, 1, 0, "Settings", QQuickControlsPrivate::registerSettingsModule);

#ifdef QT_WIDGETS_LIB
    qmlRegisterType<QQuickStyleItem>(private_uri, 1, 0, "StyleItem");
    engine->addImageProvider("__tablerow", new QQuickTableRowImageProvider);
#endif
    engine->addImageProvider("desktoptheme", new QQuickDesktopIconProvider);
    if (isLoadedFromResource())
        engine->addImportPath(QStringLiteral("qrc:/"));
}

QString QtQuickControlsPlugin::fileLocation() const
{
    if (isLoadedFromResource())
        return "qrc:/QtQuick/Controls";
    return baseUrl().toString();
}

bool QtQuickControlsPlugin::isLoadedFromResource() const
{
    // If one file is missing, it will load all the files from the resource
    QFile file(baseUrl().toLocalFile() + "/ApplicationWindow.qml");
    if (!file.exists())
        return true;
    return false;
}

QT_END_NAMESPACE
