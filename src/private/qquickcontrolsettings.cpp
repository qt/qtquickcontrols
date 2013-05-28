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

#include "qquickcontrolsettings_p.h"
#include <qquickitem.h>
#include <qcoreapplication.h>
#include <qqmlengine.h>
#include <qdir.h>

QT_BEGIN_NAMESPACE

static QString defaultStyleName()
{
    //Only enable QStyle support when we are using QApplication
    if (QCoreApplication::instance()->inherits("QApplication"))
        return QLatin1String("Desktop");
    return QLatin1String("Base");
}

static QString styleImportName()
{
    QString name = qgetenv("QT_QUICK_CONTROLS_STYLE");
    if (name.isEmpty())
        name = defaultStyleName();
    return QFileInfo(name).fileName();
}

static QString styleImportPath(QQmlEngine *engine, const QString &styleName)
{
    QString path = qgetenv("QT_QUICK_CONTROLS_STYLE");
    QFileInfo info(path);
    if (info.isRelative()) {
        foreach (const QString &import, engine->importPathList()) {
            QDir dir(import + QLatin1String("/QtQuick/Controls/Styles"));
            if (dir.exists(styleName)) {
                path = dir.absolutePath();
                break;
            }
        }
    } else {
        path = info.absolutePath();
    }
    return path;
}

QQuickControlSettings::QQuickControlSettings(QQmlEngine *engine)
{
    m_name = styleImportName();
    m_path = styleImportPath(engine, m_name);

    if (!QFile::exists(styleFilePath())) {
        QString unknownStyle = m_name;
        m_name = defaultStyleName();
        m_path = styleImportPath(engine, m_name);
        qWarning() << "WARNING: Cannot find style" << unknownStyle << "- fallback:" << styleFilePath();
    }

    connect(this, SIGNAL(styleNameChanged()), SIGNAL(styleChanged()));
    connect(this, SIGNAL(stylePathChanged()), SIGNAL(styleChanged()));
}

QUrl QQuickControlSettings::style() const
{
    return QUrl::fromLocalFile(styleFilePath());
}

QString QQuickControlSettings::styleName() const
{
    return m_name;
}

void QQuickControlSettings::setStyleName(const QString &name)
{
    if (m_name != name) {
        m_name = name;
        emit styleNameChanged();
    }
}

QString QQuickControlSettings::stylePath() const
{
    return m_path;
}

void QQuickControlSettings::setStylePath(const QString &path)
{
    if (m_path != path) {
        m_path = path;
        emit stylePathChanged();
    }
}

QString QQuickControlSettings::styleFilePath() const
{
    return m_path + QLatin1Char('/') + m_name;
}

extern Q_GUI_EXPORT int qt_defaultDpiX();

qreal QQuickControlSettings::dpiScaleFactor() const
{
#ifndef Q_OS_MAC
    return (qreal(qt_defaultDpiX()) / 96.0);
#endif
    return 1.0;
}


QT_END_NAMESPACE
