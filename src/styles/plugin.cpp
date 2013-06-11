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

#include <QtQml>

QT_BEGIN_NAMESPACE

class QtQuickControlsStylesPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")

public:
    void registerTypes(const char *uri);
    void initializeEngine(QQmlEngine *engine, const char *uri);
};

void QtQuickControlsStylesPlugin::registerTypes(const char *uri)
{
    qmlRegisterType(QUrl("qrc:/Base/ButtonStyle.qml"), uri, 1, 0, "ButtonStyle");
    qmlRegisterType(QUrl("qrc:/Base/CheckBoxStyle.qml"), uri, 1, 0, "CheckBoxStyle");
    qmlRegisterType(QUrl("qrc:/Base/ComboBoxStyle.qml"), uri, 1, 0, "ComboBoxStyle");
    qmlRegisterType(QUrl("qrc:/Base/ProgressBarStyle.qml"), uri, 1, 0, "ProgressBarStyle");
    qmlRegisterType(QUrl("qrc:/Base/RadioButtonStyle.qml"), uri, 1, 0, "RadioButtonStyle");
    qmlRegisterType(QUrl("qrc:/Base/ScrollViewStyle.qml"), uri, 1, 0, "ScrollViewStyle");
    qmlRegisterType(QUrl("qrc:/Base/SliderStyle.qml"), uri, 1, 0, "SliderStyle");
    qmlRegisterType(QUrl("qrc:/Base/TabViewStyle.qml"), uri, 1, 0, "TabViewStyle");
    qmlRegisterType(QUrl("qrc:/Base/TableViewStyle.qml"), uri, 1, 0, "TableViewStyle");
    qmlRegisterType(QUrl("qrc:/Base/TextFieldStyle.qml"), uri, 1, 0, "TextFieldStyle");
}

void QtQuickControlsStylesPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    Q_UNUSED(uri)
    engine->addPluginPath("qrc:/Base");
}

QT_END_NAMESPACE

#include "plugin.moc"
