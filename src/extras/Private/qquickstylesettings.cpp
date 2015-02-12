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

#include "qquickstylesettings_p.h"
#include <qqmlengine.h>
#include <qfileinfo.h>
#include <qdebug.h>
#include <qdir.h>

QT_BEGIN_NAMESPACE

static QString defaultStyleName()
{
    return QLatin1String("Base");
}

static QString styleImportName()
{
    QString name = qgetenv("QT_QUICK_CONTROLS_STYLE");
    if (name.isEmpty())
        name = defaultStyleName();
    return QFileInfo(name).fileName();
}

static bool isResource(const QString &path)
{
    return path.startsWith(":/");
}

static QString styleImportPath(QQmlEngine *engine, const QString &styleName)
{
    static const char * const stylePaths[] = { "/QtQuick/Extras/Styles", "/QtQuick/Controls/Styles" };
    QString path = qgetenv("QT_QUICK_CONTROLS_STYLE");
    QFileInfo info(path);
    if (isResource(path)) {
        path = info.path();
    } else if (info.isRelative()) {
        bool found = false;
        QStringList importPaths = engine->importPathList();
        importPaths.prepend(QStringLiteral(":/ExtrasImports/"));

        foreach (const QString &import, importPaths) {
            for (unsigned i = 0; i < sizeof(stylePaths) / sizeof(stylePaths[0]); i++) {
                QDir dir(import + QLatin1String(stylePaths[i]));
                if (dir.exists(styleName)) {
                    found = true;
                    path = dir.absolutePath();
                    break;
                }
            }
            if (found)
                break;
        }
        if (!found)
            path = QLatin1String(":/ExtrasImports/QtQuick/Extras/Styles");
    } else {
        path = info.absolutePath();
    }
    return path;
}

QQuickStyleSettings::QQuickStyleSettings(QQmlEngine *engine)
{
    m_name = styleImportName();
    m_path = styleImportPath(engine, m_name);

    QString path = styleFilePath();

    if (!QDir(path).exists()) {
        QString unknownStyle = m_name;
        m_name = defaultStyleName();
        m_path = styleImportPath(engine, m_name);
        qWarning() << "WARNING: Cannot find style" << unknownStyle << "- fallback:" << styleFilePath();
    }

    connect(this, SIGNAL(styleNameChanged()), SIGNAL(styleChanged()));
    connect(this, SIGNAL(stylePathChanged()), SIGNAL(styleChanged()));
}

QUrl QQuickStyleSettings::style() const
{
    QUrl result;
    QString path = styleFilePath();
    if (isResource(path)) {
        result.setScheme("qrc");
        path.remove(0, 1); // remove ':' prefix
        result.setPath(path);
    } else
        result = QUrl::fromLocalFile(path);
    return result;
}

QString QQuickStyleSettings::styleName() const
{
    return m_name;
}

void QQuickStyleSettings::setStyleName(const QString &name)
{
    if (m_name != name) {
        m_name = name;
        emit styleNameChanged();
    }
}

QString QQuickStyleSettings::stylePath() const
{
    return m_path;
}

void QQuickStyleSettings::setStylePath(const QString &path)
{
    if (m_path != path) {
        m_path = path;
        emit stylePathChanged();
    }
}

QString QQuickStyleSettings::styleFilePath() const
{
    return m_path + QLatin1Char('/') + m_name;
}

QT_END_NAMESPACE
