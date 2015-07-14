/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

#include "qquickcontrolsettings_p.h"
#include <qquickitem.h>
#include <qcoreapplication.h>
#include <qdebug.h>
#include <qqmlengine.h>
#include <qlibrary.h>
#include <qdir.h>
#include <QTouchDevice>
#include <QGuiApplication>
#include <QStyleHints>
#if defined(Q_OS_ANDROID) && !defined(Q_OS_ANDROID_NO_SDK)
#include <private/qjnihelpers_p.h>
#endif

QT_BEGIN_NAMESPACE

static QString defaultStyleName()
{
    //Only enable QStyle support when we are using QApplication
#if defined(QT_WIDGETS_LIB) && !defined(Q_OS_IOS) && !defined(Q_OS_ANDROID) && !defined(Q_OS_BLACKBERRY) && !defined(Q_OS_QNX) && !defined(Q_OS_WINRT)
    if (QCoreApplication::instance()->inherits("QApplication"))
        return QLatin1String("Desktop");
#elif defined(Q_OS_ANDROID) && !defined(Q_OS_ANDROID_NO_SDK)
    if (QtAndroidPrivate::androidSdkVersion() >= 11)
        return QLatin1String("Android");
#elif defined(Q_OS_IOS)
    return QLatin1String("iOS");
#elif defined(Q_OS_WINRT) && 0 // Enable once style is ready
    return QLatin1String("WinRT");
#endif
    return QLatin1String("Base");
}

static QString styleImportName()
{
    QString name = qgetenv("QT_QUICK_CONTROLS_STYLE");
    if (name.isEmpty())
        name = defaultStyleName();
    return QFileInfo(name).fileName();
}

static bool fromResource(const QString &path)
{
    return path.startsWith(":/");
}

bool QQuickControlSettings::hasTouchScreen() const
{
// QTBUG-36007
#if defined(Q_OS_ANDROID)
    return true;
#else
    foreach (const QTouchDevice *dev, QTouchDevice::devices())
        if (dev->type() == QTouchDevice::TouchScreen)
            return true;
    return false;
#endif
}

bool QQuickControlSettings::isMobile() const
{
#if defined(Q_OS_IOS) || defined(Q_OS_ANDROID) || defined(Q_OS_BLACKBERRY) || defined(Q_OS_QNX) || defined(Q_OS_WINRT)
    return true;
#else
    return false;
#endif
}

bool QQuickControlSettings::hoverEnabled() const
{
    return !isMobile() || !hasTouchScreen();
}

QString QQuickControlSettings::makeStyleComponentPath(const QString &controlStyleName, const QString &styleDirPath)
{
    return styleDirPath + QStringLiteral("/") + controlStyleName;
}

QUrl QQuickControlSettings::makeStyleComponentUrl(const QString &controlStyleName, QString styleDirPath)
{
    QString styleFilePath = makeStyleComponentPath(controlStyleName, styleDirPath);

    if (styleDirPath.startsWith(QStringLiteral(":/")))
        return QUrl(QStringLiteral("qrc") + styleFilePath);

    return QUrl::fromLocalFile(styleFilePath);
}

QQmlComponent *QQuickControlSettings::styleComponent(const QUrl &styleDirUrl, const QString &controlStyleName, QObject *control)
{
    Q_UNUSED(styleDirUrl); // required for hack that forces this function to be re-called from within QML when style changes

    // QUrl doesn't consider qrc-based URLs as local files, so bypass it here.
    QString styleFilePath = makeStyleComponentPath(controlStyleName, m_styleMap.value(m_name).m_styleDirPath);
    QUrl styleFileUrl;
    if (QFile::exists(styleFilePath)) {
        styleFileUrl = makeStyleComponentUrl(controlStyleName, m_styleMap.value(m_name).m_styleDirPath);
    } else {
        // It's OK for a style to pick and choose which controls it wants to provide style files for.
        styleFileUrl = makeStyleComponentUrl(controlStyleName, m_styleMap.value(QStringLiteral("Base")).m_styleDirPath);
    }

    return new QQmlComponent(qmlEngine(control), styleFileUrl);
}

static QString relativeStyleImportPath(QQmlEngine *engine, const QString &styleName)
{
    QString path;
    bool found = false;
    foreach (const QString &import, engine->importPathList()) {
        QDir dir(import + QStringLiteral("/QtQuick/Controls/Styles"));
        if (dir.exists(styleName)) {
            found = true;
            path = dir.absolutePath();
            break;
        }
        if (found)
            break;
    }
    if (!found)
        path = ":/QtQuick/Controls/Styles";
    return path;
}

static QString styleImportPath(QQmlEngine *engine, const QString &styleName)
{
    QString path = qgetenv("QT_QUICK_CONTROLS_STYLE");
    QFileInfo info(path);
    if (fromResource(path)) {
        path = info.path();
    } else if (info.isRelative()) {
        path = relativeStyleImportPath(engine, styleName);
    } else {
        path = info.absolutePath();
    }
    return path;
}

