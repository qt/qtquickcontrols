/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
**
****************************************************************************/

#ifndef QQUICKCONTROLSETTINGS_P_H
#define QQUICKCONTROLSETTINGS_P_H

#include <QtCore/qurl.h>
#include <QtCore/qobject.h>
#include <QtCore/qstring.h>
#include <QtCore/qhash.h>
#include <QtQml/qqmlcomponent.h>

QT_BEGIN_NAMESPACE

class QQmlEngine;

class QQuickControlSettings1 : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl style READ style NOTIFY styleChanged)
    Q_PROPERTY(QString styleName READ styleName WRITE setStyleName NOTIFY styleNameChanged)
    Q_PROPERTY(QString stylePath READ stylePath WRITE setStylePath NOTIFY stylePathChanged)
    Q_PROPERTY(qreal dpiScaleFactor READ dpiScaleFactor CONSTANT)
    Q_PROPERTY(qreal dragThreshold READ dragThreshold CONSTANT)
    Q_PROPERTY(bool hasTouchScreen READ hasTouchScreen CONSTANT)
    Q_PROPERTY(bool isMobile READ isMobile CONSTANT)
    Q_PROPERTY(bool hoverEnabled READ hoverEnabled CONSTANT)

public:
    QQuickControlSettings1(QQmlEngine *engine);

    QUrl style() const;

    QString styleName() const;
    void setStyleName(const QString &name);

    QString stylePath() const;
    void setStylePath(const QString &path);

    qreal dpiScaleFactor() const;
    qreal dragThreshold() const;

    bool hasTouchScreen() const;
    bool isMobile() const;
    bool hoverEnabled() const;

    Q_INVOKABLE QQmlComponent *styleComponent(const QUrl &styleDirUrl,
        const QString &controlStyleName, QObject *control);

signals:
    void styleChanged();
    void styleNameChanged();
    void stylePathChanged();

private:
    QString styleFilePath() const;
    void findStyle(QQmlEngine *engine, const QString &styleName);
    bool resolveCurrentStylePath();
    QString makeStyleComponentPath(const QString &controlStyleName, const QString &styleDirPath);
    QUrl makeStyleComponentUrl(const QString &controlStyleName, const QString &styleDirPath);

    struct StyleData
    {
        // Path to the style's plugin or qmldir file.
        QString m_stylePluginPath;
        // Path to the directory containing the style's files.
        QString m_styleDirPath;
    };

    QString m_name;
    QString m_path;
    QHash<QString, StyleData> m_styleMap;
    QQmlEngine *m_engine;
};

QT_END_NAMESPACE

#endif // QQUICKCONTROLSETTINGS_P_H
