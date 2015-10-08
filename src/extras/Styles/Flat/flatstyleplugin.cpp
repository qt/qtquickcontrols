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

#include "flatstyleplugin.h"

#include <QtCore/qglobal.h>
#include <QtCore/qfile.h>
#include <QtCore/qdebug.h>

#include "qquicktexthandle.h"

static void initResources()
{
    Q_INIT_RESOURCE(flatstyle);
}

extern "C" {
    Q_DECL_EXPORT bool qt_quick_controls_style_init()
    {
        initResources();
        return true;
    }

    Q_DECL_EXPORT const char* qt_quick_controls_style_path()
    {
        return ":/ExtrasImports/QtQuick/Controls/Styles/Flat";
    }
}

QT_BEGIN_NAMESPACE

QtQuickExtrasStylesPlugin::QtQuickExtrasStylesPlugin(QObject *parent) :
    QQmlExtensionPlugin(parent)
{
}

void QtQuickExtrasStylesPlugin::registerTypes(const char *uri)
{
    initResources();

    const QString prefix = "qrc:/ExtrasImports/QtQuick/Controls/Styles/Flat/";
    // register version 1.0
    qmlRegisterSingletonType(QUrl(prefix + "FlatStyle.qml"), uri, 1, 0, "FlatStyle");
    qmlRegisterType(QUrl(prefix + "ApplicationWindowStyle.qml"), uri, 1, 0, "ApplicationWindowStyle");
    qmlRegisterType(QUrl(prefix + "BusyIndicatorStyle.qml"), uri, 1, 0, "BusyIndicatorStyle");
    qmlRegisterType(QUrl(prefix + "ButtonStyle.qml"), uri, 1, 0, "ButtonStyle");
    qmlRegisterType(QUrl(prefix + "CalendarStyle.qml"), uri, 1, 0, "CalendarStyle");
    qmlRegisterType(QUrl(prefix + "CheckBoxStyle.qml"), uri, 1, 0, "CheckBoxStyle");
    qmlRegisterType(QUrl(prefix + "CheckBoxDrawer.qml"), uri, 1, 0, "CheckBoxDrawer");
    qmlRegisterType(QUrl(prefix + "CircularButtonStyle.qml"), uri, 1, 0, "CircularButtonStyle");
    qmlRegisterType(QUrl(prefix + "CircularGaugeStyle.qml"), uri, 1, 0, "CircularGaugeStyle");
    qmlRegisterType(QUrl(prefix + "CircularTickmarkLabelStyle.qml"), uri, 1, 0, "CircularTickmarkLabelStyle");
    qmlRegisterType(QUrl(prefix + "ComboBoxStyle.qml"), uri, 1, 0, "ComboBoxStyle");
    qmlRegisterType(QUrl(prefix + "CursorHandleStyle.qml"), uri, 1, 0, "CursorHandleStyle");
    qmlRegisterType(QUrl(prefix + "DelayButtonStyle.qml"), uri, 1, 0, "DelayButtonStyle");
    qmlRegisterType(QUrl(prefix + "FocusFrameStyle.qml"), uri, 1, 0, "FocusFrameStyle");
    qmlRegisterType(QUrl(prefix + "GaugeStyle.qml"), uri, 1, 0, "GaugeStyle");
    qmlRegisterType(QUrl(prefix + "GroupBoxStyle.qml"), uri, 1, 0, "GroupBoxStyle");
    qmlRegisterType(QUrl(prefix + "LeftArrowIcon.qml"), uri, 1, 0, "LeftArrowIcon");
    qmlRegisterType(QUrl(prefix + "MenuBarStyle.qml"), uri, 1, 0, "MenuBarStyle");
    qmlRegisterType(QUrl(prefix + "PieMenuStyle.qml"), uri, 1, 0, "PieMenuStyle");
    qmlRegisterType(QUrl(prefix + "ProgressBarStyle.qml"), uri, 1, 0, "ProgressBarStyle");
    qmlRegisterType(QUrl(prefix + "RadioButtonStyle.qml"), uri, 1, 0, "RadioButtonStyle");
    qmlRegisterType(QUrl(prefix + "ScrollViewStyle.qml"), uri, 1, 0, "ScrollViewStyle");
    qmlRegisterType(QUrl(prefix + "SelectionHandleStyle.qml"), uri, 1, 0, "SelectionHandleStyle");
    qmlRegisterType(QUrl(prefix + "SliderStyle.qml"), uri, 1, 0, "SliderStyle");
    qmlRegisterType(QUrl(prefix + "SpinBoxStyle.qml"), uri, 1, 0, "SpinBoxStyle");
    qmlRegisterType(QUrl(prefix + "StatusBarStyle.qml"), uri, 1, 0, "StatusBarStyle");
    qmlRegisterType(QUrl(prefix + "StatusIndicatorStyle.qml"), uri, 1, 0, "StatusIndicatorStyle");
    qmlRegisterType(QUrl(prefix + "SwitchStyle.qml"), uri, 1, 0, "SwitchStyle");
    qmlRegisterType(QUrl(prefix + "TabViewStyle.qml"), uri, 1, 0, "TabViewStyle");
    qmlRegisterType(QUrl(prefix + "TableViewStyle.qml"), uri, 1, 0, "TableViewStyle");
    qmlRegisterType(QUrl(prefix + "TextAreaStyle.qml"), uri, 1, 0, "TextAreaStyle");
    qmlRegisterType(QUrl(prefix + "TextFieldStyle.qml"), uri, 1, 0, "TextFieldStyle");
    qmlRegisterType(QUrl(prefix + "ToggleButtonStyle.qml"), uri, 1, 0, "ToggleButtonStyle");
    qmlRegisterType(QUrl(prefix + "ToolBarStyle.qml"), uri, 1, 0, "ToolBarStyle");
    qmlRegisterType(QUrl(prefix + "ToolButtonStyle.qml"), uri, 1, 0, "ToolButtonStyle");
    qmlRegisterType(QUrl(prefix + "ToolButtonBackground.qml"), uri, 1, 0, "ToolButtonBackground");
    qmlRegisterType(QUrl(prefix + "ToolButtonIndicator.qml"), uri, 1, 0, "ToolButtonIndicator");
    qmlRegisterType(QUrl(prefix + "TumblerStyle.qml"), uri, 1, 0, "TumblerStyle");
    qmlRegisterType<QQuickTextHandle>("QtQuick.Controls.Styles.Flat", 1, 0, "TextHandle");
}

QT_END_NAMESPACE