QQuickControlSettings::QQuickControlSettings(QQmlEngine *engine)
{
    // First, register all style paths in the default style location.
    QDir dir;
    const QString defaultStyle = defaultStyleName();
    dir.setPath(relativeStyleImportPath(engine, defaultStyle));
    dir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    foreach (const QString &styleDirectory, dir.entryList()) {
        findStyle(engine, styleDirectory);
    }

    m_name = styleImportName();

    // If the style name is a path..
    const QString styleNameFromEnvVar = qgetenv("QT_QUICK_CONTROLS_STYLE");
    if (QFile::exists(styleNameFromEnvVar)) {
        StyleData styleData;
        styleData.m_styleDirPath = styleNameFromEnvVar;
        m_styleMap[m_name] = styleData;
    }

    // Then check if the style the user wanted is known to us. Otherwise, use the fallback style.
    if (m_styleMap.contains(m_name)) {
        m_path = m_styleMap.value(m_name).m_styleDirPath;
    } else {
        QString unknownStyle = m_name;
        m_name = defaultStyle;
        m_path = m_styleMap.value(defaultStyle).m_styleDirPath;
        qWarning() << "WARNING: Cannot find style" << unknownStyle << "- fallback:" << styleFilePath();
    }

    // Can't really do anything about this failing here, so don't bother checking...
    resolveCurrentStylePath();

    connect(this, SIGNAL(styleNameChanged()), SIGNAL(styleChanged()));
    connect(this, SIGNAL(stylePathChanged()), SIGNAL(styleChanged()));
}

bool QQuickControlSettings::resolveCurrentStylePath()
{
    if (!m_styleMap.contains(m_name)) {
        qWarning() << "WARNING: Cannot find style" << m_name;
        return false;
    }

    StyleData styleData = m_styleMap.value(m_name);

    if (styleData.m_stylePluginPath.isEmpty())
        return true; // It's not a plugin; don't have to do anything.

    typedef bool (*StyleInitFunc)();
    typedef const char *(*StylePathFunc)();

    QLibrary lib(styleData.m_stylePluginPath);
    if (!lib.load()) {
        qWarning().nospace() << "WARNING: Cannot load plugin " << styleData.m_stylePluginPath
            << " for style " << m_name << ": " << lib.errorString();
        return false;
    }

    // Check for the existence of this first, as we don't want to init if this doesn't exist.
    StyleInitFunc initFunc = (StyleInitFunc) lib.resolve("qt_quick_controls_style_init");
    if (initFunc)
        initFunc();
    StylePathFunc pathFunc = (StylePathFunc) lib.resolve("qt_quick_controls_style_path");
    if (pathFunc) {
        styleData.m_styleDirPath = QString::fromLocal8Bit(pathFunc());
        m_styleMap[m_name] = styleData;
        m_path = styleData.m_styleDirPath;
    }

    return true;
}

void QQuickControlSettings::findStyle(QQmlEngine *engine, const QString &styleName)
{
    QString path = styleImportPath(engine, styleName);
    QDir dir;
    dir.setFilter(QDir::Files | QDir::NoDotAndDotDot);
    dir.setPath(path);
    dir.cd(styleName);

    StyleData styleData;

    foreach (const QString &fileName, dir.entryList()) {
        // This assumes that there is only one library in the style directory,
        // which should be a safe assumption. If at some point it's determined
        // not to be safe, we'll have to resolve the init and path functions
        // here, to be sure that it is the correct library.
        if (QLibrary::isLibrary(fileName)) {
            styleData.m_stylePluginPath = dir.absoluteFilePath(fileName);
            break;
        }
    }

    // If there's no plugin for the style, then the style's files are
    // contained in this directory (which contains a qmldir file instead).
    styleData.m_styleDirPath = dir.absolutePath();

    m_styleMap[styleName] = styleData;
}

QUrl QQuickControlSettings::style() const
{
    QUrl result;
    QString path = styleFilePath();
    if (fromResource(path)) {
        result.setScheme("qrc");
        path.remove(0, 1); // remove ':' prefix
        result.setPath(path);
    } else
        result = QUrl::fromLocalFile(path);
    return result;
}

QString QQuickControlSettings::styleName() const
{
    return m_name;
}

void QQuickControlSettings::setStyleName(const QString &name)
{
    if (m_name != name) {
        QString oldName = m_name;
        m_name = name;

        // Don't change the style if it can't be resolved.
        if (!resolveCurrentStylePath())
            m_name = oldName;
        else
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
    return m_path;
}

extern Q_GUI_EXPORT int qt_defaultDpiX();

qreal QQuickControlSettings::dpiScaleFactor() const
{
#ifndef Q_OS_MAC
    return (qreal(qt_defaultDpiX()) / 96.0);
#endif
    return 1.0;
}

qreal QQuickControlSettings::dragThreshold() const
{
    return qApp->styleHints()->startDragDistance();
}


QT_END_NAMESPACE
