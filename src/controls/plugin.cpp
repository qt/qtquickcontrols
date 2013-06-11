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

#include "qquickaction_p.h"
#include "qquickexclusivegroup_p.h"
#include "qquickmenu_p.h"
#include "qquickmenubar_p.h"
#include "qquickstack_p.h"

#include <qimage.h>
#include <qqml.h>
#include <qqmlengine.h>
#include <qqmlextensionplugin.h>
#include <qquickimageprovider.h>
#include <qquickwindow.h>

QT_BEGIN_NAMESPACE

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

class QtQuickControlsPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")

public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
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

    // Controls in resources file
    qmlRegisterType(QUrl("qrc:/controls/ApplicationWindow.qml"), uri, 1, 0, "ApplicationWindow");
    qmlRegisterType(QUrl("qrc:/controls/Button.qml"), uri, 1, 0, "Button");
    qmlRegisterType(QUrl("qrc:/controls/CheckBox.qml"), uri, 1, 0, "CheckBox");
    qmlRegisterType(QUrl("qrc:/controls/ComboBox.qml"), uri, 1, 0, "ComboBox");
    qmlRegisterType(QUrl("qrc:/controls/GroupBox.qml"), uri, 1, 0, "GroupBox");
    qmlRegisterType(QUrl("qrc:/controls/Label.qml"), uri, 1, 0, "Label");
    qmlRegisterType(QUrl("qrc:/controls/Menu.qml"), uri, 1, 0, "Menu");
    qmlRegisterType(QUrl("qrc:/controls/MenuBar.qml"), uri, 1, 0, "MenuBar");
    qmlRegisterType(QUrl("qrc:/controls/ProgressBar.qml"), uri, 1, 0, "ProgressBar");
    qmlRegisterType(QUrl("qrc:/controls/RadioButton.qml"), uri, 1, 0, "RadioButton");
    qmlRegisterType(QUrl("qrc:/controls/ScrollView.qml"), uri, 1, 0, "ScrollView");
    qmlRegisterType(QUrl("qrc:/controls/Slider.qml"), uri, 1, 0, "Slider");
    qmlRegisterType(QUrl("qrc:/controls/SpinBox.qml"), uri, 1, 0, "SpinBox");
    qmlRegisterType(QUrl("qrc:/controls/SplitView.qml"), uri, 1, 0, "SplitView");
    qmlRegisterType(QUrl("qrc:/controls/StackView.qml"), uri, 1, 0, "StackView");
    qmlRegisterType(QUrl("qrc:/controls/StackViewDelegate.qml"), uri, 1, 0, "StackViewDelegate");
    qmlRegisterType(QUrl("qrc:/controls/StackViewTransition.qml"), uri, 1, 0, "StackViewTransition");
    qmlRegisterType(QUrl("qrc:/controls/StatusBar.qml"), uri, 1, 0, "StatusBar");
    qmlRegisterType(QUrl("qrc:/controls/Tab.qml"), uri, 1, 0, "Tab");
    qmlRegisterType(QUrl("qrc:/controls/TableView.qml"), uri, 1, 0, "TableView");
    qmlRegisterType(QUrl("qrc:/controls/TableViewColumn.qml"), uri, 1, 0, "TableViewColumn");
    qmlRegisterType(QUrl("qrc:/controls/TextField.qml"), uri, 1, 0, "TextField");
    qmlRegisterType(QUrl("qrc:/controls/TabView.qml"), uri, 1, 0, "TabView");
    qmlRegisterType(QUrl("qrc:/controls/TextArea.qml"), uri, 1, 0, "TextArea");
    qmlRegisterType(QUrl("qrc:/controls/ToolBar.qml"), uri, 1, 0, "ToolBar");
    qmlRegisterType(QUrl("qrc:/controls/ToolButton.qml"), uri, 1, 0, "ToolButton");
}

void QtQuickControlsPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri);
    engine->addImageProvider("desktoptheme", new DesktopIconProvider);
}

QT_END_NAMESPACE

#include "plugin.moc"
